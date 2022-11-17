using System.Collections.Generic;
using System;
using Microsoft.Extensions.Logging;

namespace LoggerApiDemo.ILoggerClasses.ColorConsole
{
    public sealed class ColorConsoleLoggerConfiguration
    {
        public int EventId { get; set; }

        public Dictionary<LogLevel, ConsoleColor> LogLevelToColorMap { get; set; } = new()
        {
            [LogLevel.Information] = ConsoleColor.Green
        };
    }
}
