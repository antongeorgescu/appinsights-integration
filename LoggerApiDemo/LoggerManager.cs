using Microsoft.Azure.Cosmos;
using NLog;
using System.ComponentModel;
using Container = Microsoft.Azure.Cosmos.Container;

namespace LoggerApiDemo.Services
{
    public class LoggerManager : ILoggerManager
    {
        private static ILogger logger = LogManager.GetCurrentClassLogger();
        public async void LogDebug(string message){
            if (Startup.LogDataSinkList.Contains("File"))
                logger.Debug(message);
            else if (Startup.LogDataSinkList.Contains("CosmosDb"))
            {
                Database cosDb = Startup.cosClient.GetDatabase("alvaz-poc-logdb");
                Container container = cosDb.GetContainer("OnpremLogs");
                var logMsg = new LoggerMessage()
                {
                    Class = message.Split('|')[0].Split(':')[1],
                    Description = message.Split('|')[1].Split(':')[1]
                };
                LoggerMessage createdItem = await container.CreateItemAsync<LoggerMessage>(
                    item: logMsg
                );

            }


        }
        public void LogError(string message) => logger.Error(message);
        public void LogInfo(string message) => logger.Info(message);
        public void LogWarn(string message) => logger.Warn(message);
    }


}
