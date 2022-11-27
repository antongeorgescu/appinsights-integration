using ArchitectWorksPortal.Models;
using Microsoft.EntityFrameworkCore;

namespace ArchitectWorksPortal.DAL
{
    public class SynthDataContext : DbContext
    {

        public SynthDataContext(DbContextOptions<SynthDataContext> options) : base(options)
        {
        }

        public DbSet<ContentType> ContentType { get; set; }
        public DbSet<Models.Dataset> Datasets { get; set; }
        
        //protected override void OnModelCreating(DbModelBuilder modelBuilder)
        //{
        //    modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        //}

    }
}
