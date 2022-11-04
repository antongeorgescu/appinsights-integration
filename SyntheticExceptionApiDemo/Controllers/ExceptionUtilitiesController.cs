using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System;
using System.Text.RegularExpressions;
using System.Runtime.Intrinsics.X86;
using System.Security.Cryptography.Xml;
using Microsoft.Extensions.Configuration;
using WebApiDemo.Utilities;
using System.Drawing;

namespace WebApiDemo.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ExceptionUtilitiesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        public ExceptionUtilitiesController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"MLUtilities API started at {DateTime.Now}");
        }

        [HttpGet("generatetext/{count}")]
        public ActionResult<string> GenerateText(int count)
        {
            var lstWords = ServiceUtilities.GenerateSyntheticMessage(count);
            return Ok(string.Join(' ',lstWords));
        }

        [HttpGet("exceptionlist/{framework}")]
        public ActionResult<IEnumerable<string>> GetExceptionList(string framework)
        {
            var exceptions = _configuration.GetSection($"Exceptions:{framework}").GetChildren();
            return Ok(exceptions);
        }

        [HttpPost("throwexception/instance")]
        public ActionResult<string> ThrowErrorInstance([FromForm] ThrowErrorRequest errorRequest)
        {
            if (string.IsNullOrEmpty(errorRequest.Code))
                return BadRequest();

            var exceptionAttributes = _configuration.GetSection($"Exceptions:{errorRequest.Framework}")
                                        .GetChildren()
                                        .ToList()
                                        .First(x => x.Key == errorRequest.Code).Value.Split('|');
            
            errorRequest.Class = exceptionAttributes[0];
            errorRequest.Description = exceptionAttributes[1];

            errorRequest.Generate();

            return Ok(errorRequest);
        }

        [HttpPost("throwexception/serialized")]
        public ActionResult<string> ThrowErrorSerialized([FromForm] ThrowErrorRequest errorRequest)
        {
            if (string.IsNullOrEmpty(errorRequest.Code))
                return BadRequest();

            var exceptionAttributes = _configuration.GetSection($"Exceptions:{errorRequest.Framework}")
                                        .GetChildren()
                                        .ToList()
                                        .First(x => x.Key == errorRequest.Code).Value.Split('|');

            errorRequest.Class = exceptionAttributes[0];
            errorRequest.Description = exceptionAttributes[1];

            errorRequest.Generate();

            return Ok(errorRequest.Serialized);
        }
    }
}
