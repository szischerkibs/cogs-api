using System;
using System.Collections.Generic;
using cogs_api.Models;

namespace cogs_api.Interfaces
{
    public interface IUserRepository
    {
        IEnumerable<User> GetAll();
        User Create(User user);
        User GetById(int id);
    }
}
