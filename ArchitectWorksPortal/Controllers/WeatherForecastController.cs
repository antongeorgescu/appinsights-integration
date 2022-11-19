using AngularSpaWebApi.Classes;
using Microsoft.AspNetCore.Mvc;

namespace AngularSpaWebApi.Controllers;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries = new[]
    {
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    };

    private readonly ILogger<WeatherForecastController> _logger;

    public WeatherForecastController(ILogger<WeatherForecastController> logger)
    {
        _logger = logger;
    }

    [HttpGet]
    public IEnumerable<WeatherForecast> Get()
    {
        return Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateTime.Now.AddDays(index),
            TemperatureC = Random.Shared.Next(-20, 55),
            Summary = Summaries[Random.Shared.Next(Summaries.Length)]
        })
        .ToArray();
    }

    [HttpGet("appinfo")]
    public IEnumerable<ApplicationInfo> GetAppInfo()
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
}
