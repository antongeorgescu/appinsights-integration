using Dapper;
using Microsoft.Data.SqlClient;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

var app = builder.Build();

// Configure the HTTP request pipeline.

app.MapGet("/", () =>
{
    return $"[{DateTime.Now}] SearchPublications service running...";
});

app.MapGet("/health", () =>
{
    return $"[{DateTime.Now}] SearchPublications service is healthy...";
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

app.MapGet("/pubs", (IConfiguration config) =>
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

app.MapGet("/pubs/byauthor", (string likestr, IConfiguration config) =>
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
    catch (Exception ex)
    {
        return publications;
    }
});

app.MapGet("/pubs/bytitle", (string likestr, IConfiguration config) =>
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

app.MapGet("/pubs/bycity", (string likestr, IConfiguration config) =>
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
            sql += $"WHERE au.city LIKE '%{likestr}%'";

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

app.MapGet("/pubs/bystate", (string likestr, IConfiguration config) =>
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
            sql += $"WHERE au.state LIKE '%{likestr}%'";

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

app.MapGet("/author/withcontract", (IConfiguration config) =>
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
            sql += $"WHERE au.contract == 1";

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

public class Publication
{
    public string? Author { get; set; }

    public string? City { get; set; }

    public string? State { get; set; }

    public string? Title { get; set; }
    public string? Type { get; set; }
}

public class SchemaInfo
{
    public string? SchemaName { get; set; }

    public string? TableName { get; set; }

    public string? CreateDate { get; set; }

    public string? ModifyDate { get; set; }

}