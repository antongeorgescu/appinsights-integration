using System.Diagnostics.CodeAnalysis;
using System.Runtime.CompilerServices;


namespace ArchitectWorksPortal.UtilityClasses
{
    public class Extensions
    {
        public static bool IsNotNull([NotNullWhen(true)] object? obj) => obj != null;
        public static string WhereOrFieldContains(string containsString, string fieldName)
        {
            string[] containItems = containsString.Split(',');
            string output = string.Empty;
            if (containItems.Length > 0)
            {
                for (int i = 0; i < containItems.Length; i++)
                {
                    if (i == 0)
                        output += $"(charindex('{containItems[i]}',{fieldName}) > 0)";
                    else
                        output += $" or (charindex('{containItems[i]}',{fieldName}) > 0)";
                }
                output += ";";
            }
            return output;
        }
    }
}
