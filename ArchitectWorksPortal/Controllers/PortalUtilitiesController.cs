using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace AngularSpaWebApi.Controllers
{
    [Route("[controller]")]
    [ApiController]
    public class PortalUtilitiesController : ControllerBase
    {
        // GET: api/<PortalUtilitiesController>
        [HttpGet("applications")]
        public IEnumerable<ApplicationInfo> Get()
        {
            var apps = new List<ApplicationInfo>();

            using (StreamReader r = new StreamReader("Data/works.json"))
            {
                string json = r.ReadToEnd();
                List<ApplicationInfo>? works = JsonConvert.DeserializeObject<List<ApplicationInfo>>(json);
                foreach (var work in works)
                    apps.Add(new ApplicationInfo()
                    {
                        Type = work.Type,
                        Title = work.Title,
                        Description = work.Description,
                        Notes = work.Notes
                    });

            }
            return apps;
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
