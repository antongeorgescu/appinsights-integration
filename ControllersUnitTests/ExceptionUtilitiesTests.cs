using Microsoft.ApplicationInsights.DependencyCollector;
using Microsoft.ApplicationInsights.Extensibility;
using Microsoft.ApplicationInsights;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using static ControllersUnitTests.Utilities;

namespace ControllersUnitTests.ExceptionUtilities
{
    [TestClass]
    public class ExceptionUtilitiesTests
    {
        const string _loggerUtilitiesURI = "http://localhost:5001/ilogger";
        private TestContext testContextInstance;

        /// <summary>
        /// Gets or sets the test context which provides
        /// information about and functionality for the current test run.
        /// </summary>
        public TestContext TestContext
        {
            get { return testContextInstance; }
            set { testContextInstance = value; }
        }

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
                response.Add(new FileObject { Name = entry.ToString().Split('\\')[entry.ToString().Split('\\').Length - 1], Path = entry.ToString() });

            Assert.IsTrue(response.ToArray().Length == 5);
        }



        [TestMethod]
        public void TestReverseArray()
        {
            // Creates and initializes a new Array.
            Array myArray = Array.CreateInstance(typeof(string), 9);

            var message = randomTraceMessage();
            var k = 0;
            foreach (var word in message.Split(' '))
            {
                if (string.IsNullOrWhiteSpace(word)) continue;
                myArray.SetValue(word.ToLower(), k++);
            }
            
            var beforeLength = myArray.Length;

            // Displays the values of the Array.
            TestContext.WriteLine("Before reversing:");
            for (int i = myArray.GetLowerBound(0); i <= myArray.GetUpperBound(0); i++)
                TestContext.WriteLine("\t[{0}]:\t{1}", i, myArray.GetValue(i));

            // Reverses the sort of the values of the Array.
            Array.Reverse(myArray, 0, myArray.Length);

            // Displays the values of the Array.
            TestContext.WriteLine("After reversing:");
            for (int i = myArray.GetLowerBound(0); i <= myArray.GetUpperBound(0); i++)
                TestContext.WriteLine("\t[{0}]:\t{1}", i, myArray.GetValue(i));

            var afterLength = myArray.Length;
            
            Assert.AreEqual(beforeLength, afterLength);
        }

        
    }
}
