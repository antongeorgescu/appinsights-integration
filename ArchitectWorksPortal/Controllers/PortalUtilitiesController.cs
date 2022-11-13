using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace AngularSpaWebApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class PortalUtilitiesController : ControllerBase
    {
        // GET: api/<PortalUtilitiesController>
        [HttpGet]
        public IEnumerable<ApplicationInfo> Get()
        {
            var apps = new List<ApplicationInfo>();
            apps.Add(new ApplicationInfo()
            {
                Type = "POC",
                Title = ".NET Logger integration with APM",
                Description = ".NET Nlog Logger integration with Application Performance Monitoring (APM)",
                Notes = "Scope confined to Azure Monitor, Cosmos Db, and App Dynamics"
            });
            apps.Add(new ApplicationInfo()
            {
                Type = "Hackathon Submission",
                Title = "Resume Automatic Parser (RAP)",
                Description = "Machine Learning powered Python service that parses a resume for high correlation with desired skills.",
                Notes = ""
            });
            return apps;
        }

        // GET api/<PortalUtilitiesController>/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            return "value";
        }

        // POST api/<PortalUtilitiesController>
        [HttpPost]
        public void Post([FromBody] string value)
        {
        }

        // PUT api/<PortalUtilitiesController>/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody] string value)
        {
        }

        // DELETE api/<PortalUtilitiesController>/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
