using System;

namespace SyntheticExceptionApiDemo.Classes
{
    public class LoggerEntry
    {
        public DateTime CreateDate { get; set; }
        public string Type { get; set; }
        public string Class { get; set; }
        public string? Description { get; set; }
        public string Message { get; set; }
    }
}
