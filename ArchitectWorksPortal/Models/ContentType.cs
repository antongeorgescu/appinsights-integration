using System.ComponentModel.DataAnnotations;

namespace ArchitectWorksPortal.Models
{
    public enum Code
    {
        Message, BlobWord, BlobJpg
    }

    public class ContentType
    {
        public short ContentTypeID { get; set; }
        public Code? Code { get; set; }
        
        public string Name { get; set; }
        public string Description { get; set; }
    }
}
