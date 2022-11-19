using System.Collections.Generic;
using System;
using System.Text.RegularExpressions;
using AngularSpaWebApi.Controllers;
using System.Linq;
using AngularSpaWebApi.Logger;

namespace AngularSpaWebApi.Services
{
    public class ExceptionServices
    {
        public static string UpperCaseFirstChar(string text)
        {
            return Regex.Replace(text, "^[a-z]", m => m.Value.ToUpper());
        }

        public static List<string> GenerateSyntheticMessage(int count)
        {
            Random res = new Random();

            // String of alphabets 
            var str = "abcdefghijklmnopqrstuvwxyz";
            var lstWord = new List<string>();
            bool addedFirstWord = false;

            for (int i = 0; i < count; i++)
            {
                // Initializing the empty string
                var word = String.Empty;
                int size = res.Next(20);

                if (size == 1)
                    continue;

                for (int j = 0; j < size; j++)
                {

                    // Selecting a index randomly
                    int x = res.Next(26);

                    // Appending the character at the 
                    // index to the random string.
                    word += str[x];
                }
                if (!addedFirstWord)
                {
                    lstWord.Add(UpperCaseFirstChar(word));
                    addedFirstWord = true;
                }
                else
                    lstWord.Add(word);
            }
            return lstWord;
        }

        public static List<ThrowErrorRequest> GenerateRandomErrorList(int count, string framework = null)
        {
            var exlist = new List<ThrowErrorRequest>();
            var extypes = new [] { "netcore", "angular"};
            
            if (!String.IsNullOrEmpty(framework))
            {
                // an exception framework has been provided (either 'netcore' or 'angular')
                if (!extypes.Contains(framework))
                    // the provided type is incorrect
                    return null;

                Random res = new Random();
                
                var fxCode = (framework == "netcore") ? "NET" : "NG";
                var fxCodeClassDescriptionList = ExceptionUtilitiesController.CodeClassDescriptionList.Select(x => x).Where(x => x.Item1.Contains(fxCode)).ToList();

                for (int i = 0; i < count; i++)
                {
                    int index = res.Next(fxCodeClassDescriptionList.Count-1);
                    var error = new ThrowErrorRequest()
                    {
                        Code = fxCodeClassDescriptionList[index].Item1,
                        Framework = framework,
                        Class = fxCodeClassDescriptionList[index].Item2,
                        Description = fxCodeClassDescriptionList[index].Item3
                    };
                    error.Generate();
                    exlist.Add(error);
                }
            }
            else
            {
                // no exception framework has ben provided; will select randomly
                Random res = new Random();

                var fxCodeClassDescriptionList = ExceptionUtilitiesController.CodeClassDescriptionList.Select(x => x).ToList();

                for (int i = 0; i < count; i++)
                {
                    int index = res.Next(fxCodeClassDescriptionList.Count - 1);
                    var error = new ThrowErrorRequest()
                    {
                        Code = fxCodeClassDescriptionList[index].Item1,
                        Framework = (fxCodeClassDescriptionList[index].Item1.Contains("NG") ? "angular" : "netcore"),
                        Class = fxCodeClassDescriptionList[index].Item2,
                        Description = fxCodeClassDescriptionList[index].Item3
                    };
                    error.Generate();
                    exlist.Add(error);
                }
            }
            
            return exlist;
        }

    }
}
