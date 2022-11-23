using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
using System.Net;
using AngularSpaWebApi.Logger;
using AngularSpaWebApi.Services;
using Newtonsoft.Json.Linq;
using ArchitectWorksPortal.SyntheticExceptionClasses;
using System.Net.Http;
using System;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights.Extensibility.PerfCounterCollector.QuickPulse;
using Microsoft.ApplicationInsights;
using System.IO;
using Microsoft.ApplicationInsights.Channel;
using Microsoft.ApplicationInsights.DataContracts;
using static Microsoft.ApplicationInsights.MetricDimensionNames.TelemetryContext;
using System.Diagnostics;

namespace AngularSpaWebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MetricsUtilitiesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        
        static internal string[] _trackedWebDependencies;
        static internal string[] _trackedWebAvailability;
        static internal string _telemetryConfigConnectionString;
        static internal string _quickPulseApiKey;

        public MetricsUtilitiesController(IConfiguration configuration)
        {
            _configuration = configuration;

            _telemetryConfigConnectionString = _configuration.GetSection($"AppInsightsMetrics:Telemetry.ConnectionString").Value;
            _quickPulseApiKey = _configuration.GetSection($"AppInsightsMetrics:QuickPulseModule.ApiKey").Value;

            _trackedWebDependencies = _configuration.GetSection($"AppInsightsMetrics:TrackWebDependencies").Get<string[]>();
            _trackedWebAvailability = _configuration.GetSection($"AppInsightsMetrics:TrackWebAvailability").Get<string[]>();

        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"MetricsUtilities API started at {DateTime.Now}");
        }

        [HttpGet("connection")]
        public IActionResult GetConnectionStatus()
        {
            return Ok(new { status = "Good", datetime = DateTime.Now.ToString() });
        }

        [HttpGet("serverrequests/{count}")]
        public async Task<ActionResult<string>> GenerateServerRequests(int count)
        {
            var startRequest = new DateTime();
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            // Create a TelemetryConfiguration instance.
            TelemetryConfiguration config = TelemetryConfiguration.CreateDefault();
            config.ConnectionString = _telemetryConfigConnectionString;
            QuickPulseTelemetryProcessor? quickPulseProcessor = null;
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
            quickPulseModule.AuthenticationApiKey = _quickPulseApiKey;
            quickPulseModule.Initialize(config);
            quickPulseModule.RegisterTelemetryProcessor(quickPulseProcessor);

            // Create a TelemetryClient instance. It is important
            // to use the same TelemetryConfiguration here as the one
            // used to set up Live Metrics.
            TelemetryClient client = new TelemetryClient(config);

            // This sample runs indefinitely. Replace with actual application logic.
            Random rns = new Random();
            for (int i = 0; i < count; i++)
            {
                // Send dependency and request telemetry.
                // These will be shown in Live Metrics.
                // CPU/Memory Performance counter is also shown
                // automatically without any additional steps.
                var inx = rns.Next(0, _trackedWebDependencies.Length-1);

                var startCall = new DateTime();
                TimeSpan callDuration = TimeSpan.Zero;
                try
                {
                    HttpResponseMessage response = await (new HttpClient()).GetAsync(_trackedWebDependencies[inx]);
                    stopwatch.Stop();
                    if (response.IsSuccessStatusCode)
                    {
                        client.TrackDependency("SynthTrackedDependencies", "target", _trackedWebDependencies[inx], startCall, callDuration, true);
                        client.TrackRequest("SynthRequests", startRequest, new TimeSpan(stopwatch.ElapsedTicks), "200", true);
                    }
                    else
                    {
                        client.TrackDependency("SynthTrackedDependencies", "target", _trackedWebDependencies[inx], startCall, callDuration, false);
                        client.TrackRequest("SynthRequests", startRequest, new TimeSpan(stopwatch.ElapsedTicks), response.StatusCode.ToString(), false);
                    }
                }
                catch (Exception ex)
                {
                    client.TrackDependency("SynthTrackedDependencies", "target", _trackedWebDependencies[inx], startCall, callDuration, false);
                    client.TrackRequest("SynthRequests", startRequest, new TimeSpan(stopwatch.ElapsedTicks), "500", false);
                }

                //client
                Task.Delay(1000).Wait();
            }
            return Ok(Content($"{count} tracked server requests collected."));
        }

        [HttpGet("availabilityprobes")]
        public async Task<ActionResult> GenerateAvailabilityProbes()
        {
            // Create a TelemetryConfiguration instance.
            TelemetryConfiguration config = TelemetryConfiguration.CreateDefault();
            config.ConnectionString = _telemetryConfigConnectionString;
            config.TelemetryChannel = new InMemoryChannel();

            // Create a TelemetryClient instance. It is important
            // to use the same TelemetryConfiguration here as the one
            // used to set up Live Metrics.
            TelemetryClient client = new TelemetryClient(config);

            var availability = new AvailabilityTelemetry
            {
                Name = "ProbeAvailabilityOfSynthURL",
                RunLocation = "Central US",
                Success = false,
            };

            availability.Context.Operation.ParentId = Activity.Current?.SpanId.ToString();
            availability.Context.Operation.Id = Activity.Current?.RootId;
            var stopwatch = new Stopwatch();
            stopwatch.Start();

            string response;
            try
            {
                using (var activity = new Activity("AvailabilityContext"))
                {
                    activity.Start();
                    availability.Id = Activity.Current?.SpanId.ToString();
                    // Run business logic 
                    response = await RunAvailabilityTestAsync();
                }
                availability.Success = true;
            }

            catch (Exception ex)
            {
                availability.Message = ex.Message;
                throw;
            }

            finally
            {
                stopwatch.Stop();
                availability.Duration = stopwatch.Elapsed;
                availability.Timestamp = DateTimeOffset.UtcNow;
                client.TrackAvailability(availability);
                client.Flush();

                
            }
            return Ok(Content(response));


        }

        public async static Task<string> RunAvailabilityTestAsync()
        {
            int _inx;
            using (var httpClient = new HttpClient())
            {
                Random rns = new Random();
                _inx = rns.Next(0, MetricsUtilitiesController._trackedWebAvailability.Length - 1);
                await httpClient.GetStringAsync(_trackedWebAvailability[_inx]);
                return $"Probed for availability {_trackedWebAvailability[_inx]}";
            }
        }
    }
}
