using Microsoft.Extensions.DependencyInjection;

namespace LoggerApiDemo.Services
{
    public static class ServiceExtensions
    {

        public static void ConfigureLoggerService(this IServiceCollection services)
        {
            services.AddSingleton<ILoggerManager, LoggerManager>();
        }
    }
}