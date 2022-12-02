using Microsoft.ApplicationInsights;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http.Filters;

namespace ArchitectWorksPortal.UtilityClasses
{
    public class AppInsightHandleExceptionAttribute : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext filterContext)
        {
            if (filterContext != null && filterContext.Exception != null)
            {
                var appins = new TelemetryClient();
                appins.TrackException(filterContext.Exception);
            }
            base.OnException(filterContext);
        }
    }

    public class AppDynamicsHandleExceptionAttribute : ExceptionFilterAttribute
    {
        public override void OnException(HttpActionExecutedContext filterContext)
        {
            if (filterContext != null && filterContext.Exception != null)
            {
                filterContext.Response = new HttpResponseMessage(HttpStatusCode.NotImplemented);
            }
        }
    }
}
