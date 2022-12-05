using ArchitectWorksPortal.Models;
using Dapper;
using ArchitectWorksPortal.DAL;
using Microsoft.ApplicationInsights.DataContracts;
using Microsoft.ApplicationInsights;

namespace ArchitectWorksPortal.Repositories
{
    public class ContentTypeRepository : IContentTypeRepository
    {
        private readonly DapperContext context;
        private readonly TelemetryClient appInsClient;

        [Obsolete]
        public ContentTypeRepository(DapperContext context)
        {
            this.context = context;
            this.appInsClient = new TelemetryClient();
        }

        [Obsolete]
        public async Task<IEnumerable<ContentType>> GetContentTypes()
        {
        
            var query = "SELECT * FROM ContentType";
            var operation = appInsClient.StartOperation(new DependencyTelemetry
                                            {
                                                Name = "GetContentTypesDatabase",
                                                Target = "SyntheticDataDb",
                                                Type = "SQLQuery",
                                                CommandName = query
                                            });
            
            using (var connection = context.CreateConnection())
            {
                IList<ContentType> contentTypes = null;
                try
                {
                    contentTypes = (IList<ContentType>)await connection.QueryAsync<ContentType>(query);
                    operation.Telemetry.Success = true;
                }
                catch(Exception ex)
                {
                    operation.Telemetry.Success = false;
                    appInsClient.TrackException(new ExceptionTelemetry(ex));
                }
                finally
                {
                    appInsClient.StopOperation(operation);
                }
                return contentTypes.ToList();
            }
        }

        public async Task<ContentType> GetContentType(int? id)
        {
            var query = "SELECT * FROM Companies WHERE ContentTypeID = @Id";
            var operation = appInsClient.StartOperation(new DependencyTelemetry
            {
                Name = "GetContentTypeWithIdDatabase",
                Target = "SyntheticDataDb",
                Type = "SQLQuery",
                CommandName = query
            });

            ContentType contentType = null; ;
            using (var connection = context.CreateConnection())
            {
                try
                {
                    contentType = await connection.QuerySingleOrDefaultAsync<ContentType>(query, new { id });
                    operation.Telemetry.Success = true;
                }
                catch (Exception ex)
                {
                    operation.Telemetry.Success = false;
                    appInsClient.TrackException(new ExceptionTelemetry(ex));
                }
                finally
                {
                    appInsClient.StopOperation(operation);
                }
                return contentType;
            }
        }
        
    }
}
