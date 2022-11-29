using ArchitectWorksPortal.Models;
using ArchitectWorksPortal.Repositories;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;

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

        // GET: api/<PortalUtilitiesController>
        [HttpGet("applications")]
        public async Task<IEnumerable<Workitem>> GetApps()
        {
            //var apps = new List<Workitem>();
            //using (StreamReader r = new StreamReader("Data/works.json"))
            //{
            //    string json = r.ReadToEnd();
            //    List<ApplicationInfo>? works = JsonConvert.DeserializeObject<List<ApplicationInfo>>(json);
            //    foreach (var work in works)
            //        apps.Add(new ApplicationInfo()
            //        {
            //            Type = work.Type,
            //            Title = work.Title,
            //            Description = work.Description,
            //            Notes = work.Notes
            //        });

            //}
            var apps = await _portalRepo.GetWorkitems();
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
