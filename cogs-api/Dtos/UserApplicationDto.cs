using System;
using cogs_api.Models;

namespace cogs_api.Dtos
{
    public class UserApplicationDto
    {
        public User User { get; set; }
        public Application Application { get; set; }
    }
}
