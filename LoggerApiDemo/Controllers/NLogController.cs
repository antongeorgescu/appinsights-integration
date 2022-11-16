using LoggerApiDemo.Utilities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Hosting.Server;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.Http.Json;
using System.Threading.Tasks;
using System.Xml;
using Newtonsoft;
using Newtonsoft.Json.Linq;
using LoggerApiDemo.Interfaces;
using LoggerApiDemo.Classes;
using NLog.Targets;
using NLog;
using NLog.Fluent;

namespace LoggerApiDemo.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class NLogController : ControllerBase
    {
        private readonly ILoggerService _logger;
                
        public NLogController(ILoggerService logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"NLog controller instance created at {DateTime.Now}");
        }

        [HttpPost("log/info")]
        public async Task<IActionResult> PostInfo([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            await _logger.LogInfo($"|CLASS:{entry.Class}|MESSAGE:{entry.Message}");

            return Ok($"INFO log saved on {DateTime.Now}");
        }

        [HttpPost("log/debug")]
        public IActionResult PostDebug([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogDebug($"|CLASS:{entry.Class}|MESSAGE:{entry.Message}");
            return Ok($"DEBUG log saved on {DateTime.Now}");
        }

        [HttpPost("log/warn")]
        public IActionResult PostWarn([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogWarn($"|CLASS:{entry.Class}|MESSAGE:{entry.Message}");
            return Ok($"WARN log saved on {DateTime.Now}");
        }

        [HttpPost("log/error")]
        public IActionResult PostError([FromBody] LoggerEntry entry)
        {
            if (string.IsNullOrEmpty(entry.Message))
                return BadRequest();

            _logger.LogError($"|CLASS:{entry.Class}|MESSAGE:{entry.Message}");
            return Ok($"ERROR log saved on {DateTime.Now}");
        }

        [HttpGet("logs/{logtype}")]
        public IActionResult Get(string logtype)
        {
            // get 'logs' dir path
            var dirPath = $"{Directory.GetCurrentDirectory()}\\logs";
            var logFiles = Directory.GetFiles(dirPath).ToList();

            var results = new List<string>();
            foreach (string logFilePath in logFiles)
            {
                //string path = System.Web.HttpContext.Current.Request.MapPath("~\\dataset.csv");
                //var filePath = ThisServer.MapPath("logs");
                var logFileName = logFilePath.Split("\\").Last();
                var filePath = Path.Combine($"{Directory.GetCurrentDirectory()}\\logs", logFileName);
                foreach (string result in System.IO.File.ReadAllLines(filePath).Where(x => x.Contains(logtype)))
                    results.Add(result);
            }
            return Ok(results);
        }
    }
}
