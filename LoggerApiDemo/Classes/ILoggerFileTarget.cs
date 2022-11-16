namespace LoggerApiDemo.Classes
{
    public class ILoggerFileTarget
    {
        public virtual string FilePath { get; set; }
        public virtual string FolderPath { get; set; }
    }
}
