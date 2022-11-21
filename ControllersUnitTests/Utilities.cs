using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights.DataContracts;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace ControllersUnitTests
{
    internal class Utilities
    {
        internal class FileObject
        {
            internal string Name { get; set; }
            internal string Path { get; set; }
        }

        internal static DependencyTrackingTelemetryModule InitializeDependencyTracking(TelemetryConfiguration configuration)
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

        internal static SeverityLevel randomSeverityLevel()
        {
            // pick up randomly a severity level out of: Verbose,Information,Warning,Error,Critical
            var rnd = new Random();
            var selected = (SeverityLevel)rnd.Next(1, 5);
            return selected;
        }

        internal static string randomTraceMessage()
        {
            // pick up randomy a message out of messages.txt file
            var messages = File.ReadAllText("messages.txt").Split('.').ToList();

            var rnd = new Random();
            return messages[rnd.Next(0, messages.Count - 1)];
        }
    }
}
