using System.Diagnostics;

namespace ArchitectWorksPortal.Models
{
    public class Dataset
    {
        public int DatasetID { get; set; }
        public short ContentTypeId { get; set; }
        public string ContentText { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public DateTime LastUpdated { get; set; }
    }
}
