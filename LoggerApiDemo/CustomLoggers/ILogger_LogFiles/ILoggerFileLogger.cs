using Microsoft.Extensions.Logging;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System;

namespace LoggerApiDemo.ILoggerClasses.LogFiles
{
    public class ILoggerFileLogger : ILogger
    {
        protected readonly ILoggerFileLoggerProvider _iLoggerFileLoggerProvider;

        public ILoggerFileLogger([NotNull] ILoggerFileLoggerProvider iLoggerFileLoggerProvider)
        {
            _iLoggerFileLoggerProvider = iLoggerFileLoggerProvider;
        }

        public IDisposable BeginScope<TState>(TState state)
        {
            return null;
        }

        public bool IsEnabled(LogLevel logLevel)
        {
            return logLevel != LogLevel.None;
        }

        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
        {
            if (!IsEnabled(logLevel))
            {
                return;
            }

            var fullFilePath = _iLoggerFileLoggerProvider.Options.FolderPath + "/" + _iLoggerFileLoggerProvider.Options.FilePath.Replace("{date}", DateTimeOffset.UtcNow.ToString("yyyyMMdd"));
            var logRecord = string.Format("[{0}] [{1}] *EVENT/ID*{2} {3} {4}", DateTimeOffset.UtcNow.ToString("yyyy-MM-dd HH:mm:ss+00:00"), logLevel.ToString(), eventId.Name, formatter(state, exception), exception != null ? exception.StackTrace : "");

            using (var streamWriter = new StreamWriter(fullFilePath, true))
            {
                streamWriter.WriteLine(logRecord);
            }
        }
    }
}
