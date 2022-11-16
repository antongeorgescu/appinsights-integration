using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using System;

namespace LoggerApiDemo.Classes
{
    public static class ILoggerFileLoggerExtensions
    {
        public static ILoggingBuilder AddFileLogger(this ILoggingBuilder builder, Action<ILoggerFileTarget> configure)
        {
            builder.Services.AddSingleton<ILoggerProvider, ILoggerFileLoggerProvider>();
            builder.Services.Configure(configure);
            return builder;
        }
    }
}
