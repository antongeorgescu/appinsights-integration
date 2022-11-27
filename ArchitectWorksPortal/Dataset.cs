using System;
using System.Collections.Generic;

namespace ArchitectWorksPortal;

public partial class Dataset
{
    public int DatasetId { get; set; }

    public short ContentTypeId { get; set; }

    public string? ContentVarMax { get; set; }

    public string? ContentText { get; set; }

    public byte[]? ContentImage { get; set; }

    public virtual ContentType ContentType { get; set; } = null!;
}
