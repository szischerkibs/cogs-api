using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;

namespace cogs_api.Controllers
{
    public abstract class CogsApiBaseController : ControllerBase
    {
        public string Username
        {
            get
            {
                if (User != null)
                {
                    var user = ((System.Security.Claims.ClaimsIdentity)User.Identity).Claims.FirstOrDefault(c => c.Type == "name");
                    var username = user.Value;
                    return username;
                }

                return "Unknown";
            }
        }
    }
}
