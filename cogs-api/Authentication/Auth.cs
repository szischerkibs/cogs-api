using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using cogs_api.Interfaces;
using Microsoft.IdentityModel.Tokens;

namespace cogs_api.Authentication
{
    public class Auth : IJwtAuth
    {
        private readonly string username = "jdoe";
        private readonly string password = "dothemash22";
        private readonly string key = "";

        public Auth(string key)
        {
            this.key = key;
        }

        public string Authentication(string username, string password)
        {
            if(!(username.Equals(this.username) || password.Equals(this.password)))
            {
                return null;
            }

            var tokenHandler = new JwtSecurityTokenHandler();

            var tokenKey = Encoding.ASCII.GetBytes(key);

            var tokenDescriptor = new SecurityTokenDescriptor()
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, username)
                }),
                Expires = DateTime.UtcNow.AddHours(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(tokenKey), SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);

        }
    }
}
