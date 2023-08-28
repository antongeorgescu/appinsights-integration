using Dapper;
using NetCoreApmInsights.Models;
using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddSite24x7ApmInsights();

var app = builder.Build();

// Configure the HTTP request pipeline.

app.MapGet("/health", () =>
{
    return $"[{DateTime.Now}] Site24x7ApmInsights service running...";
});

app.MapGet("/health/dbschema", (IConfiguration config) =>
{
    List<SchemaInfo> dbdatetimeinfo = null;
    var connectionString = config.GetConnectionString("ArchitectWorksDbConnection");
    // Connect to the database 
    using (var connection = new SqlConnection(connectionString))
    {
        // Create a query that retrieves all books with an author name of "John Smith"    
        var sql = "select schema_name(t.schema_id) as schemaname,t.name as tablename,t.create_date as createdate,t.modify_date as modifydate ";
        sql += "from sys.tables t ";
        sql += "where schema_name(t.schema_id) = 'dbo' ";
        sql += "order by tablename";

        // Use the Query method to execute the query and return a list of objects    
        dbdatetimeinfo = connection.Query<SchemaInfo>(sql).ToList();
    }
    return dbdatetimeinfo;
});

app.MapGet("/health/pubs/byauthor", (string likestr, IConfiguration config) =>
{
    List<Publication> publications = new List<Publication>();
    try
    {
        var connectionString = config.GetConnectionString("ArchitectWorksDbConnection");
        // Connect to the database 
        using (var connection = new SqlConnection(connectionString))
        {
            // Create a query that retrieves all books with an author name of "John Smith"    
            var sql = "SELECT au.au_id, CONCAT(au.au_fname, ' ', au.au_lname) AS \"author\",au.city,au.state,ti.title,ti.type ";
            sql += "FROM[ArchitectWorks].[dbo].[authors] au ";
            sql += "INNER JOIN[ArchitectWorks].[dbo].[titleauthor] tiau ON tiau.au_id = au.au_id ";
            sql += "INNER JOIN[ArchitectWorks].[dbo].[titles] ti ON tiau.title_id = ti.title_id ";
            sql += $"WHERE au.au_lname LIKE '%{likestr}%'";

            // Use the Query method to execute the query and return a list of objects    
            publications = connection.Query<Publication>(sql).ToList();
        }
        return publications;
    }
    catch(Exception ex)
    {
        return publications;
    }
});

app.MapGet("/health/pubs/bytitle", (string likestr, IConfiguration config) =>
{
    // database query pointer for Site24x7 Nert Core APMInsights agent 
    var sqlpointer0 = "SELECT au.au_id,au.au_fname,au.au_lname,au.city,au.state FROM[ArchitectWorks].[dbo].[authors] au";
    var sqlpointer1 = "SELECT ti.title,ti.type FROM[ArchitectWorks].[dbo].[titles] ti";

    List<Publication> publications = new List<Publication>();
    try
    {
        var connectionString = config.GetConnectionString("ArchitectWorksDbConnection");
        // Connect to the database 
        using (var connection = new SqlConnection(connectionString))
        {
            // Create a query that retrieves all books with an author name of "John Smith"    
            var sql = "SELECT au.au_id, CONCAT(au.au_fname, ' ', au.au_lname) AS \"author\",au.city,au.state,ti.title,ti.type ";
            sql += "FROM[ArchitectWorks].[dbo].[authors] au ";
            sql += "INNER JOIN[ArchitectWorks].[dbo].[titleauthor] tiau ON tiau.au_id = au.au_id ";
            sql += "INNER JOIN[ArchitectWorks].[dbo].[titles] ti ON tiau.title_id = ti.title_id ";
            sql += $"WHERE ti.title LIKE '%{likestr}%'";

            // Use the Query method to execute the query and return a list of objects    
            publications = connection.Query<Publication>(sql).ToList();
        }
        return publications;
    }
    catch (Exception ex)
    {
        return publications;
    }
});

app.Run();



