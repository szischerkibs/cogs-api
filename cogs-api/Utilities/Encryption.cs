using System;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;

namespace cogs_api.Utilities
{
    public static class Security
    {


        public static string HashText(string password)
        {
            var salt = Convert.FromBase64String("uPPlyQvVKUg7feDHmuTrLg==");

            string hashed = Convert.ToBase64String(KeyDerivation.Pbkdf2(
            password: password,
            salt: salt,
            prf: KeyDerivationPrf.HMACSHA256,
            iterationCount: 100000,
            numBytesRequested: 256 / 8));

            return hashed;
        }
    }
}
