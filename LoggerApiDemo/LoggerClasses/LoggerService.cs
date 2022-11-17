using LoggerApiDemo.Interfaces;
using Microsoft.Azure.Cosmos;
using NLog;
using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Security.Policy;
using System.Threading.Tasks;
using Container = Microsoft.Azure.Cosmos.Container;

namespace LoggerApiDemo.LoggerClasses
{
    public class LoggerService : ILoggerService
    {
        private static ILogger logger = LogManager.GetCurrentClassLogger();
        public async Task<Tuple<bool, string>> LogDebug(string message)
        {
            var response = await SaveLogEntry(message, "Debug");
            return response;
        }
        public async Task<Tuple<bool, string>> LogError(string message)
        {
            var response = await SaveLogEntry(message, "Error");
            return response;
        }
        public async Task<Tuple<bool, string>> LogInfo(string message)
        {
            var response = await SaveLogEntry(message, "Info");
            return response;
        }
        public async Task<Tuple<bool, string>> LogWarn(string message)
        {
            var response = await SaveLogEntry(message, "Warning");
            return response;
        }

        private async Task<Tuple<bool, string>> SaveLogEntry(string message, string logType)
        {
            try
            {
                if (Startup.LogDataSinkList.Contains("File"))
                    SaveToLogFile(message, logType);
                else if (Startup.LogDataSinkList.Contains("CosmosDb"))
                    await SaveToCosmosDb(message, logType);
                else if (Startup.LogDataSinkList.Contains("AzureMonitor"))
                    await SaveToAzureMonitor(message, logType);

                return new Tuple<bool, string>(true, string.Empty);
            }
            catch (Exception ex)
            {
                return new Tuple<bool, string>(true, ex.Message);
            }
        }

        private async Task<bool> SaveToCosmosDb(string message, string logType)
        {
            Database cosDb = Startup.cosClient.GetDatabase("alvaz-poc-logdb");
            Container container = cosDb.GetContainer("OnpremLogs");
            var logMsg = new LoggerEntry()
            {
                CreateDate = new DateTime(),
                Type = logType,
                Class = message.Split('|')[0].Split(':')[1],
                Description = message.Split('|')[1].Split(':')[1]
            };
            LoggerEntry createdItem = await container.CreateItemAsync(
                item: logMsg
            );
            if (createdItem != null)
                return true;
            else
                return false;
        }

        private async Task<bool> SaveToAzureMonitor(string message, string logType)
        {
            // TODO
            return true;
        }

        private bool SaveToLogFile(string message, string logType)
        {
            if (logType == "Debug")
                logger.Debug(message);
            else if (logType == "Error")
                logger.Error(message);
            else if (logType == "Info")
                logger.Info(message);
            else if (logType == "Warning")
                logger.Warn(message);
            return true;
        }
    }


}
