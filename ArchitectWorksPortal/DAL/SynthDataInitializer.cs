using ArchitectWorksPortal.Models;
using System.Diagnostics;
using System.Data;

namespace ArchitectWorksPortal.DAL
{
    public class SynthDataInitializer : System.Data.Entity.DropCreateDatabaseIfModelChanges<SynthDataContext>
    {
        protected override void Seed(SynthDataContext context)
        {
            var contentTypes = new List<ContentType>
            {
                new ContentType() {
                    ContentTypeID=1, 
                    Code=Code.Message, 
                    Name="Message", 
                    Description="Collection of text messages.." },
                new ContentType() {
                    ContentTypeID=2, 
                    Code=Code.BlobWord, 
                    Name="Blob.Word", 
                    Description="Collection of Word documents with random content." },
                new ContentType() {
                    ContentTypeID=3, 
                    Code=Code.BlobJpg, 
                    Name="Blob.JPG", 
                    Description="Collection of JPG/JPEG images with various contents." }
            };

            contentTypes.ForEach(cty => context.ContentType.Add(cty));
            context.SaveChanges();
            
            var datasets = new List<SynthDataset>
            {
                new SynthDataset() {
                    DatasetID=1, 
                    ContentTypeId=1, 
                    Name="IpsumLorem Messages", 
                    Description = "Collection of 50 generated statements with Ipsum Lorem word generator.", 
                    Content="<to implement>" }
            };
            datasets.ForEach(ds => context.Datasets.Add(ds));
            context.SaveChanges();
        }
    }
}
