using System.Collections.Generic;
using System;
using Microsoft.Extensions.Logging;

namespace LoggerApiDemo.ILoggerClasses.AppInsights
{
    public class AppInsightsLoggerConfiguration
    {
        public int EventId { get; set; }

        public virtual string ConnectionString { get; set; }
    }
}
