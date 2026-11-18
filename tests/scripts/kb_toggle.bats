#!/usr/bin/env bats
load ../helpers/load

setup() {
    use_stubs
    K="$REPO_ROOT/scripts/.scripts/kb_toggle.sh"
    export SWAY_LOG="$BATS_TEST_TMPDIR/log"
}

kinesis() { # the pointer twin shares the identifier, so it comes first
    printf '[{"identifier":"10730:258:Kinesis_Advantage2_Keyboard","type":"pointer"},{"identifier":"10730:258:Kinesis_Advantage2_Keyboard","type":"keyboard","xkb_active_layout_index":%s}]' "$1"
}

@test "status: hidden (empty) when the kinesis isn't plugged in" {
    export SWAY_JSON='[{"identifier":"1:1:AT_Translated_Set_2_keyboard","type":"keyboard","xkb_active_layout_index":0}]'
    run sh "$K" status
    assert_success
    assert_output ""
}

@test "status: US on the first layout" {
    export SWAY_JSON="$(kinesis 0)"
    run sh "$K" status
    assert_success
    assert_output '{"text":"US","class":"us"}'
}

@test "status: ÅÄÖ on the second layout" {
    export SWAY_JSON="$(kinesis 1)"
    run sh "$K" status
    assert_success
    assert_output '{"text":"ÅÄÖ","class":"se"}'
}

@test "toggle: switches only the kinesis to its next layout" {
    run sh "$K"
    assert_success
    run cat "$SWAY_LOG"
    assert_output "input 10730:258:Kinesis_Advantage2_Keyboard xkb_switch_layout next"
}

@test "sway gives the kinesis us,us_se, us first" {
    run grep -A1 '^input "10730:258:Kinesis_Advantage2_Keyboard"' "$REPO_ROOT/sway/.config/sway/config"
    assert_line '    xkb_layout "us,us_se"'
}

@test "sway binds \$mod+s to the toggle, and nothing else to it" {
    run grep 'bindsym \$mod+s ' "$REPO_ROOT/sway/.config/sway/config"
    assert_output 'bindsym $mod+s exec "$HOME/.scripts/kb_toggle.sh && pkill -RTMIN+8 waybar"'
}

@test "us_se puts åäö on the swedish keys and keeps us there on AltGr" {
    f="$REPO_ROOT/sway/.config/xkb/symbols/us_se"
    run grep -E '^ +key <(AD11|AC10|AC11)>' "$f"
    assert_line '    key <AD11> {[ aring,      Aring,      bracketleft, braceleft ]};'
    assert_line '    key <AC10> {[ odiaeresis, Odiaeresis, semicolon,   colon     ]};'
    assert_line '    key <AC11> {[ adiaeresis, Adiaeresis, apostrophe,  quotedbl  ]};'
    run grep -c 'include "us(basic)"\|include "level3(ralt_switch)"' "$f"
    assert_output 2
}
