using System;
namespace cogs_api.Models
{
    /// <summary>
    /// Used for logging into the site
    /// </summary>
    public class UserCredential
    {
        /// <summary>
        /// Username used to log in
        /// </summary>
        public string UserName { get; set; }

        /// <summary>
        /// Password used to log in 
        /// </summary>
        public string Password { get; set; }

        /// <summary>
        /// Password used to log in 
        /// </summary>
        public string PasswordHash {
            get
            {
                return Utilities.Security.HashText(this.Password);
            }
        }

    }
}
