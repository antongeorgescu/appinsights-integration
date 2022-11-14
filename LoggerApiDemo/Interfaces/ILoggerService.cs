using System;
using System.Threading.Tasks;

namespace LoggerApiDemo.Interfaces
{
    public interface ILoggerService
    {
        Task<Tuple<bool, string>> LogInfo(string message);
        Task<Tuple<bool, string>> LogWarn(string message);
        Task<Tuple<bool, string>> LogDebug(string message);
        Task<Tuple<bool, string>> LogError(string message);
    }
}
