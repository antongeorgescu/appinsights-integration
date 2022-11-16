using LoggerApiDemo.Classes;
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
                .ConfigureLogging(logbuilder =>
                {
                    logbuilder.ClearProviders();
                    //logbuilder.AddConsole();
                    logbuilder.AddColorConsoleLogger(configuration =>
                    {
                        // Replace warning value from appsettings.json of "Cyan"
                        configuration.LogLevelToColorMap[LogLevel.Warning] = ConsoleColor.DarkCyan;
                        // Replace warning value from appsettings.json of "Red"
                        configuration.LogLevelToColorMap[LogLevel.Error] = ConsoleColor.DarkRed;
                    });
                });
            return hostBuilder;
        }
    }
}
