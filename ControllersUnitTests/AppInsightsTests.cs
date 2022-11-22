using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using static ControllersUnitTests.Utilities;
using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.QuickPulse;

namespace ControllersUnitTests.AppInsights
{
    [TestClass]
    public class AppInsightsTests
    {
        private TestContext testContextInstance;

        /// <summary>
        /// Gets or sets the test context which provides
        /// information about and functionality for the current test run.
        /// </summary>
        public TestContext TestContext
        {
            get { return testContextInstance; }
            set { testContextInstance = value; }
        }

        [TestMethod]
        public void TestSaveLogToAppInisights()
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

            Assert.IsNotNull(telemetryClient);
        }

        [TestMethod]
        public void TestLiveMetricsAppInisights()
        {
            // Create a TelemetryConfiguration instance.
            TelemetryConfiguration config = TelemetryConfiguration.CreateDefault();
            config.ConnectionString = "InstrumentationKey=d1bd2953-8f92-4657-b2c0-cf23a6fc8c85;IngestionEndpoint=https://centralus-2.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/";
            QuickPulseTelemetryProcessor quickPulseProcessor = null;
            config.DefaultTelemetrySink.TelemetryProcessorChainBuilder
                .Use((next) =>
                {
                    quickPulseProcessor = new QuickPulseTelemetryProcessor(next);
                    return quickPulseProcessor;
                })
                .Build();

            var quickPulseModule = new QuickPulseTelemetryModule();

            // Secure the control channel.
            // This is optional, but recommended.
            quickPulseModule.AuthenticationApiKey = "pjsao6g5ej1n4bqxzatj4we8qibg0wfhd1npmrnu";
            quickPulseModule.Initialize(config);
            quickPulseModule.RegisterTelemetryProcessor(quickPulseProcessor);

            // Create a TelemetryClient instance. It is important
            // to use the same TelemetryConfiguration here as the one
            // used to set up Live Metrics.
            TelemetryClient client = new TelemetryClient(config);

            // This sample runs indefinitely. Replace with actual application logic.
            for (int i = 0;i< 100;i++)
            {
                // Send dependency and request telemetry.
                // These will be shown in Live Metrics.
                // CPU/Memory Performance counter is also shown
                // automatically without any additional steps.
                client.TrackDependency("My dependency", "target", "https://www.bbc.com/future/article/20221118-the-martian-robots-that-came-to-life",
                    DateTimeOffset.Now, TimeSpan.FromMilliseconds(10), true);
                client.TrackRequest("My Request", DateTimeOffset.Now,
                    TimeSpan.FromMilliseconds(5), "200", true);
                Task.Delay(1000).Wait();
            }

            Assert.IsNotNull(client);
        }
    }
}
