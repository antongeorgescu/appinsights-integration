using System;

namespace LoggerApiDemo
{
    public class LoggerEntry
    {
        public DateTime CreateDate { get; set; }
        public string Type { get; set; }
        public string Class { get; set; }
        public string Description { get; set; }
    }
}
