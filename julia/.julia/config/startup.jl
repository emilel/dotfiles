using Infiltrator
using JuliaFormatter
using Logging
using OhMyREPL
using Revise

s = safehouse
enable_autocomplete_brackets(false)

function set_logger(
    logger::Base.CoreLogging.AbstractLogger,
)::Base.CoreLogging.AbstractLogger
    previous_logger = current_logger()
    global_logger(logger)

    return previous_logger
end

function set_console_logger(
    level::Base.CoreLogging.LogLevel,
)::Base.CoreLogging.AbstractLogger
    @info "Enabled $(string(level)) log level"
    return set_logger(ConsoleLogger(stdout, level))
end

function debug()
    return set_console_logger(Logging.Debug)::Base.CoreLogging.AbstractLogger
end

function info()
    return set_console_logger(Logging.Info)::Base.CoreLogging.AbstractLogger
end
