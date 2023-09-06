using Microsoft.Data.SqlClient;
using System.Data;

namespace NetCoreApmInsights.DAL
{
    public class DapperContext
    {
        private readonly IConfiguration _configuration;
        private readonly string _connectionString;
        private readonly string _databaseName;
        public DapperContext(IConfiguration configuration)
        {
            _configuration = configuration;
            _connectionString = _configuration.GetConnectionString("ArchitectWorksDbConnection");
            _databaseName = _connectionString.Split(';')[1].Split('=')[1];
        }
        public IDbConnection CreateConnection() => new SqlConnection(_connectionString);

        public string DatabaseName { get { return _databaseName; } }
    }
}
