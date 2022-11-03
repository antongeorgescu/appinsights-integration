using System.IO;
using System;

namespace LoggerApiDemo.Utilities
{
    public static class ThisServer
    {
        public static string MapPath(string path)
        {
            return Path.Combine(
                (string)AppDomain.CurrentDomain.GetData("ContentRootPath"),
                path);
        }
    }
}
