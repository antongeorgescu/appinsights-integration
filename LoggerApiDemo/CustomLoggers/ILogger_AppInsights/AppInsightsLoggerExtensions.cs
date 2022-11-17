using LoggerApiDemo.ILoggerClasses.LogFiles;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Logging.Configuration;
using System;

namespace LoggerApiDemo.ILoggerClasses.AppInsights
{
    public static class AppInsightsLoggerExtensions
    {
        public static ILoggingBuilder AddAppInsightsLogger(this ILoggingBuilder builder, Action<AppInsightsLoggerConfiguration> configure)
        {
            builder.Services.AddSingleton<ILoggerProvider, AppInsightsLoggerProvider>();
            builder.Services.Configure(configure);
            return builder;
        }
    }
}
