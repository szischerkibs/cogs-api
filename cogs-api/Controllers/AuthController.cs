using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;
using cogs_api.Dtos;
using cogs_api.Interfaces;
using cogs_api.Models;
using cogs_api.Repositories;
using cogs_api.Utilities;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860


namespace cogs_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : CogsApiBaseController
    {
        private readonly IAuthRepository _authRepository;
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;
        private readonly IConfiguration _appConfig;
        

        public AuthController(IAuthRepository authRepository, IMapper mapper, IConfiguration appConfig, IUserRepository userRepository)
        {
            _authRepository = authRepository;
            _userRepository = userRepository;
            _mapper = mapper;
            _appConfig = appConfig;
        }


        /// <summary>
        /// Login authentication
        /// </summary>
        /// <param name="userCredentialLoginDto">Username and password</param>
        /// <returns>Login Object</returns>
        [HttpPost]
        [Route("token")]
        public ActionResult<LoginInfoDto> Login(UserCredentialLoginDto userCredentialLoginDto)
        {
            var userCredential = _mapper.Map<UserCredential>(userCredentialLoginDto);

            var userId = _authRepository.Login(userCredential);

            if (userId > 0)
            {
                return Ok(getLoginInformation(userCredential, userId));
            }

            return Unauthorized();            
        }
        

        private LoginInfoDto getLoginInformation(UserCredential userCredential, int userId)
        {
            var claims = new[]
            {
                new Claim(JwtRegisteredClaimNames.Name, userCredential.UserName)
            };
            var secretBytes = Encoding.UTF8.GetBytes(_appConfig.GetSection("Secret").Value);

            var symmetricSecurityKey = new SymmetricSecurityKey(secretBytes);

            var algorithm = SecurityAlgorithms.HmacSha256;

            var signingCredentials = new SigningCredentials(
                symmetricSecurityKey,
                algorithm
                );

            var token = new JwtSecurityToken(
                _appConfig.GetSection("Issuer").Value,
                _appConfig.GetSection("Audience").Value,
                claims,
                notBefore: DateTime.Now,
                expires: DateTime.Now.AddDays(1),
                signingCredentials
                );

            var tokenJson = new JwtSecurityTokenHandler().WriteToken(token);

            LoginInfoDto loginInfoDto = new LoginInfoDto();
            loginInfoDto.AccessToken = tokenJson;

            var user = _userRepository.GetById(userId);

            loginInfoDto.User = _mapper.Map<UserReadDto>(user);

            return loginInfoDto;
        }
    }
}
