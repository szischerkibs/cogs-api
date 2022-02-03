using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
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
    public class ApplicationController : BaseController
    {
        private ApplicationRepository applicationRepository;

        public ApplicationController()
        {
            applicationRepository = new ApplicationRepository(this.Username);
        }

        /// <summary>
        /// Gets all submitted applications
        /// </summary>
        /// <returns>Applications</returns>
        [HttpGet]
        public List<Application> GetAll()
        {            
            var applications = applicationRepository.GetAllApplications();
            return applications;
        }
    }
}
