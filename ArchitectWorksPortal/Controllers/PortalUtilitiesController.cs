using ArchitectWorksPortal.Models;
using ArchitectWorksPortal.Repositories;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using System.Linq;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace AngularSpaWebApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class PortalUtilitiesController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly IPortalRepository _portalRepo;

        public PortalUtilitiesController(IConfiguration configuration, IPortalRepository portalRepo)
        {
            _configuration = configuration;
            _portalRepo = portalRepo;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok($"PortalUtilities API started at {DateTime.Now}");
        }

        [HttpGet("applications/db")]
        public async Task<IEnumerable<Workitem>> GetApps()
        {
            var apps = await _portalRepo.GetWorkitems();
            return apps;
        }

        [HttpGet("applications/text")]
        public IEnumerable<Workitem> GetAppsText()
        {
            var apps = new List<Workitem>();
            using (StreamReader r = new ("Data/works.json"))
            {
                string json = r.ReadToEnd();
                List<Workitem>? works = JsonConvert.DeserializeObject<List<Workitem>>(json);
                apps.AddRange(from work in works
                              select new Workitem()
                              {
                                  Type = work.Type,
                                  Title = work.Title,
                                  Description = work.Description,
                                  Notes = work.Notes
                              });
            }
            return apps;
        }

        [HttpGet("redirectdocumentationappd")]
        public ActionResult GetDocumentation()
        {
            return Redirect("https://docs.appdynamics.com/");
        }
        
        [HttpGet("designdiagram/{pocname}")]
        public ActionResult<Uri> GetDiagram(string pocname)
        {
            Uri? diagramLink = null;
            switch (pocname)
            {
                case "loggerapm":
                    diagramLink = new Uri("/assets/images/Logger-with-APM-Provides-POC.jpg");
                    break;
            }
            return Ok(diagramLink);
        }

        [HttpGet("connection")]
        public IActionResult GetConnectionStatus()
        {
            return Ok(new { status = "Good", datetime = DateTime.Now.ToString() });
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
