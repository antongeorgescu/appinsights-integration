using LoggerApiDemo.Utilities;
using System;
using System.Security.Cryptography;
using System.Text;

namespace LoggerApiDemo.Interfaces
{
    public interface ILoggerEntry
    {
        DateTime CreateDate { get; set; }
        string Type { get; set; }
        string Class { get; set; }
        string? Description { get; set; }
        string Message { get; set; }
        string HashKey { get; }
        bool IsIdenticalLog(ILoggerEntry otherlog);
    }
}
