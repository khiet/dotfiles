gdel() {
  git checkout main && git pull

  # Delete branches that are truly merged
  git branch --merged | grep -v -E '(^\*|main|master)' | xargs -r git branch -d

  # Delete branches whose remote tracking branch is gone (squash-merged via GitHub)
  git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D
}

glg() {
  local query="$1"
  local context="${2:-10}"

  if [ -z "$query" ]; then
    echo "Usage: glg <commit-hash | keyword> [context]"
    return 1
  fi

  # Detect if input looks like a commit hash (hex string, length >= 7)
  if [[ "$query" =~ ^[0-9a-f]{7,40}$ ]]; then
    if command -v gh >/dev/null 2>&1; then
      local commit_sha prs
      commit_sha=$(git rev-parse "$query^{commit}" 2>/dev/null)

      if [ -n "$commit_sha" ]; then
        prs=$(gh api \
          -H "Accept: application/vnd.github+json" \
          "repos/{owner}/{repo}/commits/$commit_sha/pulls" \
          --template '{{range .}}{{printf "#%v %s\n%s\n" .number .title .html_url}}{{end}}' \
          2>/dev/null)

        if [ -n "$prs" ]; then
          if command -v cowsay >/dev/null 2>&1; then
            printf "Associated GitHub PR:\n%s" "$prs" | cowsay
          else
            echo "Associated GitHub PR:"
            echo "$prs"
          fi
          echo
        fi
      fi
    fi

    git log --graph --oneline --decorate --all --color=always \
      | grep -i -C "$context" --color=always "$query"
  else
    git log --graph --oneline --decorate --all --color=always \
      --grep="$query" -i
  fi
}

glp() {
  local query="$1"

  if [ -z "$query" ]; then
    echo "Usage: glp <file-path | filename keyword>"
    return 1
  fi

  local matches file
  matches=$(git log --all --name-only --pretty=format: | grep -iF -- "$query" | sort -u)

  if [ -z "$matches" ]; then
    echo "No files found in git history matching: $query"
    return 1
  fi

  if [ "$(echo "$matches" | wc -l | tr -d ' ')" -eq 1 ]; then
    file="$matches"
  elif command -v fzf >/dev/null 2>&1; then
    file=$(echo "$matches" | fzf --prompt="git lp file> ")
  else
    echo "Multiple files matched:"
    echo "$matches"
    echo "Refine the query or install fzf to choose interactively."
    return 1
  fi

  if [ -z "$file" ]; then
    return 1
  fi

  git lp -- "$file"
}

function gbr { git co -b $(kebab "$1") }
function gs { git show "$1" | d }
function gss { git show "$1" | ds }
