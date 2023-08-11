using LoggerApiDemo.LoggerClasses;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ActionConstraints;
using Microsoft.Azure.Cosmos;
using Microsoft.Azure.Cosmos.Serialization.HybridRow;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Security.Policy;
using System.Text.Json;
using System.Threading.Tasks;
using System.Web.Http.Results;
using static System.Net.Mime.MediaTypeNames;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace LoggerApiDemo.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class ILoggerController : ControllerBase
    {
        protected readonly ILogger<ILoggerController> _logger;
        private readonly IConfiguration _configuration;
        private readonly string _site24x7Uri;
        private string _jsonObject;

        public ILoggerController([NotNull] ILogger<ILoggerController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
            _site24x7Uri = @"https://logc.site24x7.com/event/receiver?token=ODgyMDk3ZjVjODU4YTQxZmMzYjc0YzFjOTc5ZDU3NzUvc3R1ZGVudGxlbmRpbmdwb2Nsb2d0eXBl";
            _jsonObject = "{\"_zl_timestamp\": 1691589174750,\"loglevel\": \"WARN\",\"message\": \"*EVENTorID* Hosting environment down: Development\"}";
        }

        [HttpGet]
        public IActionResult Get()
        {
            // returns the status of service
            return Ok($"ILogger API instance started at {DateTime.Now}");
        }

        [HttpGet("connection")]
        public IActionResult GetConnectionStatus()
        {
            return Ok(new { status = "Good", datetime = DateTime.Now.ToString() });
        }

        [HttpGet("apmactive/{apmname}")]
        public IActionResult GetIsApmActive(string apmname)
        {
            // check if required APM is active in appsettings.json
            var apmName = (apmname == "appinsights") ? "ApplicationInsights" : "AppDynamics";
            if (_configuration.GetSection($"Logging:{apmName}").GetChildren().Count() == 0)
                return BadRequest(new { status = $"{apmName} is inactive" });

            return Ok(new { status = $"{apmName} is active" });
        }

        [HttpPost("log/info")]
        public async Task<IActionResult> PostInfo([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogInformation(eventId: new EventId(0, entry.HashKey),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");

            return Ok($"INFO log saved on {DateTime.Now}");
        }

        [HttpPost("log/debug")]
        public async Task<IActionResult> PostDebug([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogDebug(eventId: new EventId(0, entry.HashKey),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");

            return Ok($"DEBUG log saved on {DateTime.Now}");
        }

        [HttpPost("log/warn")]
        public async Task<IActionResult> PostWarn([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogWarning(eventId: new EventId(0, entry.HashKey),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");

            return Ok($"WARN log saved on {DateTime.Now}");
        }

        [HttpPost("log/error")]
        public async Task<IActionResult> PostError([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();


            _logger.LogError(eventId: new EventId(0, entry.HashKey),
                                exception: new Exception($"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}"),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            try
            {
                // call Site24x7 Logger service to log exceptions
                using HttpClient client = new();
                client.DefaultRequestHeaders.Accept.Clear();
                client.DefaultRequestHeaders.Accept.Add(
                    new MediaTypeWithQualityHeaderValue("application/json"));


                var logTimestamp = new DateTimeOffset(DateTime.UtcNow).ToUnixTimeSeconds();

                var logObj = new
                {
                    _zl_timestamp = logTimestamp,
                    LogLevel = "ERROR",
                    Message = $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}"
                };

                _jsonObject = JsonSerializer.Serialize(logObj);

                var _content = new StringContent(_jsonObject);
                
                using HttpResponseMessage response0 = await client.PostAsync(_site24x7Uri, _content);
                if (!response0.StatusCode.Equals(HttpStatusCode.OK))
                    return BadRequest(response0.Content.ReadAsStringAsync().Result);

                return Ok($"ERROR log saved on {DateTime.Now}");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }
        }

        [HttpPost("appinsights/error")]
        public IActionResult PostErrorAppInsights([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            // save "error" severity on ApplicationInsights if configured
            if (_configuration.GetSection($"Logging:ApplicationInsights").GetChildren().Count() > 0)
            {
                TelemetryClient appInsClient = new();
                
                appInsClient.TrackException(new ExceptionTelemetry()
                {
                    SeverityLevel = SeverityLevel.Error,
                    Message = $"SOURCE*AppInsightsLib*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}"
                });
            }
            return Ok($"ERROR log saved in AppInsights on {DateTime.Now}");
        }


        [HttpPost("log/trace")]
        public IActionResult PostTrace([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogTrace(eventId: new EventId(0, entry.HashKey),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"TRACE log saved on {DateTime.Now}");
        }

        [HttpPost("log/critical")]
        public IActionResult PostCritical([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogCritical($"|CLASS:{entry.Class}|MESSAGE:{entry.Message}", "POST"); _logger.LogInformation(eventId: new EventId(0, entry.HashKey),
                                exception: new Exception($"SOURCE*ILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}"),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"CRITICAL log saved on {DateTime.Now}");
        }

        [HttpPost("appinsights/critical")]
        public IActionResult PostCriticalAppInsights([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            // save "critical" severity on ApplicationInsights if configured
            if (_configuration.GetSection($"Logging:ApplicationInsights").GetChildren().Count() > 0)
            {
                TelemetryClient appInsClient = new();
                appInsClient.TrackException(new ExceptionTelemetry()
                {
                    SeverityLevel = SeverityLevel.Critical,
                    Message = $"SOURCE*AppInsightsLib*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}"
                });
            }

            return Ok($"CRITICAL log saved in Appinsights on {DateTime.Now}");
        }

        [HttpGet("logs/nlog/{logtype}")]
        public IActionResult GetNlogLogType(string logtype)
        {
            // get 'logs' dir path
            var dirPath = $"{Directory.GetCurrentDirectory()}\\logs";
            var logFiles = Directory.GetFiles(dirPath).ToList();

            var results = new List<string>();
            foreach (string logFilePath in logFiles)
            {
                //string path = System.Web.HttpContext.Current.Request.MapPath("~\\dataset.csv");
                //var filePath = ThisServer.MapPath("logs");
                if (logFilePath.Contains("_logfile.txt"))
                {
                    var logFileName = logFilePath.Split("\\").Last();
                    var filePath = Path.Combine($"{Directory.GetCurrentDirectory()}\\logs", logFileName);
                    foreach (string result in System.IO.File.ReadAllLines(filePath).Where(x => x.Contains(logtype)))
                        results.Add(result);
                }
            }
            return Ok(results);
        }

        [HttpGet("logfiles")]
        public IActionResult GetLogFiles()
        {
            // get 'logs' dir path
            var dirPath = $"{Directory.GetCurrentDirectory()}\\logs";
            var logFiles = Directory.GetFiles(dirPath).ToList();

            var results = new List<string>();
            foreach (string logFilePath in logFiles)
            {
                results.Add(logFilePath);
            }
            return Ok(results);
        }

        [HttpGet("logfilecontent/{filename}")]
        public IActionResult GetLogFileContent(string filename)
        {
            string logcontent = string.Empty;
            try
            {
                // get 'logs' dir path
                var dirPath = $"{Directory.GetCurrentDirectory()}\\logs";
                logcontent = System.IO.File.ReadAllText($"{dirPath}\\{filename}");
                return Ok(logcontent);
            }
            catch(Exception ex)
            { 
                logcontent = ex.Message; 
                return BadRequest(logcontent);
            }
                
        }

        [HttpGet("health")]
        public IActionResult GetHealthStatus()
        {
            string logcontent = string.Empty;
            try
            {
                // get 'logs' dir path
                var dirPath = $"{Directory.GetCurrentDirectory()}\\logs";
                int fCount = Directory.GetFiles(dirPath, "*", SearchOption.TopDirectoryOnly).Length;
                return Ok($"Log filed count:{fCount}");
            }
            catch (Exception ex)
            {
                return BadRequest(ex.Message);
            }

        }
    }
}
