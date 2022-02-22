using System;
namespace cogs_api.Dtos
{
    public class UserCredentialLoginDto
    {
        /// <summary>
        /// Username used to log in
        /// </summary>
        public string UserName { get; set; }

        /// <summary>
        /// Password used to log in 
        /// </summary>
        public string Password { get; set; }
    }
}
