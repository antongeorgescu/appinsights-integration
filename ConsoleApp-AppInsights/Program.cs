using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights.DataContracts;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.VisualBasic;

namespace ConsoleApp.AppInsights
{
    internal class Program
    {
        static void Main(string[] args)
        {
            // In this scenario we call Application Insights API directly
            TelemetryConfiguration configuration = TelemetryConfiguration.CreateDefault();

            configuration.ConnectionString = "InstrumentationKey=d1bd2953-8f92-4657-b2c0-cf23a6fc8c85;IngestionEndpoint=https://centralus-2.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/";
            configuration.TelemetryInitializers.Add(new HttpDependenciesParsingTelemetryInitializer());

            //TelemetryConfiguration configuration = TelemetryConfiguration.Active; // Reads ApplicationInsights.config file if present

            var telemetryClient = new TelemetryClient(configuration);
            using (InitializeDependencyTracking(configuration))
            {
                // run app...

                // repeat the submission 10 times
                for (int i = 0; i < 10; i++)
                {
                    var traceMessage = randomTraceMessage();
                    telemetryClient.TrackTrace(traceMessage, randomSeverityLevel());

                    using (var httpClient = new HttpClient())
                    {
                        // Http dependency is automatically tracked!
                        httpClient.GetAsync("https://microsoft.com").Wait();
                    }

                    Task.Delay(2000).Wait();
                }

            }

            // before exit, flush the remaining data
            telemetryClient.Flush();

            // Console apps should use the WorkerService package.
            // This uses ServerTelemetryChannel which does not have synchronous flushing.
            // For this reason we add a short 5s delay in this sample.

            Task.Delay(5000).Wait();

            // If you're using InMemoryChannel, Flush() is synchronous and the short delay is not required.

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

        static SeverityLevel randomSeverityLevel()
        {
            // pick up randomly a severity level out of: Verbose,Information,Warning,Error,Critical
            var rnd = new Random();
            var selected = (SeverityLevel)rnd.Next(1, 5);
            return selected;
        }

        static string randomTraceMessage()
        {
            // pick up randomy a message out of messages.txt file
            var messages = File.ReadAllText("messages.txt").Split('.').ToList();

            var rnd = new Random();
            return messages[rnd.Next(0, messages.Count-1)];
        }
    }
}
