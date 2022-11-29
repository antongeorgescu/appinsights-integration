using AngularSpaWebApi.Classes;
using ArchitectWorksPortal.Models;
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

    [HttpGet("connection")]
    public IActionResult GetConnectionStatus()
    {
        return Ok(new { status = "Good", datetime = DateTime.Now.ToString() });
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
    public IEnumerable<Workitem> GetAppInfo()
    {
        var apps = new List<Workitem>();
        apps.Add(new Workitem()
        {
            Type = "POC",
            Title = ".NET Logger integration with APM",
            Description = ".NET Nlog Logger integration with Application Performance Monitoring (APM)",
            Notes = "Scope confined to Azure Monitor, Cosmos Db, and App Dynamics"
        });
        apps.Add(new Workitem()
        {
            Type = "Hackathon Submission",
            Title = "Resume Automatic Parser (RAP)",
            Description = "Machine Learning powered Python service that parses a resume for high correlation with desired skills.",
            Notes = ""
        });
        return apps;
    }
}
