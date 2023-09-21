rule = {
    matches = {
        {
            { "node.name", "equals", "alsa_output.usb-Yoyodyne_Consulting_ODAC-revB-01.analog-stereo" },
        },
    },
    apply_properties = {
        ["node.nick"] = "oda",
    },
}

table.insert(alsa_monitor.rules, rule)

