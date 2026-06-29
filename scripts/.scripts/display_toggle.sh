#!/bin/sh
# Toggle the external between "smooth" (best >=min_hz mode -- no cursor lag) and
# "crisp" (native max-res, sharper but lower refresh; a 4K panel only does 30Hz
# over HDMI). Persists the choice for sway_arrange.sh and re-runs it so the
# mode/scale/layout follow. Waybar's custom/display shows + clicks this -- but
# `status` prints nothing (so waybar hides the module) unless an external is
# connected whose native resolution actually forces the 4K-vs-60Hz tradeoff.
set -eu

min_hz=50000 # below this a mode counts as low-refresh (the tradeoff threshold)
pref_file=${XDG_RUNTIME_DIR:-/tmp}/sway_ext_mode
cur=$(cat "$pref_file" 2>/dev/null) || cur=smooth

# True iff some active external's largest mode can't also run at >=min_hz.
tradeoff() {
    swaymsg -t get_outputs | jq -e --argjson hz "$min_hz" '
        any(.[] | select(.active and (.name|test("^eDP")|not));
            (.modes | max_by(.width*.height) | (.refresh // 60000)) < $hz)' >/dev/null
}

case "${1:-toggle}" in
    status)
        tradeoff || exit 0 # no tradeoff -> empty output -> module hidden
        [ "$cur" = crisp ] && echo 4K || echo 60Hz
        exit 0
        ;;
    crisp | smooth) new=$1 ;;
    *) [ "$cur" = crisp ] && new=smooth || new=crisp ;;
esac

printf '%s' "$new" >"$pref_file"
exec "$HOME/.scripts/sway_arrange.sh"
