using LoggerApiDemo.Services;
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

namespace LoggerApiDemo.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class LoggerController : ControllerBase
    {
        private readonly ILoggerManager _logger;
                
        public LoggerController(ILoggerManager logger)
        {
            _logger = logger;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"Logger service started at {DateTime.Now}");
        }

        [HttpPost("log/info")]
        public IActionResult PostInfo([FromForm] LoggerMessage message)
        {
            if (string.IsNullOrEmpty(message.Description))
                return BadRequest();

            _logger.LogInfo($"|CLASS:{message.Class}|DESCRIPTION:{message.Description}");
            return Ok($"INFO log saved on {DateTime.Now}");
        }

        [HttpPost("log/debug")]
        public IActionResult PostDebug([FromForm] LoggerMessage message)
        {
            if (string.IsNullOrEmpty(message.Description))
                return BadRequest();

            _logger.LogDebug($"|CLASS:{message.Class}|DESCRIPTION:{message.Description}");
            return Ok($"DEBUG log saved on {DateTime.Now}");
        }

        [HttpPost("log/warn")]
        public IActionResult PostWarn([FromForm] LoggerMessage message)
        {
            if (string.IsNullOrEmpty(message.Description))
                return BadRequest();

            _logger.LogWarn($"|CLASS:{message.Class}|DESCRIPTION:{message.Description}");
            return Ok($"WARN log saved on {DateTime.Now}");
        }

        [HttpPost("log/error")]
        public IActionResult PostError([FromForm] LoggerMessage message)
        {
            if (string.IsNullOrEmpty(message.Description))
                return BadRequest();

            _logger.LogError($"|CLASS:{message.Class}|DESCRIPTION:{message.Description}");
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
