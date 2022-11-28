using ArchitectWorksPortal.Models;
using Dapper;
using ArchitectWorksPortal.DAL;

namespace ArchitectWorksPortal.Repositories
{
    public class ContentTypeRepository : IContentTypeRepository
    {
        private readonly DapperContext context;

        public ContentTypeRepository(DapperContext context)
        {
            this.context = context;
        }

        public async Task<IEnumerable<ContentType>> GetContentTypes()
        {
            var query = "SELECT * FROM ContentType";

            using (var connection = context.CreateConnection())
            {
                var contentTypes = await connection.QueryAsync<ContentType>(query);
                return contentTypes.ToList();
            }
        }

        public async Task<ContentType> GetContentType(int? id)
        {
            var query = "SELECT * FROM Companies WHERE ContentTypeID = @Id";

            using (var connection = context.CreateConnection())
            {
                var contentType = await connection.QuerySingleOrDefaultAsync<ContentType>(query, new { id });
                return contentType;
            }
        }
        
    }
}
