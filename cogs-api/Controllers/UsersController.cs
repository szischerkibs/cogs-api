using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using cogs_api.Interfaces;
using cogs_api.Models;
using cogs_api.Repositories;
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

        UserRepository userRepository;

        public UsersController()
        {
            userRepository = new UserRepository(this.Username);
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
            return userRepository.GetUsers();
        }

        /// <summary>
        /// Gets user by id
        /// </summary>
        /// <param name="id" example="1">Id of the user you want to retrieve</param>
        /// <returns></returns>
        [HttpGet("{id}")]
        public User GetUserById(int id)
        {
            return userRepository.GetUserById(id);
        }

        
    }
}
