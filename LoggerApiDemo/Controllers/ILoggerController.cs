using LoggerApiDemo.LoggerClasses;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ActionConstraints;
using Microsoft.Azure.Cosmos.Serialization.HybridRow;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
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

        public ILoggerController([NotNull] ILogger<ILoggerController> logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"ILogger API instance started at {DateTime.Now}");
        }

        [HttpPost("log/info")]
        public async Task<IActionResult> PostInfo([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogInformation(eventId: new EventId(0, entry.HashKey),
                                message: $"*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");

            return Ok($"INFO log saved on {DateTime.Now}");
        }

        [HttpPost("log/debug")]
        public IActionResult PostDebug([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogDebug(eventId: new EventId(0, entry.HashKey),
                                message: $"*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"DEBUG log saved on {DateTime.Now}");
        }

        [HttpPost("log/warn")]
        public IActionResult PostWarn([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogWarning(eventId: new EventId(0, entry.HashKey),
                                message: $"*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"WARN log saved on {DateTime.Now}");
        }

        [HttpPost("log/error")]
        public IActionResult PostError([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogError(eventId: new EventId(0, entry.HashKey),
                                exception: new Exception($"*CLASS*{entry.Class}*MESSAGE*{entry.Message}"),
                                message: $"*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"ERROR log saved on {DateTime.Now}");
        }

        [HttpPost("log/trace")]
        public IActionResult PostTrace([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogTrace(eventId: new EventId(0, entry.HashKey),
                                message: $"*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"TRACE log saved on {DateTime.Now}");
        }

        [HttpPost("log/critical")]
        public IActionResult PostCritical([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogCritical($"|CLASS:{entry.Class}|MESSAGE:{entry.Message}", "POST"); _logger.LogInformation(eventId: new EventId(0, entry.HashKey),
                                exception: new Exception($"*CLASS*{entry.Class}*MESSAGE*{entry.Message}"),
                                message: $"*CLASS*{entry.Class}*MESSAGE*{entry.Message}",
                                "POST");
            return Ok($"CRITICAL log saved on {DateTime.Now}");
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
            // get 'logs' dir path
            var dirPath = $"{Directory.GetCurrentDirectory()}\\logs";
            var logcontent = System.IO.File.ReadAllText($"{dirPath}\\{filename}");
            
            return Ok(logcontent);
        }
    }
}
