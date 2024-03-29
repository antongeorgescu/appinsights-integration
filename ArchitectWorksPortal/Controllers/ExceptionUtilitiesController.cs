﻿using Microsoft.AspNetCore.Mvc;
using System.Net.Http.Headers;
using System.Net;
using AngularSpaWebApi.Logger;
using AngularSpaWebApi.Services;
using Newtonsoft.Json.Linq;
using ArchitectWorksPortal.SyntheticExceptionClasses;
using System.Net.Http;
using System;
using ArchitectWorksPortal.Repositories;
using ArchitectWorksPortal.UtilityClasses;
using Extensions = ArchitectWorksPortal.UtilityClasses.Extensions;
using System.Web.Http;
using RouteAttribute = Microsoft.AspNetCore.Mvc.RouteAttribute;
using HttpGetAttribute = Microsoft.AspNetCore.Mvc.HttpGetAttribute;
using HttpPostAttribute = Microsoft.AspNetCore.Mvc.HttpPostAttribute;

namespace AngularSpaWebApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    [AppInsightHandleException]
    public class ExceptionUtilitiesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        static internal List<string> HttpResponseStatusList;
        static internal List<Tuple<string, string, string>> CodeClassDescriptionList;
        static internal string _loggerURI;
        private readonly IDatasetRepository _datasetRepo;

        public ExceptionUtilitiesController(IConfiguration configuration,IDatasetRepository datasetRepo)
        {
            _configuration = configuration;
            _datasetRepo = datasetRepo;

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

            _loggerURI = _configuration.GetSection($"LoggerApiUrl").Value;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"ExceptionUtilities API started at {DateTime.Now}");
        }

        [HttpGet("connection")]
        public IActionResult GetConnectionStatus()
        {
            // returns the status of service
            return Ok(new { status = "Good", datetime = DateTime.Now.ToString() });
        }

        [HttpGet("generatetext/{count}")]
        public ActionResult<string> GenerateText(int count)
        {
            var lstWords = ExceptionServices.GenerateSyntheticMessage(count);
            return Ok(string.Join(' ', lstWords));
        }

        [HttpGet("generatemessage/ipsumlorem")]
        public async Task<ActionResult<string>> GenerateMessageIpsumLorem()
        {
            var message = await (new ExceptionServices(_datasetRepo).GenerateRandomLoremIpsumMessageDb());
            return Ok(message);
        }

        [HttpGet("extypelist/{framework}")]
        public ActionResult<IEnumerable<ExceptionType>> GetExceptionList(string framework)
        {
            var lstExceptions = new List<object>();
            if (framework == "all")
            {
                var fxsections = _configuration.GetSection($"Exceptions").GetChildren();
                foreach (var fx in fxsections)
                {
                    var exceptions = _configuration.GetSection($"Exceptions:{fx.Key}").GetChildren();

                    foreach (var extype in exceptions)
                        lstExceptions.Add(
                            new ExceptionType
                            {
                                Framework = fx.Key,
                                Code = extype.Key,
                                Type = extype.Value.ToString().Split('|')[0],
                                Description = extype.Value.ToString().Split('|')[1]
                            });
                }
            }
            else
            {
                var exceptions = _configuration.GetSection($"Exceptions:{framework}").GetChildren();

                foreach (var extype in exceptions)
                    lstExceptions.Add(
                        new ExceptionType
                        {
                            Framework = framework,
                            Code = extype.Key,
                            Type = extype.Value.ToString().Split('|')[0],
                            Description = extype.Value.ToString().Split('|')[1]
                        });
            }
            return Ok(lstExceptions);
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

        [HttpGet("loggerservice/{count}/framework/{framework}/apm/{appname}")]
        public async Task<ActionResult<string>> GetRandomFrameworkExceptionsToLogger(int count,string framework,string appname)
        {
            var exceptions = (new ExceptionServices(_datasetRepo)).GenerateRandomErrorList(count,framework).Result;

            // call Logger service to log exceptions
            using HttpClient client = new();
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/text"));
            client.DefaultRequestHeaders.Add("User-Agent", "Synthetic Exception Generator");

            using HttpResponseMessage response0 = await client.GetAsync($"{_loggerURI}/apmactive/{appname}");
            if (!response0.StatusCode.Equals(HttpStatusCode.OK))
                return BadRequest(response0.Content.ReadAsStringAsync().Result);

            foreach (ThrowErrorRequest ex in exceptions)
            {
                var content = JsonContent.Create(new LoggerEntry(){ 
                    Class = ex.Class,
                    Description = ex.Description,
                    Type = ex.Code,
                    CreateDate = DateTime.Now
                });

                using HttpResponseMessage response = await client.PostAsync($"{_loggerURI}/log/error",content);
                if (!response.StatusCode.Equals(HttpStatusCode.OK))
                    return BadRequest(response.Content.ReadAsStringAsync().Result);
            }

            var okResponse = new HttpResponseMessage();
            okResponse.Content = JsonContent.Create($"{count} synthetic logs for {framework} have been generated.");
            return Ok(okResponse.Content.ReadAsStringAsync().Result);
        }

        [HttpGet("loggerservice/{count}/apm/appinsights")]
        public async Task<ActionResult<string>> GetRandomExceptionsToLoggerAppInsights(int count)
        {
            var exceptions = (new ExceptionServices(_datasetRepo)).GenerateRandomErrorList(count).Result;

            // call Logger service to log exceptions
            using HttpClient client = new();
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/text"));
            client.DefaultRequestHeaders.Add("User-Agent", "Synthetic Exception Generator");

            using HttpResponseMessage response0 = await client.GetAsync($"{_loggerURI}/apmactive/appinsights");
            if (!response0.StatusCode.Equals(HttpStatusCode.OK))
                return BadRequest(response0.Content.ReadAsStringAsync().Result);

            foreach (ThrowErrorRequest ex in exceptions)
            {
                var content = JsonContent.Create(new LoggerEntry()
                {
                    Class = ex.Class,
                    Description = ex.Description,
                    Type = ex.Code,
                    CreateDate = DateTime.Now,
                    Message = ex.Message
                });

                using HttpResponseMessage response = await client.PostAsync($"{_loggerURI}/log/error", content);
                if (!response.StatusCode.Equals(HttpStatusCode.OK))
                    return BadRequest(response.Content.ReadAsStringAsync().Result);
            }

            var okResponse = new HttpResponseMessage();
            okResponse.Content = JsonContent.Create($"{count} synthetic logs have been generated via AspNetCore ILogger.in Logger service");
            return Ok(okResponse.Content.ReadAsStringAsync().Result);
        }

        [HttpGet("appinsightslib/{count}/apm/appinsights")]
        public async Task<ActionResult<string>> GetRandomExceptionsToAppInsightsLib(int count)
        {
            var exceptions = (new ExceptionServices(_datasetRepo)).GenerateRandomErrorList(count).Result;

            // call Logger service to log exceptions
            using HttpClient client = new();
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/text"));
            client.DefaultRequestHeaders.Add("User-Agent", "Synthetic Exception Generator");

            using HttpResponseMessage response0 = await client.GetAsync($"{_loggerURI}/apmactive/appinsights");
            if (!response0.StatusCode.Equals(HttpStatusCode.OK))
                return BadRequest(response0.Content.ReadAsStringAsync().Result);

            string[] severity = new[] { "error", "critical" };
            Random rnd = new();
            foreach (ThrowErrorRequest ex in exceptions)
            {
                var content = JsonContent.Create(new LoggerEntry()
                {
                    Class = ex.Class,
                    Description = ex.Description,
                    Type = ex.Code,
                    CreateDate = DateTime.Now,
                    Message = ex.Message
                });
                var inx = rnd.Next(0,1);
                using HttpResponseMessage response = await client.PostAsync($"{_loggerURI}/appinsights/{severity[inx]}", content);
                if (!response.StatusCode.Equals(HttpStatusCode.OK))
                    return BadRequest(response.Content.ReadAsStringAsync().Result);
            }

            var okResponse = new HttpResponseMessage();
            okResponse.Content = JsonContent.Create($"{count} synthetic logs have been generated via AppInsights lib in Logger service.");
            return Ok(okResponse.Content.ReadAsStringAsync().Result);
        }

        [HttpGet("loggerservice/{count}/apm/appdynamics")]
        public async Task<ActionResult<string>> GetRandomExceptionsToLoggerAppDynamics(int count)
        {
            var okResponse = new HttpResponseMessage();
            okResponse.Content = JsonContent.Create($"This feature is not implemented yet!");
            return Ok(okResponse.Content.ReadAsStringAsync().Result);
        }

        [HttpGet("controller/apm/appinsights")]
        [AppInsightHandleException]
        
        public ActionResult GetRandomExceptionsToAppInsights()
        {
            List<ThrowErrorRequest>? exceptions = (new ExceptionServices(_datasetRepo)).GenerateRandomErrorList(15).Result;

            Random rnd = new();

            if (Extensions.IsNotNull(exceptions))
            {
                var inx = rnd.Next(exceptions.Count - 1);
                var ex = exceptions[inx];

                throw new Exception($"TYPE*{ex.Code}*CLASS*{ex.Class}*MESSAGE*{ex.Message}");
            }
            return Ok();
        }

        [HttpGet("controller/apm/appdynamics")]
        //[AppDynamicsHandleException]
        [NotImplExceptionFilter]
        public ActionResult GetRandomExceptionsToAppDynamics()
        {
            throw new NotImplementedException("This feature is not implemented");
        }

        [HttpGet("logfiles")]
        public async Task<FileObject[]> GetLogFiles()
        {
            // call Logger service to log exceptions
            using HttpClient client = new();
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/text"));
            client.DefaultRequestHeaders.Add("User-Agent", "Synthetic Exception Generator");

            var request = await client.GetAsync($"{_loggerURI}/logfiles");
            var result = request.Content.ReadAsStringAsync().Result;
            var jarray = JArray.Parse(result);

            var response = new List<FileObject>();
            foreach (var entry in jarray)
                response.Add(new FileObject { Name = entry.ToString().Split('\\')[entry.ToString().Split('\\').Length - 1], Path = $"file://{entry}" });
            return response.ToArray<FileObject>();
        }

        [HttpGet("logfilecontent/{filename}")]
        public async Task<string[]> GetLogFileContent(string filename)
        {
            // call Logger service to log exceptions
            using HttpClient client = new();
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/text"));
            client.DefaultRequestHeaders.Add("User-Agent", "Synthetic Exception Generator");

            var request = await client.GetAsync($"{_loggerURI}/logfilecontent/{filename}");
            var result = request.Content.ReadAsStringAsync().Result;
            var response = result.Replace('\n', ' ').Split('\r');
            Array.Reverse(response, 0, response.Length);

            return response;
        }

        public class FileObject
        {
            public string Name { get; set; }
            public string Path { get; set; }
        }

        
    }
}
