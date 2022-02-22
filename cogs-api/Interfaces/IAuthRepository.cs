using System;
using cogs_api.Models;

namespace cogs_api.Interfaces
{
    public interface IAuthRepository
    {
        int Login(UserCredential userCredential);
    }
}
