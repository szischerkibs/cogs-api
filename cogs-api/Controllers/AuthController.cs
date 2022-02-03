using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using cogs_api.Interfaces;
using cogs_api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling MVC for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860


namespace cogs_api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : BaseController
    {
        private readonly IJwtAuth jwtAuth;

        public AuthController(IJwtAuth jwtAuth)
        {
            this.jwtAuth = jwtAuth;
        }

        /// <summary>
        /// Gets JWT token for logging in.
        /// </summary>
        /// <remarks>
        /// Sample value of message
        /// 
        ///     POST /authorize
        ///     {
        ///        "userName": "jdoe",
        ///        "password": "dothemash22"
        ///     }
        ///     
        /// </remarks>
        /// <param name="userCredential"></param>
        /// <returns></returns>        
        [HttpPost("authorize")]
        public IActionResult Authentication(UserCredential userCredential)
        {
            var token = jwtAuth.Authentication(userCredential);
            if (token == null)
            {
                return Unauthorized();
            }
            return Ok(token);
        }

        [HttpPost]
        [Route("Register")]
        public IActionResult Register(Application application)
        {
            //TODO: Create user and save info

            return Ok(new { Message = "User Registration Successful" });
        }

        [HttpPost]
        [Route("Login")]
        public IActionResult Login(UserCredential userCredential)
        {
            var token = jwtAuth.Authentication(userCredential);
            if (token == null)
            {
                return Unauthorized();
            }
            return Ok(token);
        }

        [HttpPost]
        [Route("Logout")]
        public IActionResult Logout()
        {
            return Ok();
        }
    }
}
