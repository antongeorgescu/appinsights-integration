using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using NLog;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;
using LoggerApiDemo.Utilities;

namespace LoggerApiDemo
{
    public class Startup
    {
        public static CosmosClient cosClient = null;

        public static List<string> LogDataSinkList = null;


        public Startup(IConfiguration configuration)
        {
            LogManager.LoadConfiguration(String.Concat(Directory.GetCurrentDirectory(), "/nlog.config"));

            // New instance of CosmosClient class
            cosClient = new(
                accountEndpoint: configuration.GetSection("AzureCosmosDb:URI").Value,
                authKeyOrResourceToken: configuration.GetSection("AzureCosmosDb:PrimaryKey").Value
            );

            // get the data sinks active (are 'ON') 
            LogDataSinkList = new List<string>();
            foreach (var sink in configuration.GetSection("LogDataSink").GetChildren())
                if (sink.Value == "ON")
                    LogDataSinkList.Add(sink.Key);
            
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.ConfigureLoggerService();
            services.AddSite24x7ApmInsights();
            services.AddControllers();

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
