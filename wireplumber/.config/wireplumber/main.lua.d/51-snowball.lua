rule = {
    matches = {
        {
            { "node.name", "equals", "alsa_input.usb-BLUE_MICROPHONE_Blue_Snowball_201306-00.mono-fallback" },
        },
    },
    apply_properties = {
        ["node.nick"] = "sno",
    },
}

table.insert(alsa_monitor.rules, rule)


