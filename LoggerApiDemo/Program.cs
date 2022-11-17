using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using NLog;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.DependencyInjection;
using LogLevel = Microsoft.Extensions.Logging.LogLevel;
using LoggerApiDemo.ILoggerClasses.ColorConsole;
using LoggerApiDemo.ILoggerClasses.LogFiles;
using LoggerApiDemo.ILoggerClasses.AppInsights;
using System.Configuration;

namespace LoggerApiDemo
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }

        public static IHostBuilder CreateHostBuilder(string[] args) {
            
            var builder = Host.CreateDefaultBuilder(args);
            var hostBuilder = builder.ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                })
                .ConfigureLogging((hostBuilderContext, logbuilder) =>
                {
                    logbuilder.ClearProviders();
                    logbuilder.AddConsole();
                    logbuilder.AddColorConsoleLogger(configuration =>
                    {
                        // Replace warning value from appsettings.json of "Cyan"
                        configuration.LogLevelToColorMap[LogLevel.Warning] = ConsoleColor.DarkCyan;
                        // Replace warning value from appsettings.json of "Red"
                        configuration.LogLevelToColorMap[LogLevel.Error] = ConsoleColor.DarkRed;
                    });
                    logbuilder.AddFileLogger(configuration =>
                    {
                        // Replace warning value from appsettings.json of "Cyan"
                        configuration.FilePath = hostBuilderContext.Configuration.GetSection($"Logging:ILoggerFileTarget:Options:FilePath").Value;
                        // Replace warning value from appsettings.json of "Red"
                        configuration.FolderPath = hostBuilderContext.Configuration.GetSection($"Logging:ILoggerFileTarget:Options:FolderPath").Value;
                    });
                    logbuilder.AddAppInsightsLogger(configuration =>
                    {
                        // read connection string for AppInsights
                        configuration.ConnectionString = hostBuilderContext.Configuration.GetSection($"Logging:ApplicationInsights:Options:ConnectionString").Value;
                    });
                });
            return hostBuilder;
        }
    }
}
