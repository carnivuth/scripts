program="$1"
out="$(mktemp)"
shift
echo "$out"
"$program" "$@" >> "$out" 2>&1 & disown $!
