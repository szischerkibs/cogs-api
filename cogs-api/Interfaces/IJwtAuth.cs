using System;
using cogs_api.Models;

namespace cogs_api.Interfaces
{
    public interface IJwtAuth
    {
        string Authentication(UserCredential userCredential);
    }
}
