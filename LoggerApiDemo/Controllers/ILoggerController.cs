using LoggerApiDemo.LoggerClasses;
using Microsoft.ApplicationInsights;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ActionConstraints;
using Microsoft.Azure.Cosmos.Serialization.HybridRow;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Threading.Tasks;
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

        public ILoggerController([NotNull] ILogger<ILoggerController> logger, IConfiguration configuration)
        {
            _logger = logger;
            _configuration = configuration;
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
        public IActionResult PostDebug([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogDebug(eventId: new EventId(0, entry.HashKey),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"DEBUG log saved on {DateTime.Now}");
        }

        [HttpPost("log/warn")]
        public IActionResult PostWarn([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogWarning(eventId: new EventId(0, entry.HashKey),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"WARN log saved on {DateTime.Now}");
        }

        [HttpPost("log/error")]
        public IActionResult PostError([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogError(eventId: new EventId(0, entry.HashKey),
                                exception: new Exception($"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}"),
                                message: $"SOURCE*NetCoreILogger*ID*{entry.HashKey}*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");

            return Ok($"ERROR log saved on {DateTime.Now}");
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
    }
}
