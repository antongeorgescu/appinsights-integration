using LoggerApiDemo.Classes;
using LoggerApiDemo.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace LoggerApiDemo.Utilities
{
    public static class ServiceExtensions
    {
        public static void ConfigureLoggerService(this IServiceCollection services)
        {
            services.AddSingleton<ILoggerService, LoggerService>();
        }
    }
}