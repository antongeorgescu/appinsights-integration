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
using LoggerApiDemo.Services;
using Microsoft.Azure.Cosmos;

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
                accountEndpoint: configuration.GetSection("AzureCosmosDb:URI").GetChildren().Select(x => x.Value).ToList()[0],
                authKeyOrResourceToken: configuration.GetSection("AzureCosmosDb:PrimaryKey").GetChildren().Select(x => x.Value).ToList()[0]
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
