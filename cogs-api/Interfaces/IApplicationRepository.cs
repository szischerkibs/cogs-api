using System;
using System.Collections.Generic;
using cogs_api.Dtos;
using cogs_api.Models;

namespace cogs_api.Interfaces
{
    public interface IApplicationRepository
    {
        IEnumerable<Application> GetAllApplications();
        Application GetApplicationById(int id);
        Application Create(Application application);
        int Delete(int id);
    }
}
