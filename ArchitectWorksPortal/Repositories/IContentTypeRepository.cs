using ArchitectWorksPortal.Models;

namespace ArchitectWorksPortal.Repositories
{
    public interface IContentTypeRepository
    {
        Task<IEnumerable<ContentType>> GetContentTypes();
        Task<ContentType> GetContentType(int? id);
    }
}
