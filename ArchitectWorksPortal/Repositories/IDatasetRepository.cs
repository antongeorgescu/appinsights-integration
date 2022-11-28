using ArchitectWorksPortal.Models;
namespace ArchitectWorksPortal.Repositories
{
    public interface IDatasetRepository
    {
        Task<IEnumerable<Dataset>> GetDatasets();
        Task<Dataset> GetDataset(int? id);
        Task CreateDataset(Dataset dataset, int contentTypeId);
        Task UpdateDataset(int id, Dataset dataset);
        Task DeleteDataset(int id);
    }
}
