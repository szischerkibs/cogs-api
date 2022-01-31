using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using cogs_api.Interfaces;
using cogs_api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace cogs_api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : BaseController
    {
        private readonly IJwtAuth jwtAuth;

        private readonly List<User> users = new List<User>()
        {
            new User() { Id = 1, Username = "jdoe", Email = "jdoe@gmail.com" },
            new User() { Id = 2, Username = "jsmith", Email = "jsmith@gmail.com" },
            new User() { Id = 3, Username = "jjackson", Email = "jjackson@gmail.com" }
        };

        public UsersController(IJwtAuth jwtAuth)
        {
            this.jwtAuth = jwtAuth;
        }

        /// <summary>
        /// Gets all users
        /// </summary>
        /// <remarks>Awesome</remarks>
        /// <response code="200">Users retrieved</response>
        /// <returns></returns>
        [HttpGet]
        public List<User> GetUsers()
        {
            return this.users;
        }

        /// <summary>
        /// Gets user by id
        /// </summary>
        /// <param name="id" example="1">Id of the user you want to retrieve</param>
        /// <returns></returns>
        [HttpGet("{id}")]
        public User GetUserById(int id)
        {
            return this.users.Find(x => x.Id == id);
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
        [AllowAnonymous]
        [HttpPost("authorize")]
        public IActionResult Authentication([FromBody]UserCredential userCredential)
        {
            var token = jwtAuth.Authentication(userCredential.UserName, userCredential.Password);
            if(token == null)
            {
                return Unauthorized();
            }
            return Ok(token);
        }
    }
}
