using LoggerApiDemo.Interfaces;
using LoggerApiDemo.Utilities;
using System;
using System.Security.Cryptography;
using System.Text;

namespace LoggerApiDemo.Classes
{
    public class LoggerEntry : ILoggerEntry
    {
        SHA256 sha256Hash;
        public LoggerEntry()
        {
            sha256Hash = SHA256.Create();
        }
        public LoggerEntry(DateTime createDate, string type, string @class, string message, string description = null)
        {
            sha256Hash = SHA256.Create();

            CreateDate = createDate;
            Type = type;
            Class = @class;
            Description = description;
            Description = message;
        }

        public DateTime CreateDate { get; set; }
        public string Type { get; set; }
        public string Class { get; set; }
        public string? Description { get; set; }
        public string Message { get; set; }
        public string HashKey
        {
            get
            {
                var source = string.Concat(Type, Class, Message);
                string hash = getHash(sha256Hash, source);
                return hash;
            }
        }
        public bool IsIdenticalLog(ILoggerEntry otherlog)
        {
            return verifyHash(sha256Hash, otherlog);
        }

        private string getHash(HashAlgorithm hashAlgorithm, string input)
        {
            // Convert the input string to a byte array and compute the hash.
            byte[] data = hashAlgorithm.ComputeHash(Encoding.UTF8.GetBytes(input));

            // Create a new Stringbuilder to collect the bytes
            // and create a string.
            var sBuilder = new StringBuilder();

            // Loop through each byte of the hashed data
            // and format each one as a hexadecimal string.
            for (int i = 0; i < data.Length; i++)
            {
                sBuilder.Append(data[i].ToString("x2"));
            }

            // Return the hexadecimal string.
            return sBuilder.ToString();
        }

        // Verify a hash against a LoggerEntry object.
        private bool verifyHash(HashAlgorithm hashAlgorithm, ILoggerEntry log)
        {
            // Hash the input.
            var hashOfInput = getHash(hashAlgorithm, string.Concat(log.Type, log.Class, log.Message));

            // Create a StringComparer an compare the hashes.
            StringComparer comparer = StringComparer.OrdinalIgnoreCase;

            return comparer.Compare(hashOfInput, HashKey) == 0;
        }
    }
}
