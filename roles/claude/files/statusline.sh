#!/bin/bash
# Claude Code statusline: session name, model, context-window bar, session cost.
# Reads JSON from stdin (see https://code.claude.com/docs/en/statusline.md).

input=$(cat)

{
  IFS= read -r session
  IFS= read -r model
  IFS= read -r size
  IFS= read -r used_pct
  IFS= read -r input_tok
  IFS= read -r cache_read
  IFS= read -r cache_create
  IFS= read -r cost
} < <(jq -r '
  .session_name              // "",
  .model.display_name        // "Claude",
  .context_window.context_window_size                       // 200000,
  .context_window.used_percentage                           // 0,
  .context_window.current_usage.input_tokens                // 0,
  .context_window.current_usage.cache_read_input_tokens     // 0,
  .context_window.current_usage.cache_creation_input_tokens // 0,
  .cost.total_cost_usd       // 0
' <<<"$input")

used=$((input_tok + cache_read + cache_create))

bar_width=20
filled=$(awk -v p="$used_pct" -v w="$bar_width" 'BEGIN { f = int((p/100)*w); if (f>w) f=w; print f }')
empty=$((bar_width - filled))

bar=""
for ((i=0; i<filled; i++)); do bar+="▓"; done
for ((i=0; i<empty;  i++)); do bar+="░"; done

if   awk -v p="$used_pct" 'BEGIN { exit !(p >= 80) }'; then color=$'\033[31m'   # red
elif awk -v p="$used_pct" 'BEGIN { exit !(p >= 50) }'; then color=$'\033[33m'   # yellow
else                                                       color=$'\033[32m'   # green
fi
dim=$'\033[2m'
bold=$'\033[1m'
reset=$'\033[0m'
sep="${dim}│${reset}"

fmt_tok() { awk -v n="$1" 'BEGIN { if (n>=1000) printf "%dk", n/1000; else print n }'; }

out=""
[ -n "$session" ] && out+="${bold}${session}${reset} ${sep} "
out+="${model} ${sep} ${color}${bar}${reset} $(fmt_tok "$used")/$(fmt_tok "$size") ${dim}($(awk -v p="$used_pct" 'BEGIN { printf "%.1f%%", p }'))${reset}"
out+=" ${sep} ${dim}\$${reset}$(awk -v c="$cost" 'BEGIN { printf "%.2f", c }')"

printf "%s" "$out"
