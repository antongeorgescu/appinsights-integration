using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace ArchitectWorksPortal;

public partial class SyntheticDataContext : DbContext
{
    public SyntheticDataContext()
    {
    }

    public SyntheticDataContext(DbContextOptions<SyntheticDataContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ContentType> ContentTypes { get; set; }

    public virtual DbSet<Dataset> Datasets { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Data Source=STDLHVY5K13\\SQLEXPRESS;Initial Catalog=SyntheticData;Trusted_Connection=SSPI;Encrypt=false;TrustServerCertificate=true");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ContentType>(entity =>
        {
            entity.ToTable("ContentType");

            entity.Property(e => e.ContentTypeId)
                .ValueGeneratedNever()
                .HasColumnName("ContentTypeID");
            entity.Property(e => e.Code)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Description)
                .HasMaxLength(300)
                .IsUnicode(false);
            entity.Property(e => e.Name)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<Dataset>(entity =>
        {
            entity.ToTable("Dataset");

            entity.Property(e => e.DatasetId)
                .ValueGeneratedNever()
                .HasColumnName("DatasetID");
            entity.Property(e => e.ContentImage).HasColumnType("image");
            entity.Property(e => e.ContentText).HasColumnType("text");
            entity.Property(e => e.ContentTypeId).HasColumnName("ContentTypeID");
            entity.Property(e => e.ContentVarMax).IsUnicode(false);

            entity.HasOne(d => d.ContentType).WithMany(p => p.Datasets)
                .HasForeignKey(d => d.ContentTypeId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_Dataset_ContentType");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
