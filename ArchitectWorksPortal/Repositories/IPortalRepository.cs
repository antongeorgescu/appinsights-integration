using ArchitectWorksPortal.Models;
namespace ArchitectWorksPortal.Repositories
{
    public interface IPortalRepository
    {
        Task<IEnumerable<Workitem>> GetWorkitems();
    }
}
