using System;
using System.Collections.Generic;

namespace ArchitectWorksPortal;

public partial class ContentType
{
    public short ContentTypeId { get; set; }

    public string Code { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public virtual ICollection<Dataset> Datasets { get; } = new List<Dataset>();
}
