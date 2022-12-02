using Microsoft.ApplicationInsights;
using System;
using System.Diagnostics.CodeAnalysis;
using System.Net;
using System.Net.Http;
using System.Web.Http.Filters;
using Microsoft.AspNetCore.Mvc.Filters;
using ExceptionFilterAttribute = Microsoft.AspNetCore.Mvc.Filters.ExceptionFilterAttribute;
using Microsoft.AspNetCore.Mvc;
//using System.Web.Http.Filters.ExceptionFilterAttribute;

namespace ArchitectWorksPortal.UtilityClasses
{
    
    public class AppInsightHandleExceptionAttribute : ExceptionFilterAttribute
    {
        //public override void OnException(HttpActionExecutedContext filterContext)
        public override void OnException(ExceptionContext filterContext)
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
        //public override void OnException(HttpActionExecutedContext filterContext)
        public override void OnException(ExceptionContext filterContext)
        {
            base.OnException(filterContext);
        }
    }

    public class NotImplExceptionFilterAttribute : ExceptionFilterAttribute
    {
        //public override void OnException(HttpActionExecutedContext context)
        public override void OnException(ExceptionContext filterContext)
        {
            if (filterContext.Exception is NotImplementedException)
            {
                filterContext.Result = new NotFoundResult();
            }
        }
    }
}
