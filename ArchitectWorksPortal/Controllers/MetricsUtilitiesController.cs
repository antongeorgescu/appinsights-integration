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
using Azure;
using Microsoft.IdentityModel.Abstractions;
using Newtonsoft.Json;

namespace AngularSpaWebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MetricsUtilitiesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        
        static internal string[]? _trackedWebDependencies;
        static internal string[]? _trackedWebAvailability;
        static internal string? _telemetryConfigConnectionString;
        static internal string? _quickPulseApiKey;

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

        [HttpGet("serverrequests/{count}/apm/appinsights")]
        public async Task<ActionResult<string>> GenerateServerRequestsAppInsights(int count)
        {
            // Create a TelemetryConfiguration instance.
            TelemetryConfiguration? config = TelemetryConfiguration.CreateDefault();
            config.ConnectionString = _telemetryConfigConnectionString;

            // Create a TelemetryClient instance. It is important
            // to use the same TelemetryConfiguration here as the one
            // used to set up Live Metrics.
            TelemetryClient? client = new TelemetryClient(config);

            using (var opSynthRequest = client.StartOperation<RequestTelemetry>("SynthRequest"))
            {
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

                // This sample runs indefinitely. Replace with actual application logic.
                Random rns = new Random();
                int okCount = 0;
                for (int i = 0; i < count; i++)
                {
                    // Send dependency and request telemetry.
                    // These will be shown in Live Metrics.
                    // CPU/Memory Performance counter is also shown
                    // automatically without any additional steps.
                    var inx = rns.Next(0, _trackedWebDependencies.Length - 1);

                    using (var opSynthTrackDepends = client.StartOperation<RequestTelemetry>("SynthTrackedDependencies"))
                    {
                        opSynthTrackDepends.Telemetry.Properties["target"] = _trackedWebDependencies[inx];
                        try
                        {
                            HttpResponseMessage response = await (new HttpClient()).GetAsync(_trackedWebDependencies[inx]);
                            if (response.IsSuccessStatusCode)
                            {
                                opSynthTrackDepends.Telemetry.Success = true;
                                okCount++;
                            } 
                            else
                                opSynthTrackDepends.Telemetry.Success = false;

                        }
                        catch (Exception ex)
                        {
                            opSynthTrackDepends.Telemetry.Success = false;
                        }
                    }
                    
                    //client
                    Task.Delay(1000).Wait();
                }
                opSynthRequest.Telemetry.Properties["OK pings"] = okCount.ToString();
                opSynthRequest.Telemetry.Properties["Error pings"] = (count - okCount).ToString();

                opSynthRequest.Telemetry.Success = true;
                return Ok(Content($"Successful {okCount},failed {count - okCount} out of {count} submitted probes."));
            }
        }

        [HttpGet("availabilityprobes/apm/appinsights")]
        public async Task<ActionResult> GenerateAvailabilityProbesAppInsights()
        {
            // Create a TelemetryConfiguration instance.
            TelemetryConfiguration config = TelemetryConfiguration.CreateDefault();
            config.ConnectionString = _telemetryConfigConnectionString;
            config.TelemetryChannel = new InMemoryChannel();

            // Create a TelemetryClient instance. It is important
            // to use the same TelemetryConfiguration here as the one
            // used to set up Live Metrics.
            TelemetryClient client = new TelemetryClient(config);
            string response;
            using (var opSynthRequest = client.StartOperation<RequestTelemetry>("SynthAvailabilityRequest"))
            {
                var availabilityTelemetry = new AvailabilityTelemetry
                {
                    Id = Guid.NewGuid().ToString("N"),
                    Name = "ProbeAvailabilityOfSynthURL",
                    RunLocation = "Central US",
                    Success = false,
                };

                availabilityTelemetry.Context.Operation.ParentId = Activity.Current?.SpanId.ToString();
                availabilityTelemetry.Context.Operation.Id = Activity.Current?.RootId;
                
                try
                {
                    var result = await RunAvailabilityTestAsync();
                    response = $"{result}";
                    availabilityTelemetry.Success = true;
                }
                catch (Exception ex)
                {
                    availabilityTelemetry.Message = ex.Message;

                    var exceptionTelemetry = new ExceptionTelemetry(ex);
                    exceptionTelemetry.Context.Operation.Id = availabilityTelemetry.Id;
                    exceptionTelemetry.Properties.Add("TestName", availabilityTelemetry.Name);
                    exceptionTelemetry.Properties.Add("TestLocation", availabilityTelemetry.RunLocation);
                    client.TrackException(exceptionTelemetry);

                    response = $"Error:{ex.Message}";
                }

                finally
                {
                    client.Flush();
                }
                opSynthRequest.Telemetry.Success = true;
                return Ok(Content(response));
            }

        }

        public async static Task<string> RunAvailabilityTestAsync()
        {
            int _inx;
            using (var httpClient = new HttpClient())
            {
                Random rns = new Random();
                _inx = rns.Next(0, _trackedWebAvailability.Length - 1);
                var result = await httpClient.GetAsync(_trackedWebAvailability[_inx]);
                //var message = result.Content.ReadAsStringAsync().Result;
                
                return $"{result.StatusCode}:{_trackedWebAvailability[_inx]}";
            }
        }
    }
}
