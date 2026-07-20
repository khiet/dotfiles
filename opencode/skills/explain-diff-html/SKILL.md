---
name: explain-diff-html
description: Use when the user asks for a rich explanation of a code change, diff, branch, or PR. Produces HTML output.
---

# Explain Diff

Please make me a rich, interactive explanation of the specified code change.

It should have these sections:

- Background: Explain the existing system relevant to this change. (You should broadly explore surrounding code for this.) We don't know how much the reader already knows, so include a deep background for beginners (note that it can be skipped if the reader is already familiar), and then a more narrow background directly relevant to the change.
- Intuition: Explain the core intuition for the code change. The focus here is to explain the essence, not the full details. Use concrete examples with toy data. Use figures and diagrams liberally.
- Code: Do a high-level walkthrough of the changes to the code. Group/order the changes in an understandable way.
- Quiz: Come up with five questions that test the reader's knowledge of this PR. This should be medium difficulty, difficult enough that you actually need to understand the substance of the PR to answer them, but not gotchas. The goal is to help the reader make sure that they've actually understood. These should be presented as interactive multiple-choice questions, and when the user clicks, it tells them whether they were correct and gives feedback.

Theme:

- Style the page with the Dracula Classic (dark) palette. Copy this `:root` block into the page's `<style>` and use the variables throughout. Do not hardcode ad hoc colors elsewhere, and to retheme edit only this block.

  ```css
  :root {
    --background: #282A36;
    --current-line: #44475A;
    --selection: #44475A;
    --foreground: #F8F8F2;
    --comment: #6272A4;
    --red: #FF5555;
    --orange: #FFB86C;
    --yellow: #F1FA8C;
    --green: #50FA7B;
    --cyan: #8BE9FD;
    --purple: #BD93F9;
    --pink: #FF79C6;
  }
  ```
- Use Background for the page, Foreground for body text, and Comment for muted/secondary text. Reserve Current Line/Selection for surfaces like cards, callouts, code-block backgrounds, and borders. Draw on the accent hues (Cyan, Green, Purple, Pink, Orange, Yellow) for headings, links, diagram elements, and syntax highlighting, using Red for warnings or errors. Keep contrast readable against the dark background.

Format:

- Output a single self-contained HTML file which includes CSS and JavaScript. Start it with `<!DOCTYPE html>` and a proper `<html><head>` that includes `<meta charset="utf-8">` as the first element in the `<head>`. This is required: the file uses non-ASCII characters (emoji, arrows, box-drawing) and, without the charset declaration, a browser opening the local `file://` page falls back to a legacy encoding and renders them as mojibake (e.g. `→` becomes `â†’`, `🔤` becomes `ðŸ”¤`). Make the whole thing one long page with section headers and a table of contents. Don't use tabs for the top-level structure. Basic responsive styling so you can view it on a phone is nice too. Save the file in `$HOME/Desktop` (outside the code repo) named `<unix_timestamp>_<branch_name>.html`, where `branch_name` is the current git branch with any `/` replaced by `-` and `unix_timestamp` is the current Unix epoch seconds. For example: `$HOME/Desktop/main_1720915200.html`.
- Please write with the clarity and flow of Martin Kleppmann, making it engaging and written in classic style. Transitions between sections should be smooth.
- Some tips on diagrams. Ideally, you should pick a small number of diagram families that can be reused throughout the explanation to explain various cases. Some useful kinds of diagrams:
  - A very simplified version of the UI that the user sees in the app, to explain UI changes.
  - A system diagram showing data flow or communication between components. Make sure to include example data here!
- Don't use ASCII diagrams. Always use simple HTML designs for your diagrams, HTML lists for lists of things, etc.
  - For code blocks, use `<pre>`: it preserves newlines and indentation, which a plain `<div>` collapses. If you style a `<div>` instead, it **must** set `white-space: pre-wrap`. Check each code block before saving.
- Use callouts for key concepts or definitions, important edge cases, etc.

Annotations (Kindle-style highlighting and notes):

- The page must let the reader select any text to highlight it (in one of four colors), attach a note to a highlight, and review every highlight/note in a slide-out drawer whose entries jump to the exact spot when clicked. Annotations persist across reloads via `localStorage`.
- Do not reimplement this. Paste the module below **verbatim**: the `<style>` block just before `</style>` (right after the accent-color rules), and the `<script>` block as the last element before `</body>`. It is self-contained, depends on the Dracula `:root` variables already in the page, and needs no other markup.
- Set two things on `<body>` so storage is stable and predictable:
  - `data-annot-doc-id="<branch_name>_<unix_timestamp>"` (the same id used in the filename) so highlights key to this document and survive a rename or move.
- Anchoring is by character offset into the page's text, which is only stable if the annotatable text does not change at runtime. Mark **any element whose text mutates after load** with `data-no-annotate` so the module excludes it from offset math in both directions. In particular, put `data-no-annotate` on the **Quiz** section wrapper (its answer feedback appears on click) and on any collapsible/toggle whose contents are injected dynamically. The module already excludes its own UI, `<script>`, and `<style>`; `data-no-annotate` is for your dynamic content. Static prose (Background, Intuition, Code) needs nothing.

  ```css
  /* Annotation layer styles. Colors reference the Dracula :root vars so the whole
     layer re-themes when that block changes. color-mix keeps highlights
     translucent so overlapping marks blend and body text stays readable. */
  .annot-hl {
    border-radius: 2px;
    padding: 0 0.03em;
    cursor: pointer;
    color: inherit;
    background: color-mix(in srgb, var(--yellow) 30%, transparent);
  }
  .annot-hl[data-color="yellow"] { background: color-mix(in srgb, var(--yellow) 30%, transparent); }
  .annot-hl[data-color="green"]  { background: color-mix(in srgb, var(--green) 30%, transparent); }
  .annot-hl[data-color="pink"]   { background: color-mix(in srgb, var(--pink) 32%, transparent); }
  .annot-hl[data-color="orange"] { background: color-mix(in srgb, var(--orange) 32%, transparent); }
  .annot-hl.has-note {
    text-decoration: underline dotted;
    text-decoration-color: var(--comment);
    text-underline-offset: 3px;
  }
  .annot-hl.annot-flash {
    animation: annot-flash 1.2s ease-out;
  }
  @keyframes annot-flash {
    0%, 40% { box-shadow: 0 0 0 3px color-mix(in srgb, var(--cyan) 70%, transparent); }
    100% { box-shadow: 0 0 0 0 transparent; }
  }

  /* Floating action popover (color swatches + Note/Delete). */
  .annot-popover {
    position: fixed;
    z-index: 10000;
    display: none;
    gap: 6px;
    align-items: center;
    padding: 6px 8px;
    background: var(--current-line);
    border: 1px solid var(--selection);
    border-radius: 10px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.45);
  }
  .annot-swatch {
    width: 20px;
    height: 20px;
    border-radius: 50%;
    border: 2px solid var(--foreground);
    cursor: pointer;
    padding: 0;
  }
  .annot-swatch[data-color="yellow"] { background: var(--yellow); }
  .annot-swatch[data-color="green"]  { background: var(--green); }
  .annot-swatch[data-color="pink"]   { background: var(--pink); }
  .annot-swatch[data-color="orange"] { background: var(--orange); }
  .annot-action {
    background: transparent;
    color: var(--foreground);
    border: 1px solid var(--selection);
    border-radius: 8px;
    padding: 4px 10px;
    font: inherit;
    font-size: 0.85rem;
    cursor: pointer;
  }
  .annot-action:hover { background: var(--selection); }
  .annot-action.primary {
    background: var(--purple);
    color: var(--background);
    border-color: var(--purple);
  }
  .annot-action.danger { color: var(--red); border-color: var(--red); }

  /* Note editor modal. */
  .annot-editor-backdrop {
    position: fixed;
    inset: 0;
    z-index: 10001;
    display: none;
    align-items: center;
    justify-content: center;
    background: rgba(0, 0, 0, 0.5);
  }
  .annot-editor {
    width: min(480px, 92vw);
    background: var(--current-line);
    border: 1px solid var(--selection);
    border-radius: 14px;
    padding: 16px;
    box-shadow: 0 12px 40px rgba(0, 0, 0, 0.5);
  }
  .annot-editor-quote {
    color: var(--comment);
    font-style: italic;
    border-left: 3px solid var(--purple);
    padding-left: 10px;
    margin-bottom: 12px;
    max-height: 5.5em;
    overflow: auto;
  }
  .annot-editor-text {
    width: 100%;
    min-height: 120px;
    resize: vertical;
    background: var(--background);
    color: var(--foreground);
    border: 1px solid var(--selection);
    border-radius: 10px;
    padding: 10px;
    font: inherit;
    box-sizing: border-box;
  }
  .annot-editor-actions {
    display: flex;
    gap: 8px;
    justify-content: flex-end;
    margin-top: 12px;
  }

  /* Drawer + toggle. */
  .annot-toggle {
    position: fixed;
    right: 18px;
    bottom: 18px;
    z-index: 9998;
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 10px 14px;
    background: var(--purple);
    color: var(--background);
    border: none;
    border-radius: 999px;
    cursor: pointer;
    font: inherit;
    font-weight: 600;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.4);
  }
  .annot-toggle-icon { font-size: 1.1rem; }
  .annot-count {
    background: var(--background);
    color: var(--foreground);
    border-radius: 999px;
    padding: 0 8px;
    font-size: 0.8rem;
    min-width: 1.4em;
    text-align: center;
  }
  .annot-drawer {
    position: fixed;
    top: 0;
    right: 0;
    z-index: 9999;
    width: min(380px, 90vw);
    height: 100vh;
    background: var(--background);
    border-left: 1px solid var(--selection);
    box-shadow: -8px 0 30px rgba(0, 0, 0, 0.4);
    transform: translateX(100%);
    transition: transform 0.25s ease;
    display: flex;
    flex-direction: column;
  }
  .annot-drawer.open { transform: translateX(0); }
  .annot-drawer-head {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 14px 16px;
    border-bottom: 1px solid var(--selection);
    color: var(--foreground);
  }
  .annot-drawer-head > div { display: flex; gap: 6px; }
  .annot-drawer-list {
    overflow-y: auto;
    padding: 10px;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }
  .annot-empty { color: var(--comment); padding: 20px 8px; text-align: center; }
  .annot-item {
    border: 1px solid var(--selection);
    border-left: 4px solid var(--comment);
    border-radius: 10px;
    padding: 10px 12px;
    cursor: pointer;
    background: var(--current-line);
  }
  .annot-item:hover { border-color: var(--cyan); }
  .annot-item[data-color="yellow"] { border-left-color: var(--yellow); }
  .annot-item[data-color="green"]  { border-left-color: var(--green); }
  .annot-item[data-color="pink"]   { border-left-color: var(--pink); }
  .annot-item[data-color="orange"] { border-left-color: var(--orange); }
  .annot-item-quote {
    color: var(--foreground);
    display: -webkit-box;
    -webkit-line-clamp: 3;
    -webkit-box-orient: vertical;
    overflow: hidden;
  }
  .annot-item-note {
    color: var(--cyan);
    font-style: italic;
    margin-top: 6px;
    font-size: 0.9rem;
  }
  .annot-item-actions {
    display: flex;
    gap: 6px;
    margin-top: 8px;
  }
  .annot-item-actions .annot-action { font-size: 0.78rem; padding: 3px 8px; }

  @media (max-width: 520px) {
    .annot-toggle { right: 12px; bottom: 12px; }
  }
  ```

  ```html
  <script>
  /* ============================================================================
     Annotation layer: Kindle-style text highlighting + notes for a static page.
     Self-contained, no dependencies. Persists to localStorage keyed per document.

     Anchoring model: each annotation is stored as a character range [start, end)
     into the plain text of a content root, plus the quoted text for reference.
     Because the generated document is static, these offsets are stable across
     reloads. UI chrome (this module's own elements, <script>/<style>, and any
     [data-no-annotate] subtree) is excluded from the text walk in BOTH directions
     -- when measuring a new selection and when restoring saved marks -- so the
     coordinate system never shifts even as the drawer fills with entries.
     ============================================================================ */
  (function () {
    "use strict";

    // Content root that annotations are measured against and confined to.
    // Defaults to <body>; set [data-annotate-root] to scope more tightly.
    var root = document.querySelector("[data-annotate-root]") || document.body;

    // Stable per-document storage key. Prefer an explicit id so the file can be
    // renamed/moved without losing annotations; fall back to the path.
    var DOC_ID =
      (document.body && document.body.dataset.annotDocId) ||
      document.title ||
      location.pathname;
    var STORAGE_KEY = "annot:" + DOC_ID;

    var COLORS = ["yellow", "green", "pink", "orange"];

    // --- persistence ----------------------------------------------------------
    var annotations = load();

    function load() {
      try {
        var raw = localStorage.getItem(STORAGE_KEY);
        return raw ? JSON.parse(raw) : [];
      } catch (e) {
        return [];
      }
    }
    function save() {
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(annotations));
      } catch (e) {
        /* storage may be unavailable on some file:// setups; degrade to memory */
      }
    }

    // --- text-offset core ------------------------------------------------------
    // Elements whose text must NOT count toward offsets (kept identical in every
    // direction so save-time and restore-time coordinates agree).
    function shouldSkip(el) {
      var tag = el.nodeName;
      if (tag === "SCRIPT" || tag === "STYLE" || tag === "TEMPLATE" || tag === "NOSCRIPT")
        return true;
      if (el.classList && el.classList.contains("annot-ui")) return true;
      if (el.hasAttribute && el.hasAttribute("data-no-annotate")) return true;
      return false;
    }

    // TreeWalker over text nodes only, rejecting excluded subtrees.
    function textWalker() {
      return document.createTreeWalker(root, NodeFilter.SHOW_ALL, {
        acceptNode: function (node) {
          if (node.nodeType === 1)
            return shouldSkip(node) ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_SKIP;
          return NodeFilter.FILTER_ACCEPT; // text node
        },
      });
    }

    // Count skip-aware text length inside a cloned fragment (used for endpoints).
    function countText(node) {
      if (node.nodeType === 3) return node.nodeValue.length;
      if (node.nodeType === 1 && shouldSkip(node)) return 0;
      var n = 0;
      for (var c = node.firstChild; c; c = c.nextSibling) n += countText(c);
      return n;
    }

    // Character offset from root start to a DOM point (container, offset).
    function offsetOf(container, offset) {
      var range = document.createRange();
      range.setStart(root, 0);
      range.setEnd(container, offset);
      var frag = range.cloneContents();
      return countText(frag);
    }

    // Resolve a stored [start,end) range to a list of {node, s, e} segments,
    // each wholly within a single text node.
    function segmentsFor(start, end) {
      var segs = [];
      var walker = textWalker();
      var pos = 0;
      var node;
      while ((node = walker.nextNode())) {
        var len = node.nodeValue.length;
        var nodeStart = pos;
        var nodeEnd = pos + len;
        pos = nodeEnd;
        if (nodeEnd <= start) continue;
        if (nodeStart >= end) break;
        var s = Math.max(0, start - nodeStart);
        var e = Math.min(len, end - nodeStart);
        if (e > s) segs.push({ node: node, s: s, e: e });
      }
      return segs;
    }

    // --- rendering marks -------------------------------------------------------
    function paint(ann) {
      var segs = segmentsFor(ann.start, ann.end);
      for (var i = 0; i < segs.length; i++) {
        var seg = segs[i];
        var r = document.createRange();
        r.setStart(seg.node, seg.s);
        r.setEnd(seg.node, seg.e);
        var span = document.createElement("span");
        span.className = "annot-hl" + (ann.note ? " has-note" : "");
        span.dataset.color = ann.color;
        span.dataset.annotId = ann.id;
        try {
          r.surroundContents(span);
        } catch (e) {
          /* skip a segment that can't be cleanly wrapped */
        }
      }
    }

    function unpaint(id) {
      var spans = root.querySelectorAll('.annot-hl[data-annot-id="' + id + '"]');
      spans.forEach(function (span) {
        var parent = span.parentNode;
        while (span.firstChild) parent.insertBefore(span.firstChild, span);
        parent.removeChild(span);
      });
      root.normalize(); // merge the text nodes we just split apart
    }

    function repaint(ann) {
      unpaint(ann.id);
      paint(ann);
    }

    function paintAll() {
      // Order matters only for nesting aesthetics; document order is fine.
      annotations
        .slice()
        .sort(function (a, b) {
          return a.start - b.start;
        })
        .forEach(paint);
    }

    // --- annotation lifecycle --------------------------------------------------
    function newId() {
      return "a_" + Date.now().toString(36) + "_" + Math.floor(Math.random() * 1e6).toString(36);
    }

    function addFromSelection(color, withNote) {
      var sel = window.getSelection();
      if (!sel || sel.isCollapsed || sel.rangeCount === 0) return;
      var range = sel.getRangeAt(0);
      if (!isInsideRoot(range)) return;
      var start = offsetOf(range.startContainer, range.startOffset);
      var end = offsetOf(range.endContainer, range.endOffset);
      if (end <= start) return;
      var quote = sel.toString();
      var ann = {
        id: newId(),
        start: start,
        end: end,
        quote: quote,
        color: color || "yellow",
        note: "",
        created: Date.now(),
      };
      annotations.push(ann);
      save();
      paint(ann);
      sel.removeAllRanges();
      hidePopover();
      renderDrawer();
      if (withNote) openNoteEditor(ann);
    }

    function recolor(ann, color) {
      ann.color = color;
      save();
      repaint(ann);
      renderDrawer();
    }

    function setNote(ann, text) {
      ann.note = text || "";
      save();
      repaint(ann);
      renderDrawer();
    }

    function remove(ann) {
      unpaint(ann.id);
      annotations = annotations.filter(function (a) {
        return a.id !== ann.id;
      });
      save();
      renderDrawer();
    }

    function byId(id) {
      return annotations.filter(function (a) {
        return a.id === id;
      })[0];
    }

    function isInsideRoot(range) {
      var c = range.commonAncestorContainer;
      var el = c.nodeType === 1 ? c : c.parentNode;
      if (!root.contains(el)) return false;
      if (el.closest && el.closest(".annot-ui")) return false;
      return true;
    }

    // --- floating popover (selection actions + existing-mark actions) ----------
    var popover = null;
    function ensurePopover() {
      if (popover) return popover;
      popover = document.createElement("div");
      popover.className = "annot-ui annot-popover";
      document.body.appendChild(popover);
      return popover;
    }
    function hidePopover() {
      if (popover) popover.style.display = "none";
    }
    function positionAt(rect) {
      var p = popover;
      p.style.display = "flex";
      var pr = p.getBoundingClientRect();
      var top = rect.top - pr.height - 8;
      if (top < 8) top = rect.bottom + 8;
      var left = rect.left + rect.width / 2 - pr.width / 2;
      left = Math.max(8, Math.min(left, window.innerWidth - pr.width - 8));
      p.style.top = top + "px";
      p.style.left = left + "px";
    }

    function swatchButtons(onPick) {
      var frag = document.createDocumentFragment();
      COLORS.forEach(function (c) {
        var b = document.createElement("button");
        b.className = "annot-swatch";
        b.dataset.color = c;
        b.title = c;
        b.onmousedown = function (e) {
          e.preventDefault();
        };
        b.onclick = function () {
          onPick(c);
        };
        frag.appendChild(b);
      });
      return frag;
    }

    function showSelectionPopover(rect) {
      var p = ensurePopover();
      p.innerHTML = "";
      p.appendChild(swatchButtons(function (c) {
        addFromSelection(c, false);
      }));
      var note = actionButton("Note", function () {
        addFromSelection("yellow", true);
      });
      p.appendChild(note);
      positionAt(rect);
    }

    function showMarkPopover(ann, rect) {
      var p = ensurePopover();
      p.innerHTML = "";
      p.appendChild(swatchButtons(function (c) {
        recolor(ann, c);
        hidePopover();
      }));
      p.appendChild(
        actionButton(ann.note ? "Edit note" : "Note", function () {
          hidePopover();
          openNoteEditor(ann);
        })
      );
      p.appendChild(
        actionButton("Delete", function () {
          remove(ann);
          hidePopover();
        }, "danger")
      );
      positionAt(rect);
    }

    function actionButton(label, onClick, variant) {
      var b = document.createElement("button");
      b.className = "annot-action" + (variant ? " " + variant : "");
      b.textContent = label;
      b.onmousedown = function (e) {
        e.preventDefault();
      };
      b.onclick = onClick;
      return b;
    }

    // --- note editor -----------------------------------------------------------
    var editor = null;
    function openNoteEditor(ann) {
      if (!editor) {
        editor = document.createElement("div");
        editor.className = "annot-ui annot-editor-backdrop";
        editor.innerHTML =
          '<div class="annot-editor">' +
          '<div class="annot-editor-quote"></div>' +
          '<textarea class="annot-editor-text" placeholder="Add a note..."></textarea>' +
          '<div class="annot-editor-actions">' +
          '<button class="annot-action" data-act="cancel">Cancel</button>' +
          '<button class="annot-action primary" data-act="save">Save</button>' +
          "</div></div>";
        document.body.appendChild(editor);
        editor.addEventListener("mousedown", function (e) {
          if (e.target === editor) closeNoteEditor();
        });
      }
      editor.querySelector(".annot-editor-quote").textContent = ann.quote;
      var ta = editor.querySelector(".annot-editor-text");
      ta.value = ann.note || "";
      editor.querySelector('[data-act="save"]').onclick = function () {
        setNote(ann, ta.value.trim());
        closeNoteEditor();
      };
      editor.querySelector('[data-act="cancel"]').onclick = closeNoteEditor;
      editor.style.display = "flex";
      ta.focus();
    }
    function closeNoteEditor() {
      if (editor) editor.style.display = "none";
    }

    // --- drawer ----------------------------------------------------------------
    var drawer, drawerList, toggleBtn;
    function buildDrawer() {
      toggleBtn = document.createElement("button");
      toggleBtn.className = "annot-ui annot-toggle";
      toggleBtn.innerHTML = '<span class="annot-toggle-icon">&#9998;</span><span class="annot-count">0</span>';
      toggleBtn.onclick = function () {
        drawer.classList.toggle("open");
      };
      document.body.appendChild(toggleBtn);

      drawer = document.createElement("aside");
      drawer.className = "annot-ui annot-drawer";
      drawer.innerHTML =
        '<div class="annot-drawer-head">' +
        "<strong>Annotations</strong>" +
        '<div><button class="annot-action" data-act="clear">Clear all</button>' +
        '<button class="annot-action" data-act="close">&#10005;</button></div>' +
        "</div>" +
        '<div class="annot-drawer-list"></div>';
      document.body.appendChild(drawer);
      drawerList = drawer.querySelector(".annot-drawer-list");
      drawer.querySelector('[data-act="close"]').onclick = function () {
        drawer.classList.remove("open");
      };
      drawer.querySelector('[data-act="clear"]').onclick = function () {
        if (!annotations.length) return;
        if (!window.confirm("Delete all annotations for this document?")) return;
        annotations.slice().forEach(remove);
      };
    }

    function renderDrawer() {
      toggleBtn.querySelector(".annot-count").textContent = String(annotations.length);
      drawerList.innerHTML = "";
      if (!annotations.length) {
        var empty = document.createElement("div");
        empty.className = "annot-empty";
        empty.textContent = "Select any text to highlight it or add a note.";
        drawerList.appendChild(empty);
        return;
      }
      annotations
        .slice()
        .sort(function (a, b) {
          return a.start - b.start;
        })
        .forEach(function (ann) {
          var item = document.createElement("div");
          item.className = "annot-item";
          item.dataset.color = ann.color;
          var quote = document.createElement("div");
          quote.className = "annot-item-quote";
          quote.textContent = ann.quote;
          item.appendChild(quote);
          if (ann.note) {
            var note = document.createElement("div");
            note.className = "annot-item-note";
            note.textContent = ann.note;
            item.appendChild(note);
          }
          var actions = document.createElement("div");
          actions.className = "annot-item-actions";
          actions.appendChild(
            actionButton(ann.note ? "Edit note" : "Add note", function (e) {
              e.stopPropagation();
              openNoteEditor(ann);
            })
          );
          actions.appendChild(
            actionButton("Delete", function (e) {
              e.stopPropagation();
              remove(ann);
            }, "danger")
          );
          item.appendChild(actions);
          item.onclick = function () {
            jumpTo(ann.id);
          };
          drawerList.appendChild(item);
        });
    }

    function jumpTo(id) {
      var mark = root.querySelector('.annot-hl[data-annot-id="' + id + '"]');
      if (!mark) return;
      mark.scrollIntoView({ behavior: "smooth", block: "center" });
      mark.classList.add("annot-flash");
      setTimeout(function () {
        mark.classList.remove("annot-flash");
      }, 1200);
    }

    // --- event wiring ----------------------------------------------------------
    function onSelectionRelease() {
      var sel = window.getSelection();
      if (!sel || sel.isCollapsed || sel.rangeCount === 0) return;
      var range = sel.getRangeAt(0);
      if (!isInsideRoot(range) || sel.toString().trim() === "") return;
      showSelectionPopover(range.getBoundingClientRect());
    }

    function wire() {
      document.addEventListener("mouseup", function (e) {
        if (e.target.closest && e.target.closest(".annot-ui")) return;
        // let the click-on-existing-mark handler win first
        if (e.target.closest && e.target.closest(".annot-hl")) return;
        setTimeout(onSelectionRelease, 0);
      });
      document.addEventListener("touchend", function (e) {
        if (e.target.closest && e.target.closest(".annot-ui")) return;
        setTimeout(onSelectionRelease, 0);
      });
      // Click an existing highlight -> its action menu (only when not selecting).
      root.addEventListener("click", function (e) {
        var mark = e.target.closest && e.target.closest(".annot-hl");
        if (!mark) return;
        var sel = window.getSelection();
        if (sel && !sel.isCollapsed) return;
        var ann = byId(mark.dataset.annotId);
        if (ann) showMarkPopover(ann, mark.getBoundingClientRect());
      });
      // Dismiss the popover on outside interaction.
      document.addEventListener("mousedown", function (e) {
        if (!popover || popover.style.display === "none") return;
        if (e.target.closest && (e.target.closest(".annot-popover") || e.target.closest(".annot-hl")))
          return;
        hidePopover();
      });
      document.addEventListener("scroll", hidePopover, true);
      document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
          hidePopover();
          closeNoteEditor();
        }
      });
    }

    // --- boot ------------------------------------------------------------------
    function boot() {
      buildDrawer();
      paintAll();
      renderDrawer();
      wire();
    }
    if (document.readyState === "loading")
      document.addEventListener("DOMContentLoaded", boot);
    else boot();
  })();
  </script>
  ```
