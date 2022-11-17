using System;
using System.Collections.Concurrent;
using System.IO;
using System.Runtime.Versioning;
using LoggerApiDemo.ILoggerClasses.LogFiles;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights.DataContracts;

namespace LoggerApiDemo.ILoggerClasses.AppInsights
{
    [UnsupportedOSPlatform("browser")]
    [ProviderAlias("AppInsightsLoggerProvider")]
    public sealed class AppInsightsLoggerProvider : ILoggerProvider
    {
        public readonly AppInsightsLoggerConfiguration Options;
        public readonly TelemetryConfiguration Configuration;
        public readonly TelemetryClient TelemetryClient;

        public AppInsightsLoggerProvider(IOptions<AppInsightsLoggerConfiguration> _options)
        {
            Options = _options.Value;

            Configuration = TelemetryConfiguration.CreateDefault();

            Configuration.ConnectionString = Options.ConnectionString;
            Configuration.TelemetryInitializers.Add(new HttpDependenciesParsingTelemetryInitializer());

            //TelemetryConfiguration configuration = TelemetryConfiguration.Active; // Reads ApplicationInsights.config file if present

            TelemetryClient = new TelemetryClient(Configuration);
        }

        public ILogger CreateLogger(string categoryName)
        {
            return new AppInsightsLogger(this);
        }

        public void Dispose()
        {
        }
    }
}
