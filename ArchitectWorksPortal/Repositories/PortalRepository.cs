using ArchitectWorksPortal.DAL;
using Dapper;
using System.Data;
using ArchitectWorksPortal.Models;

namespace ArchitectWorksPortal.Repositories
{
    public class PortalRepository : IPortalRepository
    {
        private readonly DapperContext context;

        public PortalRepository(DapperContext context)
        {
            this.context = context;
        }

        public async Task<IEnumerable<Workitem>> GetWorkitems()
        {
            var query = $"SELECT wt.Name as [Type],wi.[Title],wi.[Description],wi.[Notes] " +
                $"FROM [{context.DatabaseName}].[dbo].[WorkItem] as wi " +
                $"JOIN [{context.DatabaseName}].[dbo].[WorkType] as wt ON wi.TypeID = wt.TypeID";

            using (var connection = context.CreateConnection())
            {
                var workitems = await connection.QueryAsync<Workitem>(query);
                return workitems.ToList();
            }
        }
    }
}
