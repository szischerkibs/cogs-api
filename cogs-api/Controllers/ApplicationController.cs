using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using cogs_api.Models;
using cogs_api.Repositories;
using cogs_api.Dtos;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using cogs_api.Interfaces;
using AutoMapper;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace cogs_api.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiController]
    public class ApplicationController : CogsApiBaseController
    {
        private readonly IApplicationRepository _applicationRepository;
        private readonly IMapper _mapper;

        public ApplicationController(IApplicationRepository applicationRepository, IMapper mapper)
        {
            _applicationRepository = applicationRepository;
            _mapper = mapper;

        }

        /// <summary>
        /// Gets all submitted applications
        /// </summary>
        /// <returns>Applications</returns>
        [HttpGet]
        public ActionResult<IEnumerable<ApplicationReadDto>> GetAll()
        {
            var applications = _applicationRepository.GetAllApplications();
            return Ok(_mapper.Map<IEnumerable<ApplicationReadDto>>(applications));
        }

        /// <summary>
        /// Gets application by id
        /// </summary>
        /// <returns>ApplicationReadDto</returns>
        [HttpGet]
        [Route("{id}", Name = "GetApplicationById")]    
        public ActionResult<IEnumerable<ApplicationReadDto>> GetById(int id)
        {
            var application = _applicationRepository.GetApplicationById(id);
            if (application != null)
            {
                return Ok(_mapper.Map<IEnumerable<ApplicationReadDto>>(application));
            }

            return NotFound();
        }

        /// <summary>
        /// Submits an application
        /// </summary>
        /// <param name="applicationCreateDto"> Application create dto object</param>
        /// <returns>The application that was created</returns>
        [HttpPost]
        public ActionResult<ApplicationReadDto> Create(ApplicationCreateDto applicationCreateDto)
        {
            var application = _mapper.Map<Application>(applicationCreateDto);
            application = _applicationRepository.Create(application);

            var applicationReadDto = _mapper.Map<ApplicationReadDto>(application);
            return CreatedAtRoute(nameof(GetById), new { Id = applicationReadDto.Id }, applicationReadDto);
        }
    }
}
