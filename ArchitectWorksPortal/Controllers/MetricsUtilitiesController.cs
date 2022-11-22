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

namespace AngularSpaWebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class MetricsUtilitiesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        
        static internal string[] _trackedWebRequests;
        static internal string _telemetryConfigConnectionString;
        static internal string _quickPulseApiKey;

        public MetricsUtilitiesController(IConfiguration configuration)
        {
            _configuration = configuration;

            _telemetryConfigConnectionString = _configuration.GetSection($"AppInsightsMetrics:Telemetry.ConnectionString").Value;
            _quickPulseApiKey = _configuration.GetSection($"AppInsightsMetrics:QuickPulseModule.ApiKey").Value;

            _trackedWebRequests = _configuration.GetSection($"AppInsightsMetrics:TrackWebDependencies").Get<string[]>();
            
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
        public async Task<ActionResult<string>> GenerateText(int count)
        {
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
                var inx = rns.Next(0, _trackedWebRequests.Length-1);

                var startCall = new DateTime();
                TimeSpan callDuration = TimeSpan.Zero;
                try
                {
                    HttpResponseMessage response = await (new HttpClient()).GetAsync(_trackedWebRequests[inx]);
                    if (response.IsSuccessStatusCode)
                    {
                        callDuration = (new DateTime()).Subtract(startCall);
                        client.TrackDependency("SynthTrackedDependencies", "target", _trackedWebRequests[inx], startCall, callDuration, true);
                        client.TrackRequest("SynthRequests", startCall, callDuration, "200", true);
                    }
                    else
                    {
                        client.TrackDependency("SynthTrackedDependencies", "target", _trackedWebRequests[inx], startCall, callDuration, false);
                        callDuration = (new DateTime()).Subtract(startCall);
                        client.TrackRequest("SynthRequests", startCall, callDuration, response.StatusCode.ToString(), true);
                    }
                }
                catch (Exception ex)
                {
                    client.TrackDependency("SynthTrackedDependencies", "target", _trackedWebRequests[inx], startCall, callDuration, false);
                    callDuration = (new DateTime()).Subtract(startCall);
                    client.TrackRequest("SynthRequests", startCall, callDuration, "500", true);
                }

                //client
                Task.Delay(1000).Wait();
            }
            return Ok(Content($"{count} tracked server requests collected."));
        }

        
    }
}
