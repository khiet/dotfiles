# Find leftover app files across common macOS support locations.
scan_app_leftovers () {
	local strict=0
	local no_filter=0

	# Parse flags
	while [[ "$1" == --* ]]; do
		case "$1" in
			--strict) strict=1; shift ;;
			--no-filter) no_filter=1; shift ;;
			--help|-h)
				echo "Usage: scan_app_leftovers [--strict] [--no-filter] <keyword> [maxdepth]"
				echo ""
				echo "Arguments:"
				echo "  keyword      String to search for in file/folder names"
				echo "  maxdepth     Maximum directory depth to search (default: 3)"
				echo ""
				echo "Flags:"
				echo "  --strict     Match keyword as a whole word (reduces false positives)"
				echo "  --no-filter  Disable built-in noise filter (Apple/system caches)"
				echo ""
				echo "Examples:"
				echo "  scan_app_leftovers spotify"
				echo "  scan_app_leftovers --strict sol"
				echo "  scan_app_leftovers com.spotify.client 4"
				return 0
				;;
			*) echo "Unknown flag: $1"; return 1 ;;
		esac
	done

	if [ -z "$1" ]; then
		echo "Usage: scan_app_leftovers [--strict] [--no-filter] <keyword> [maxdepth]"
		echo "Run with --help for details."
		return 1
	fi

	local keyword="$1"
	local maxdepth="${2:-3}"

	# Built-in noise filter: known false-positive paths from Apple/system/other apps
	local noise_patterns=(
		"/com.apple."
		"/group.com.apple."
		"/Apple/"
		"/Steam/"
		"/Logic/"
		"/GarageBand/"
		"/Final Cut Pro/"
		"/MainStage/"
		"/GeoServices/"
		"/SentryCrash/"
		"/Homebrew/downloads/"
		"/Homebrew/Cask/"
	)
	local folders=(
		# User-level Library
		"$HOME/Library/Application Support"
		"$HOME/Library/Application Scripts"
		"$HOME/Library/Preferences"
		"$HOME/Library/Caches"
		"$HOME/Library/Logs"
		"$HOME/Library/Containers"
		"$HOME/Library/Group Containers"
		"$HOME/Library/Saved Application State"
		"$HOME/Library/LaunchAgents"
		"$HOME/Library/HTTPStorages"
		"$HOME/Library/WebKit"
		"$HOME/Library/Cookies"
		"$HOME/Library/PreferencePanes"
		"$HOME/Library/Internet Plug-Ins"
		"$HOME/Library/Input Methods"
		"$HOME/Library/Developer"

		# System-level Library
		"/Library/Application Support"
		"/Library/Preferences"
		"/Library/Caches"
		"/Library/Logs"
		"/Library/LaunchAgents"
		"/Library/LaunchDaemons"
		"/Library/PrivilegedHelperTools"
		"/Library/PreferencePanes"
		"/Library/Internet Plug-Ins"
		"/Library/Extensions"
		"/Library/Frameworks"

		# Applications
		"/Applications"
		"$HOME/Applications"

		# Installer receipts
		"/private/var/db/receipts"
	)

	# Add Homebrew locations if brew is installed
	if command -v brew >/dev/null 2>&1; then
		local brew_prefix
		brew_prefix=$(brew --prefix)
		folders+=(
			"$brew_prefix/Caskroom"
			"$brew_prefix/Cellar"
			"$brew_prefix/etc"
			"$brew_prefix/var"
		)
	fi

	# Folders to additionally grep inside plist contents
	local plist_folders=(
		"$HOME/Library/LaunchAgents"
		"/Library/LaunchAgents"
		"/Library/LaunchDaemons"
	)

	local total=0
	local filtered_total=0
	local folder match matches plist_matches login_items launchctl_matches
	local -a all_matches=()
	local -a action_brew=()
	local -a action_rm_user=()
	local -a action_rm_sudo=()
	local -a action_rm_container=()
	local -a action_login=()
	local -a action_launchctl=()
	local pattern noise skip

	# Color support (only if stdout is a terminal)
	local C_RESET="" C_BOLD="" C_DIM="" C_BLUE="" C_GREEN="" C_YELLOW="" C_CYAN="" C_RED=""
	if [ -t 1 ]; then
		C_RESET=$'\e[0m'
		C_BOLD=$'\e[1m'
		C_DIM=$'\e[2m'
		C_BLUE=$'\e[34m'
		C_GREEN=$'\e[32m'
		C_YELLOW=$'\e[33m'
		C_CYAN=$'\e[36m'
		C_RED=$'\e[31m'
	fi

	# Build find pattern: strict uses word boundaries, default uses substring
	if [ "$strict" -eq 1 ]; then
		pattern=".*[^a-zA-Z0-9]${keyword}([^a-zA-Z0-9].*)?"
	fi

	local mode_label="substring"
	[ "$strict" -eq 1 ] && mode_label="strict (word-boundary)"
	[ "$no_filter" -eq 1 ] && mode_label="$mode_label, no-filter"

	# Helper: classify a path into the right action bucket
	classify_path () {
		local p="$1"
		case "$p" in
			/Applications/*|/opt/homebrew/Caskroom/*|/usr/local/Caskroom/*|/opt/homebrew/Cellar/*|/usr/local/Cellar/*)
				action_brew+=("$p") ;;
			"$HOME/Library/Containers/"*|"$HOME/Library/Group Containers/"*|"$HOME/Library/Application Scripts/"*)
				action_rm_container+=("$p") ;;
			/Library/*|/private/*|/opt/*|/usr/*)
				action_rm_sudo+=("$p") ;;
			"$HOME/"*)
				action_rm_user+=("$p") ;;
			*)
				action_rm_sudo+=("$p") ;;
		esac
	}

	echo ""
	echo "${C_BOLD}${C_BLUE}╔══════════════════════════════════════════════════════════════╗${C_RESET}"
	echo "${C_BOLD}${C_BLUE}║${C_RESET} ${C_BOLD}SCAN: ${C_CYAN}$keyword${C_RESET}"
	echo "${C_BOLD}${C_BLUE}║${C_RESET} ${C_DIM}maxdepth=$maxdepth · mode=$mode_label${C_RESET}"
	echo "${C_BOLD}${C_BLUE}╚══════════════════════════════════════════════════════════════╝${C_RESET}"

	# ─────────────────────────────────────────
	# Section 1: File/folder scan
	# ─────────────────────────────────────────
	echo ""
	echo "${C_BOLD}── Files & Folders ──${C_RESET}"

	for folder in "${folders[@]}"; do
		if [ -d "$folder" ]; then
			matches=()

			if [ "$strict" -eq 1 ]; then
				while IFS= read -r match; do
					matches+=("$match")
				done < <(find -E "$folder" -maxdepth "$maxdepth" -iregex "$pattern" 2>/dev/null)
			else
				while IFS= read -r match; do
					matches+=("$match")
				done < <(find "$folder" -maxdepth "$maxdepth" -iname "*$keyword*" 2>/dev/null)
			fi

			# Apply noise filter
			if [ "$no_filter" -eq 0 ] && [ ${#matches[@]} -gt 0 ]; then
				local kept=()
				for match in "${matches[@]}"; do
					skip=0
					for noise in "${noise_patterns[@]}"; do
						if [[ "$match" == *"$noise"* ]]; then
							skip=1
							filtered_total=$((filtered_total + 1))
							break
						fi
					done
					[ "$skip" -eq 0 ] && kept+=("$match")
				done
				matches=("${kept[@]}")
			fi

			if [ ${#matches[@]} -gt 0 ]; then
				total=$((total + ${#matches[@]}))
				all_matches+=("${matches[@]}")

				echo ""
				echo "${C_DIM}$folder${C_RESET} ${C_YELLOW}(${#matches[@]})${C_RESET}"
				for match in "${matches[@]}"; do
					echo "  ${C_GREEN}•${C_RESET} $match"
					classify_path "$match"
				done
			fi
		fi
	done

	[ "$total" -eq 0 ] && echo "${C_DIM}  (no matches)${C_RESET}"

	# ─────────────────────────────────────────
	# Section 2: Plist content scan
	# ─────────────────────────────────────────
	echo ""
	echo "${C_BOLD}── LaunchAgents/Daemons (plist contents) ──${C_RESET}"

	local plist_found=0
	for folder in "${plist_folders[@]}"; do
		if [ -d "$folder" ]; then
			plist_matches=$(grep -rli "$keyword" "$folder" 2>/dev/null)
			if [ -n "$plist_matches" ]; then
				plist_found=1
				echo ""
				echo "${C_DIM}$folder${C_RESET}"
				while IFS= read -r match; do
					[ -z "$match" ] && continue
					echo "  ${C_GREEN}•${C_RESET} $match"
					classify_path "$match"
					total=$((total + 1))
				done <<< "$plist_matches"
			fi
		fi
	done
	[ "$plist_found" -eq 0 ] && echo "${C_DIM}  (none)${C_RESET}"

	# ─────────────────────────────────────────
	# Section 3: Login items
	# ─────────────────────────────────────────
	echo ""
	echo "${C_BOLD}── Login Items ──${C_RESET}"
	login_items=$(osascript -e 'tell application "System Events" to get the name of every login item' 2>/dev/null | tr ',' '\n' | sed 's/^ *//;s/ *$//' | grep -i "$keyword")
	if [ -n "$login_items" ]; then
		while IFS= read -r item; do
			[ -z "$item" ] && continue
			echo "  ${C_GREEN}•${C_RESET} $item"
			action_login+=("$item")
		done <<< "$login_items"
	else
		echo "${C_DIM}  (none)${C_RESET}"
	fi

	# ─────────────────────────────────────────
	# Section 4: launchctl services
	# ─────────────────────────────────────────
	echo ""
	echo "${C_BOLD}── Loaded launchctl Services ──${C_RESET}"
	launchctl_matches=$(launchctl list 2>/dev/null | grep -i "$keyword")
	if [ -n "$launchctl_matches" ]; then
		while IFS= read -r line; do
			[ -z "$line" ] && continue
			echo "  ${C_GREEN}•${C_RESET} $line"
			# 3rd column is the label
			local label=$(echo "$line" | awk '{print $3}')
			[ -n "$label" ] && action_launchctl+=("$label")
		done <<< "$launchctl_matches"
	else
		echo "${C_DIM}  (none)${C_RESET}"
	fi

	# ─────────────────────────────────────────
	# Summary
	# ─────────────────────────────────────────
	echo ""
	echo "${C_BOLD}${C_BLUE}── Summary ──${C_RESET}"
	echo "  Files/folders matched: ${C_BOLD}$total${C_RESET}"
	if [ "$no_filter" -eq 0 ] && [ "$filtered_total" -gt 0 ]; then
		echo "  ${C_DIM}Filtered noise: $filtered_total (use --no-filter to see)${C_RESET}"
	fi
	echo "  Login items: ${C_BOLD}${#action_login[@]}${C_RESET}"
	echo "  launchctl services: ${C_BOLD}${#action_launchctl[@]}${C_RESET}"

	# ─────────────────────────────────────────
	# Cleanup actions
	# ─────────────────────────────────────────
	local has_actions=0
	[ ${#action_brew[@]} -gt 0 ] && has_actions=1
	[ ${#action_rm_user[@]} -gt 0 ] && has_actions=1
	[ ${#action_rm_container[@]} -gt 0 ] && has_actions=1
	[ ${#action_rm_sudo[@]} -gt 0 ] && has_actions=1
	[ ${#action_login[@]} -gt 0 ] && has_actions=1
	[ ${#action_launchctl[@]} -gt 0 ] && has_actions=1

	if [ "$has_actions" -eq 0 ]; then
		echo ""
		echo "${C_GREEN}✓ Nothing to clean up.${C_RESET}"
		return 0
	fi

	echo ""
	echo "${C_BOLD}${C_YELLOW}╔══════════════════════════════════════════════════════════════╗${C_RESET}"
	echo "${C_BOLD}${C_YELLOW}║${C_RESET} ${C_BOLD}CLEANUP ACTIONS${C_RESET} ${C_DIM}(review before running)${C_RESET}"
	echo "${C_BOLD}${C_YELLOW}╚══════════════════════════════════════════════════════════════╝${C_RESET}"

	if [ ${#action_brew[@]} -gt 0 ]; then
		echo ""
		echo "${C_BOLD}${C_CYAN}[1] Homebrew uninstall${C_RESET} ${C_DIM}(handles /Applications + Caskroom)${C_RESET}"
		echo "${C_DIM}    Affects:${C_RESET}"
		for p in "${action_brew[@]}"; do echo "${C_DIM}      $p${C_RESET}"; done
		echo ""
		echo "    ${C_GREEN}brew uninstall --cask $keyword${C_RESET}"
		echo "    ${C_DIM}# or: brew uninstall $keyword (for formula)${C_RESET}"
	fi

	if [ ${#action_login[@]} -gt 0 ]; then
		echo ""
		echo "${C_BOLD}${C_CYAN}[2] Login items${C_RESET}"
		for item in "${action_login[@]}"; do
			echo "    ${C_GREEN}osascript -e 'tell application \"System Events\" to delete login item \"$item\"'${C_RESET}"
		done
		echo "    ${C_DIM}# or via System Settings → General → Login Items${C_RESET}"
	fi

	if [ ${#action_launchctl[@]} -gt 0 ]; then
		echo ""
		echo "${C_BOLD}${C_CYAN}[3] launchctl services${C_RESET}"
		for label in "${action_launchctl[@]}"; do
			echo "    ${C_GREEN}launchctl bootout gui/\$UID/$label 2>/dev/null || launchctl remove $label${C_RESET}"
		done
	fi

	if [ ${#action_rm_user[@]} -gt 0 ]; then
		echo ""
		echo "${C_BOLD}${C_CYAN}[4] User files${C_RESET} ${C_DIM}(safe rm -rf, no sudo)${C_RESET}"
		for p in "${action_rm_user[@]}"; do
			echo "    ${C_GREEN}rm -rf \"$p\"${C_RESET}"
		done
	fi

	if [ ${#action_rm_container[@]} -gt 0 ]; then
		echo ""
		echo "${C_BOLD}${C_CYAN}[5] Sandboxed containers${C_RESET} ${C_RED}(needs Full Disk Access)${C_RESET}"
		echo "${C_DIM}    Grant terminal FDA: System Settings → Privacy & Security → Full Disk Access${C_RESET}"
		echo "${C_DIM}    Or delete via Finder (Cmd+Shift+G to navigate)${C_RESET}"
		for p in "${action_rm_container[@]}"; do
			echo "    ${C_GREEN}rm -rf \"$p\"${C_RESET}"
		done
	fi

	if [ ${#action_rm_sudo[@]} -gt 0 ]; then
		echo ""
		echo "${C_BOLD}${C_CYAN}[6] System paths${C_RESET} ${C_RED}(requires sudo)${C_RESET}"
		for p in "${action_rm_sudo[@]}"; do
			echo "    ${C_GREEN}sudo rm -rf \"$p\"${C_RESET}"
		done
	fi

	echo ""
}
