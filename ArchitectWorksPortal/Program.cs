using ArchitectWorksPortal.DAL;
using ArchitectWorksPortal.Models;
using ArchitectWorksPortal.Repositories;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Web.Http;
using ArchitectWorksPortal.UtilityClasses;
//using Site24x7.Agent;

var AllowSpecificOrigins = "_myAllowSpecificOrigins";
var AllowAnyOrigin = "_myAllowAnyOrigin";

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

builder.Services.AddCors(options =>
{
    //options.AddPolicy(name: AllowSpecificOrigins,
    //                  policy =>
    //                  {
    //                      policy.WithOrigins("https://www.finastra.com/hack-to-the-future",
    //                                          "http://www.microsoft.com");
    //                  });

    options.AddPolicy(name: AllowAnyOrigin,policy => {policy.AllowAnyOrigin();});
});
builder.Services.AddSingleton<DapperContext>();
builder.Services.AddScoped<IContentTypeRepository, ContentTypeRepository>();
builder.Services.AddScoped<IDatasetRepository, DatasetRepository>();
builder.Services.AddScoped<IPortalRepository, PortalRepository>();
builder.Services.AddScoped<IPublicationRepository, PublicationRepository>();
builder.Services.AddScoped<AppInsightHandleExceptionAttribute>();
builder.Services.AddScoped<AppDynamicsHandleExceptionAttribute>();
//builder.Services.AddSite24x7ApmInsights();
builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen(c =>
//{
//    c.SwaggerDoc("v1", new() { Title = "TodoApi", Version = "v1" });
//});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
    app.UseDeveloperExceptionPage();
else
{
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseRouting();

app.UseCors(AllowAnyOrigin);

app.MapControllerRoute(
    name: "default",
    pattern: "{controller}/{action=Index}/{id?}");

app.MapFallbackToFile("index.html");;

app.Run();
