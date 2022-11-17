using Microsoft.ApplicationInsights.DataContracts;
using System;
using System.IO;
using System.Linq;

namespace LoggerApiDemo.Utilities
{
    public static class RandomizedData
    {
        public static string TraceMessage()
        {
            // pick up randomy a message out of messages.txt file
            var messages = File.ReadAllText("Utilities\\messages.txt").Split('.').ToArray();

            var rnd = new Random();
            return messages[rnd.Next(0, messages.Length - 1)];
        }

        public static SeverityLevel SeverityLevel()
        {
            // pick up randomly a severity level out of: Verbose,Information,Warning,Error,Critical
            var rnd = new Random();
            var selected = (SeverityLevel)rnd.Next(1, 5);
            return selected;
        }
    }
}
