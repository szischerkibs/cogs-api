using System;
namespace cogs_api.Dtos
{
    public class LoginInfoDto
    {        
        public string AccessToken { get; set; }
        public UserReadDto User { get; set; }
    }
}
