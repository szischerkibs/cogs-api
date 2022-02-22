using System;
using System.ComponentModel.DataAnnotations;

namespace cogs_api.Dtos
{
    public class UserCreateDto
    {
        [Required]
        public string FirstName { get; set; }
        [Required]
        public string LastName { get; set; }
        [Required]
        public string CellNumber { get; set; }
        [Required]
        public string Email { get; set; }
        [Required]
        public string Password { get; set; }


        public string UserName {
            get
            {
                return this.Email;
            }
        }
    }
}
