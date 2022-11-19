using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;

namespace ControllersUnitTests
{
    [TestClass]
    public class ExceptionUtilitiesTests
    {
        const string _loggerUtilitiesURI = "http://localhost:5001/ilogger";

        [TestMethod]
        public async Task TestGetLogFiles()
        {
            // call Logger service to log exceptions
            HttpClient client = new HttpClient();
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(
                new MediaTypeWithQualityHeaderValue("application/text"));
            client.DefaultRequestHeaders.Add("User-Agent", "Synthetic Exception Generator");

            var request = await client.GetAsync($"{_loggerUtilitiesURI}/logfiles");
            var result = request.Content.ReadAsStringAsync().Result;
            var jarray = JArray.Parse(result);

            var response = new List<FileObject>();
            foreach (var entry in jarray)
                response.Add(new FileObject { Name = entry.ToString().Split('\\')[entry.ToString().Split('\\').Length-1], Path = entry.ToString() }); 

            Assert.IsTrue(response.ToArray().Length == 5);
        }

        internal class FileObject
        {
            internal string Name { get; set; }
            internal string Path { get; set; }
        }
    }
}
