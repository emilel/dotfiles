#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    S="$REPO_ROOT/scripts/.scripts/net_status.sh"
    RED='<span color="#d75f5f">'
    export NET_PROC="$BATS_TEST_TMPDIR"
    : >"$NET_PROC/route"
    : >"$NET_PROC/wireless"
    export WIFI_SSIDS='yes:Pinocchio:89'
}

# One header line + one route per interface, as the kernel writes them.
mk_route() {
    printf 'Iface\tDestination\tGateway\tFlags\tRefCnt\tUse\tMetric\tMask\n' >"$NET_PROC/route"
    while [ "$#" -gt 0 ]; do
        printf '%s\t00000000\t0101A8C0\t0003\t0\t0\t%s\t00000000\n' "${1%%:*}" "${1##*:}" >>"$NET_PROC/route"
        shift
    done
}

mk_wireless() {
    printf 'Inter-| sta-|   Quality\n face | tus | link level noise\n' >"$NET_PROC/wireless"
    printf ' %s: 0000   64.  %s.  -256\n' "$1" "$2" >>"$NET_PROC/wireless"
}

@test "ethernet only: ETH" {
    mk_route enp0s1:100
    run sh "$S"
    assert_success
    assert_output "ETH"
}

@test "wifi only: essid and signal" {
    mk_route wlp2s0:600
    mk_wireless wlp2s0 -46
    run sh "$S"
    assert_success
    assert_output "Pinocchio (-46 dBm)"
}

@test "both up: the lower-metric route wins, not the first line" {
    mk_route wlp2s0:600 enp0s1:100
    mk_wireless wlp2s0 -46
    run sh "$S"
    assert_success
    assert_output "ETH"
}

@test "both up the other way round: wifi wins when its metric is lower" {
    mk_route enp0s1:700 wlp2s0:600
    mk_wireless wlp2s0 -46
    run sh "$S"
    assert_success
    assert_output "Pinocchio (-46 dBm)"
}

@test "no default route: OFFL" {
    mk_route
    run sh "$S"
    assert_success
    assert_output "OFFL"
}

@test "connected but no internet: red" {
    mk_route enp0s1:100
    export NM_CONNECTIVITY=limited
    run sh "$S"
    assert_success
    assert_output "${RED}ETH</span>"
}

@test "captive portal counts as no internet" {
    mk_route wlp2s0:600
    mk_wireless wlp2s0 -70
    export NM_CONNECTIVITY=portal
    run sh "$S"
    assert_success
    assert_output "${RED}Pinocchio (-70 dBm)</span>"
}

@test "offline is red too" {
    mk_route
    export NM_CONNECTIVITY=none
    run sh "$S"
    assert_success
    assert_output "${RED}OFFL</span>"
}

@test "falls back to the interface name when the essid is unknown" {
    mk_route wlp2s0:600
    mk_wireless wlp2s0 -46
    export WIFI_SSIDS=''
    run sh "$S"
    assert_success
    assert_output "wlp2s0 (-46 dBm)"
}

@test "escapes pango markup in the essid" {
    mk_route wlp2s0:600
    mk_wireless wlp2s0 -46
    export WIFI_SSIDS='yes:me & <you>:89'
    run sh "$S"
    assert_success
    assert_output "me &amp; &lt;you> (-46 dBm)"
}
