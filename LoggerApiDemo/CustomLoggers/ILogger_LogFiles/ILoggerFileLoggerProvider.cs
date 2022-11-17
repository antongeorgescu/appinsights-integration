using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.IO;

namespace LoggerApiDemo.ILoggerClasses.LogFiles
{
    [ProviderAlias("FileILoggerProvider")]
    public class ILoggerFileLoggerProvider : ILoggerProvider
    {
        public readonly ILoggerFileLoggerConfiguration Options;

        public ILoggerFileLoggerProvider(IOptions<ILoggerFileLoggerConfiguration> _options)
        {
            Options = _options.Value;

            if (!Directory.Exists(Options.FolderPath))
            {
                Directory.CreateDirectory(Options.FolderPath);
            }
        }

        public ILogger CreateLogger(string categoryName)
        {
            return new ILoggerFileLogger(this);
        }

        public void Dispose()
        {
        }
    }
}
