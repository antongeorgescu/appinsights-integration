using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System;
using System.Text.RegularExpressions;
using System.Runtime.Intrinsics.X86;
using System.Security.Cryptography.Xml;
using Microsoft.Extensions.Configuration;
using WebApiDemo.Services;
using System.Drawing;

namespace WebApiDemo.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ExceptionUtilitiesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        static internal List<string> HttpResponseStatusList;
        static internal List<Tuple<string, string, string>> CodeClassDescriptionList;

        public ExceptionUtilitiesController(IConfiguration configuration)
        {
            _configuration = configuration;

            HttpResponseStatusList = _configuration.GetSection($"HttpResponse")
                                        .GetChildren()
                                        .Select(x => x.Key)
                                        .ToList();
            var netCodeClassList = _configuration.GetSection($"Exceptions:netcore")
                                        .GetChildren()
                                        .Select(x => new Tuple<string, string, string>(x.Key, x.Value.Split('|')[0], x.Value.Split('|')[1]))
                                        .ToList();
            var ngCodeClassList = _configuration.GetSection($"Exceptions:angular")
                                        .GetChildren()
                                        .Select(x => new Tuple<string, string, string>(x.Key, x.Value.Split('|')[0], x.Value.Split('|')[1]))
                                        .ToList();
            CodeClassDescriptionList = new List<Tuple<string, string, string>>();
            CodeClassDescriptionList.AddRange(netCodeClassList);
            CodeClassDescriptionList.AddRange(ngCodeClassList);
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"MLUtilities API started at {DateTime.Now}");
        }

        [HttpGet("generatetext/{count}")]
        public ActionResult<string> GenerateText(int count)
        {
            var lstWords = ExceptionServices.GenerateSyntheticMessage(count);
            return Ok(string.Join(' ', lstWords));
        }

        [HttpGet("extypelist/{framework}")]
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

        [HttpGet("exceptionlist/{count}/{framework}")]
        public ActionResult<IEnumerable<ThrowErrorRequest>> GetRandomFrameworkExceptions(int count,string framework)
        {
            var exceptions = ExceptionServices.GenerateRandomErrorList(count,framework);
            return Ok(exceptions);
        }

        [HttpGet("exceptionlist/{count}")]
        public ActionResult<IEnumerable<ThrowErrorRequest>> GetRandomExceptions(int count)
        {
            var exceptions = ExceptionServices.GenerateRandomErrorList(count);
            return Ok(exceptions);
        }
    }
}
