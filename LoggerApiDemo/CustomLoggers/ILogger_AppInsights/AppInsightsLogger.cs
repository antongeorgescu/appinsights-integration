using LoggerApiDemo.ILoggerClasses.LogFiles;
using LoggerApiDemo.Utilities;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics.CodeAnalysis;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace LoggerApiDemo.ILoggerClasses.AppInsights
{
    public sealed class AppInsightsLogger : ILogger
    {
        private AppInsightsLoggerProvider _appInsightsLoggerProvider;

        public AppInsightsLogger([NotNull] AppInsightsLoggerProvider appInsightsLoggerProvider)
        {
            _appInsightsLoggerProvider = appInsightsLoggerProvider;
        }

        public IDisposable BeginScope<TState>(TState state)
        {
            return null;
        }

        public bool IsEnabled(LogLevel logLevel)
        {
            return logLevel != LogLevel.None;
        }

        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
        {
            if (!IsEnabled(logLevel))
            {
                return;
            }

            using (InitializeDependencyTracking(_appInsightsLoggerProvider.Configuration))
            {
                //var logRecord = string.Format("{0} [{1}] {2} {3}", "[" + DateTimeOffset.UtcNow.ToString("yyyy-MM-dd HH:mm:ss+00:00") + "]", logLevel.ToString(), formatter(state, exception), exception != null ? exception.StackTrace : "");
                
                var attribs = new Dictionary<string, string>(){
                    {"logHash",string.IsNullOrEmpty(eventId.Name) ? "" : eventId.Name},
                    {"logClass",state.ToString().Contains("*CLASS*") ? state.ToString().Split("*")[2] : "" },
                    {"logMessage",state.ToString().Contains("*MESSAGE*") ? state.ToString().Split("*")[4] : "" }
                };

                if (state.ToString().Contains("*MESSAGE*"))
                {
                    _appInsightsLoggerProvider.TelemetryClient.TrackTrace(
                        message: state.ToString().Split("*")[4],
                        severityLevel: LogToSeverityLevelMap(logLevel),
                        properties: attribs);
                }
                else
                {
                    _appInsightsLoggerProvider.TelemetryClient.TrackTrace(
                        message: state.ToString(),
                        severityLevel: LogToSeverityLevelMap(logLevel));
                }

                if (exception !=null)
                    _appInsightsLoggerProvider.TelemetryClient.TrackException(
                        exception,
                        properties: attribs);

                //Task.Delay(2000).Wait();

                // before exit, flush the remaining data
                _appInsightsLoggerProvider.TelemetryClient.Flush();

                //Task.Delay(5000).Wait();

            }
        }

        static DependencyTrackingTelemetryModule InitializeDependencyTracking(TelemetryConfiguration configuration)
        {
            var module = new DependencyTrackingTelemetryModule();

            // prevent Correlation Id to be sent to certain endpoints. You may add other domains as needed.
            module.ExcludeComponentCorrelationHttpHeadersOnDomains.Add("core.windows.net");
            module.ExcludeComponentCorrelationHttpHeadersOnDomains.Add("core.chinacloudapi.cn");
            module.ExcludeComponentCorrelationHttpHeadersOnDomains.Add("core.cloudapi.de");
            module.ExcludeComponentCorrelationHttpHeadersOnDomains.Add("core.usgovcloudapi.net");
            module.ExcludeComponentCorrelationHttpHeadersOnDomains.Add("localhost");
            module.ExcludeComponentCorrelationHttpHeadersOnDomains.Add("127.0.0.1");

            // enable known dependency tracking, note that in future versions, we will extend this list. 
            // please check default settings in https://github.com/microsoft/ApplicationInsights-dotnet-server/blob/develop/WEB/Src/DependencyCollector/DependencyCollector/ApplicationInsights.config.install.xdt

            module.IncludeDiagnosticSourceActivities.Add("Microsoft.Azure.ServiceBus");
            module.IncludeDiagnosticSourceActivities.Add("Microsoft.Azure.EventHubs");

            // initialize the module
            module.Initialize(configuration);

            return module;
        }

        static SeverityLevel LogToSeverityLevelMap(LogLevel logLevel)
        {
            SeverityLevel severityLevel;
            switch (logLevel)
            {
                case LogLevel.Warning:
                    severityLevel = SeverityLevel.Warning;
                    break;
                case LogLevel.Error:
                    severityLevel = SeverityLevel.Error;
                    break;
                case LogLevel.Information:
                    severityLevel = SeverityLevel.Information;
                    break;
                case LogLevel.Critical:
                    severityLevel = SeverityLevel.Critical;
                    break;
                case LogLevel.Trace:
                case LogLevel.Debug:
                    severityLevel = SeverityLevel.Verbose;
                    break;
                default:
                    severityLevel = SeverityLevel.Information;
                    break;
            }
            return severityLevel;
        }
    }
}
