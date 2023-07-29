using ArchitectWorksPortal.DAL;
using Dapper;
using System.Data;
using ArchitectWorksPortal.Models;

namespace ArchitectWorksPortal.Repositories
{
    public class PublicationRepository : IPublicationRepository
    {
        private readonly DapperContext context;

        public PublicationRepository(DapperContext context)
        {
            this.context = context;
        }

        public async Task<IEnumerable<Publication>> GetBooksList()
        {
            // SQL Query
            var query = "select concat(au.au_fname,' ',au.au_lname) as [author],au.city,au.state,t.title,t.type " +
                        "from(([dbo].authors au inner join[dbo].titleauthor tau on au.au_id = tau.au_id) " +
                        "inner join[dbo].titles t on t.title_id = tau.title_id)";

            using (var connection = context.CreateConnection())
            {
                var publications = await connection.QueryAsync<Publication>(query);
                return publications.ToList();
            }
        }

        public async Task<IEnumerable<Publication>> GetFilteredBooksList(string nameContains,string titleContains)
        {
            string query = "";
            if ((nameContains == "^=^") & (titleContains == "^=^"))
                query = "select concat(au.au_fname,' ',au.au_lname) as [author],au.city,au.state,t.title,t.type " +
                        "from(([dbo].authors au inner join[dbo].titleauthor tau on au.au_id = tau.au_id) " +
                        "inner join[dbo].titles t on t.title_id = tau.title_id)";
            else if (titleContains == "^=^")
                query = "select concat(au.au_fname,' ',au.au_lname) as [author],au.city,au.state,t.title,t.type " +
                        "from(([dbo].authors au inner join[dbo].titleauthor tau on au.au_id = tau.au_id) " +
                        "inner join[dbo].titles t on t.title_id = tau.title_id) " +
                        $"where concat(au.au_fname,' ',au.au_lname) like '%{nameContains}%'";
            else if (nameContains == "^=^")
                query = "select concat(au.au_fname,' ',au.au_lname) as [author],au.city,au.state,t.title,t.type " +
                        "from(([dbo].authors au inner join[dbo].titleauthor tau on au.au_id = tau.au_id) " +
                        "inner join[dbo].titles t on t.title_id = tau.title_id) " +
                        $"where t.title like '%{titleContains}%'";
            else
                query = "select concat(au.au_fname,' ',au.au_lname) as [author],au.city,au.state,t.title,t.type " +
                        "from(([dbo].authors au inner join[dbo].titleauthor tau on au.au_id = tau.au_id) " +
                        "inner join[dbo].titles t on t.title_id = tau.title_id) " +
                        $"where  concat(au.au_fname,' ',au.au_lname) like '%{nameContains}%' and t.title like '%{titleContains}%'";

            using (var connection = context.CreateConnection())
            {
                var publications = await connection.QueryAsync<Publication>(query);
                return publications.ToList();
            }
        }
    }
}
