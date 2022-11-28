using ArchitectWorksPortal.DAL;
using Dapper;
using System.Data;
using ArchitectWorksPortal.Models;

namespace ArchitectWorksPortal.Repositories
{
    public class DatasetRepository : IDatasetRepository
    {
        private readonly DapperContext context;

        public DatasetRepository(DapperContext context)
        {
            this.context = context;
        }

        public async Task<IEnumerable<Dataset>> GetDatasets()
        {
            var query = "SELECT * FROM Dataset";

            using (var connection = context.CreateConnection())
            {
                var datasets = await connection.QueryAsync<Dataset>(query);
                return datasets.ToList();
            }
        }

        public async Task<Dataset> GetDataset(int? id)
        {
            var query = "SELECT * FROM Dataset WHERE DatasetID = @Id";

            using (var connection = context.CreateConnection())
            {
                var dataset = await connection.QuerySingleOrDefaultAsync<Dataset>(query, new { id });
                return dataset;
            }
        }
        public async Task CreateDataset(Dataset dataset, int contentTypeId)
        {
            var query = "INSERT INTO Dataset (ContentTypeID, Name, ContentText, Description) VALUES (@ContentTypeID, @Name, @ContentText, @Description)";

            var parameters = new DynamicParameters();
            parameters.Add("ContentTypeID", contentTypeId, DbType.Int16);
            parameters.Add("Name", dataset.Name, DbType.String);
            parameters.Add("ContentText", dataset.ContentText, DbType.String);
            parameters.Add("Description", dataset.Description, DbType.Int32);

            using (var connection = context.CreateConnection())
            {
                await connection.ExecuteAsync(query, parameters);
            }
        }

        public async Task UpdateDataset(int id, Dataset dataset)
        {
            var query = "UPDATE Dataset SET Name=@Name, ContentText=@ContentText, Description=@Description WHERE DatasetID = @Id";

            var parameters = new DynamicParameters();
            parameters.Add("Id", dataset.DatasetID, DbType.Int32);
            parameters.Add("Name", dataset.Name, DbType.String);
            parameters.Add("ContentText", dataset.ContentText, DbType.String);
            parameters.Add("Description", dataset.Description, DbType.String);
            
            using (var connection = context.CreateConnection())
            {
                await connection.ExecuteAsync(query, parameters);
            }
        }
        public async Task DeleteDataset(int id)
        {
            var query = "DELETE FROM Dataset WHERE DatasetID = @Id";
            using (var connection = context.CreateConnection())
            {
                await connection.ExecuteAsync(query, new { id });
            }
        }
    }
}
