using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using cogs_api.Dtos;
using cogs_api.Interfaces;
using cogs_api.Models;
using cogs_api.Repositories;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace cogs_api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : CogsApiBaseController
    {

        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;

        public UsersController(IUserRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }

        /// <summary>
        /// Gets all users
        /// </summary>
        /// <remarks></remarks>
        /// <response code="200">Users retrieved</response>
        /// <returns></returns>
        [HttpGet]
        public ActionResult<IEnumerable<UserReadDto>> GetAll()
        {
            var users = _userRepository.GetAll();
            return Ok(_mapper.Map<IEnumerable<UserReadDto>>(users));
        }

        /// <summary>
        /// Gets user by id
        /// </summary>
        /// <param name="id" example="6">Id of the user you want to retrieve</param>
        /// <returns>UserReadDto object</returns>
        [HttpGet]
        [Route("{id}", Name = "GetUserById")]
        public ActionResult<UserReadDto> GetById(int id)
        {
            var user = _userRepository.GetById(id);
            if (user != null)
            {
                return Ok(_mapper.Map<UserReadDto>(user));
            }

            return NotFound();
        }

        /// <summary>
        /// Creates a user account
        /// </summary>
        /// <param name="userCreateDto"></param>
        /// <returns>User that was created</returns>
        [HttpPost]
        public ActionResult<UserReadDto> Create(UserCreateDto userCreateDto)
        {
            var user = _mapper.Map<User>(userCreateDto);
            user = _userRepository.Create(user);
            var userReadDto = _mapper.Map<UserReadDto>(user);
            return CreatedAtRoute(nameof(GetById), new { Id = userReadDto.Id }, userReadDto);
        }
    }
}
