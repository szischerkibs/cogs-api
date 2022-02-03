using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using cogs_api.Interfaces;
using cogs_api.Models;
using cogs_api.Repositories;
using Microsoft.IdentityModel.Tokens;

namespace cogs_api.Authentication
{
    public class Auth : IJwtAuth
    {
        private readonly string key = "";
        AuthRepository authRepository;
        public Auth(string key)
        {
            authRepository = new AuthRepository("Unknown");
            this.key = key;
        }

        public string Authentication(UserCredential userCredential)
        {
            if(authRepository.Login(userCredential) == -1)
            {
                return null;
            }

            var tokenHandler = new JwtSecurityTokenHandler();

            var tokenKey = Encoding.ASCII.GetBytes(key);

            var tokenDescriptor = new SecurityTokenDescriptor()
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, userCredential.UserName)
                }),
                Expires = DateTime.UtcNow.AddHours(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(tokenKey), SecurityAlgorithms.HmacSha256Signature)
            };

            var token = tokenHandler.CreateToken(tokenDescriptor);

            return tokenHandler.WriteToken(token);

        }
    }
}
