using System.Diagnostics.CodeAnalysis;

namespace ArchitectWorksPortal.UtilityClasses
{
    public class Extensions
    {
        public static bool IsNotNull([NotNullWhen(true)] object? obj) => obj != null;
    }
}
