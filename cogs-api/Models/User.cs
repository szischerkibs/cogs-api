using System;
namespace cogs_api.Models
{
    public class User
    {
        public User()
        {
        }

        public int Id { get; set; }
        public string Username { get; set; }
        public string Email { get; set; }
    }
}
