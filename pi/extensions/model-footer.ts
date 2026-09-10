import { isAbsolute, relative, resolve, sep } from "node:path";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { truncateToWidth } from "@earendil-works/pi-tui";

type Usage = {
	input: number;
	output: number;
	cacheRead: number;
	cacheWrite: number;
	cost: { total: number };
};

function formatTokens(count: number): string {
	if (count < 1_000) return count.toString();
	if (count < 10_000) return `${(count / 1_000).toFixed(1)}k`;
	if (count < 1_000_000) return `${Math.round(count / 1_000)}k`;
	if (count < 10_000_000) return `${(count / 1_000_000).toFixed(1)}M`;
	return `${Math.round(count / 1_000_000)}M`;
}

function formatCwd(cwd: string, home: string | undefined): string {
	if (!home) return cwd;

	const resolvedCwd = resolve(cwd);
	const resolvedHome = resolve(home);
	const relativeToHome = relative(resolvedHome, resolvedCwd);
	const isInsideHome =
		relativeToHome === "" ||
		(relativeToHome !== ".." && !relativeToHome.startsWith(`..${sep}`) && !isAbsolute(relativeToHome));

	if (!isInsideHome) return cwd;
	return relativeToHome === "" ? "~" : `~${sep}${relativeToHome}`;
}

function sanitizeStatus(text: string): string {
	return text
		.replace(/[\r\n\t]/g, " ")
		.replace(/ +/g, " ")
		.trim();
}

export default function modelFooter(pi: ExtensionAPI) {
	pi.on("session_start", (_event, ctx) => {
		ctx.ui.setFooter((tui, theme, footerData) => {
			const unsubscribe = footerData.onBranchChange(() => tui.requestRender());

			return {
				dispose: unsubscribe,
				invalidate() {},
				render(width: number): string[] {
					const totals = { input: 0, output: 0, cacheRead: 0, cacheWrite: 0, cost: 0 };
					let latestCacheHitRate: number | undefined;

					const addUsage = (usage: Usage) => {
						totals.input += usage.input;
						totals.output += usage.output;
						totals.cacheRead += usage.cacheRead;
						totals.cacheWrite += usage.cacheWrite;
						totals.cost += usage.cost.total;
					};

					for (const entry of ctx.sessionManager.getEntries()) {
						if (entry.type === "message" && entry.message.role === "assistant") {
							addUsage(entry.message.usage);
							const promptTokens =
								entry.message.usage.input + entry.message.usage.cacheRead + entry.message.usage.cacheWrite;
							latestCacheHitRate = promptTokens > 0 ? (entry.message.usage.cacheRead / promptTokens) * 100 : undefined;
						} else if (entry.type === "message" && entry.message.role === "toolResult" && entry.message.usage) {
							addUsage(entry.message.usage);
						} else if ((entry.type === "branch_summary" || entry.type === "compaction") && entry.usage) {
							addUsage(entry.usage);
						}
					}

					let pwd = formatCwd(ctx.sessionManager.getCwd(), process.env.HOME || process.env.USERPROFILE);
					const branch = footerData.getGitBranch();
					if (branch) pwd = `${pwd} (${branch})`;
					const sessionName = ctx.sessionManager.getSessionName();
					if (sessionName) pwd = `${pwd} • ${sessionName}`;

					const tokenParts: string[] = [];
					if (totals.input) tokenParts.push(`↑${formatTokens(totals.input)}`);
					if (totals.output) tokenParts.push(`↓${formatTokens(totals.output)}`);
					if (totals.cacheRead) tokenParts.push(`CR${formatTokens(totals.cacheRead)}`);
					if (totals.cacheWrite) tokenParts.push(`CW${formatTokens(totals.cacheWrite)}`);
					if ((totals.cacheRead || totals.cacheWrite) && latestCacheHitRate !== undefined) {
						tokenParts.push(`CH${latestCacheHitRate.toFixed(1)}%`);
					}
					const statsParts = tokenParts.map((part) => theme.fg("warning", part));

					const contextUsage = ctx.getContextUsage();
					const contextWindow = contextUsage?.contextWindow ?? ctx.model?.contextWindow ?? 0;
					const contextPercentValue = contextUsage?.percent ?? 0;
					const contextDisplay =
						contextUsage?.percent === null
							? `?/${formatTokens(contextWindow)}`
							: `${contextPercentValue.toFixed(1)}%/${formatTokens(contextWindow)}`;
					const contextTokens = contextUsage?.tokens;
					if (contextTokens == null) statsParts.push(theme.fg("dim", contextDisplay));
					else if (contextTokens >= 170_000) statsParts.push(theme.fg("error", contextDisplay));
					else if (contextTokens >= 100_000) statsParts.push(theme.fg("warning", contextDisplay));
					else statsParts.push(theme.fg("success", contextDisplay));

					const modelName = ctx.model?.id ?? "no-model";
					let modelText = modelName;
					if (ctx.model?.reasoning) {
						const thinkingLevel = ctx.thinkingLevel ?? "off";
						modelText = thinkingLevel === "off" ? `${modelName} • thinking off` : `${modelName} • ${thinkingLevel}`;
					}

					if (ctx.model) modelText = `(${ctx.model.provider}) ${modelText}`;

					const extensionStatuses = footerData.getExtensionStatuses();
					const mcpStatus = extensionStatuses.get("mcp");
					const inlineParts = [theme.fg("borderAccent", modelText), statsParts.join(" ")];
					if (mcpStatus) {
						const compactStatus = sanitizeStatus(mcpStatus)
							.replace(/🔌\s*/, "")
							.replace(/MCP:/, "⚒")
							.replace(
								/(\d+) (?:servers? )?enabled( \(\d+ connected\))?(?: \((\d+) disabled\))?/,
								(_match, enabled: string, connected: string | undefined, disabled: string | undefined) =>
									`${enabled}/${Number(enabled) + Number(disabled ?? 0)}${connected ?? ""}`,
							);
						inlineParts.push(compactStatus);
					}
					// These providers use subscription billing even though their credentials resemble API keys.
					const usingSubscription =
						ctx.model !== undefined && ["github-copilot", "openai-codex", "kimi-coding"].includes(ctx.model.provider);
					if (totals.cost || usingSubscription) {
						inlineParts.push(theme.fg("dim", `$${totals.cost.toFixed(3)}${usingSubscription ? " (sub)" : ""}`));
					}
					const statsLine = truncateToWidth(inlineParts.join("  "), width, theme.fg("dim", "..."));

					const lines = [truncateToWidth(theme.fg("dim", pwd), width, theme.fg("dim", "...")), statsLine];

					const remainingStatuses = Array.from(extensionStatuses.entries()).filter(([key]) => key !== "mcp");
					if (remainingStatuses.length > 0) {
						const statusLine = remainingStatuses
							.sort(([left], [right]) => left.localeCompare(right))
							.map(([, text]) => sanitizeStatus(text))
							.join(" ");
						lines.push(truncateToWidth(statusLine, width, theme.fg("dim", "...")));
					}

					return lines;
				},
			};
		});
	});
}
