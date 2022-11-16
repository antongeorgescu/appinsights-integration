using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.IO;

namespace LoggerApiDemo.Classes
{
    [ProviderAlias("FileILoggerProvider")]
    public class ILoggerFileLoggerProvider : ILoggerProvider
    {
        public readonly ILoggerFileTarget Options;

        public ILoggerFileLoggerProvider(IOptions<ILoggerFileTarget> _options)
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
