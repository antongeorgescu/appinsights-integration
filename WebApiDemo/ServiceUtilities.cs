using System.Collections.Generic;
using System;
using System.Text.RegularExpressions;

namespace WebApiDemo.Utilities
{
    public class ServiceUtilities
    {
        static public string UpperCaseFirstChar(string text)
        {
            return Regex.Replace(text, "^[a-z]", m => m.Value.ToUpper());
        }

        static public List<string> GenerateSyntheticMessage(int count)
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
    }
}
