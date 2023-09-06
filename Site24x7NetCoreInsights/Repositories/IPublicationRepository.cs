using NetCoreApmInsights.Models;
namespace NetCoreApmInsights.Repositories
{
    public interface IPublicationRepository
    {
        Task<IEnumerable<Publication>> GetBooksList();
        Task<IEnumerable<Publication>> GetFilteredBooksList(string nameContains, string titleContains);
    }
}
