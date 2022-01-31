using System;
using Microsoft.AspNetCore.Mvc;

namespace cogs_api.Controllers
{
    public class BaseController : Controller
    {
        public string Username
        {
            get
            {
                //var uname = this.Request.Headers["username"].ToString();
                return "Unknown";
            }
        }

        public BaseController() 
        {
        }
    }
}
