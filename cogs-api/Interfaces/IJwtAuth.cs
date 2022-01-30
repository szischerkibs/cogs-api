using System;
namespace cogs_api.Interfaces
{
    public interface IJwtAuth
    {
        string Authentication(string username, string password);
    }
}
