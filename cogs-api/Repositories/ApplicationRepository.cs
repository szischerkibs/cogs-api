using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using cogs_api.Models;
using cogs_api.Dtos;
using Microsoft.Extensions.Configuration;
using cogs_api.Interfaces;

namespace cogs_api.Repositories
{
    public class ApplicationRepository : BaseSqlRepository, IApplicationRepository
    {
        private readonly UserRepository _userRepository;

        public ApplicationRepository(IConfiguration configuration) : base(configuration)
        {
            _userRepository = new UserRepository(configuration);
        }

        public IEnumerable<Application> GetAllApplications()
        {
            List<SqlParameter> prms = new();

            IEnumerable<Application> applications =
                ExecuteReader(
                    _cogsConnStr,
                    CommandType.StoredProcedure,
                    "ApplicationGetAll",
                    AutoConvert<Application>,
                    prms.ToArray());

            return applications;
        }

        public Application Create(Application application)
        {
            List<SqlParameter> prms = new();
            prms.Add(new SqlParameter("@UserId", application.UserId));
            prms.Add(new SqlParameter("@School", application.School));
            prms.Add(new SqlParameter("@Major", application.Major));
            prms.Add(new SqlParameter("@Topics", application.Topics));
            prms.Add(new SqlParameter("@Essay", application.Essay));
            prms.Add(new SqlParameter("@FirstTimer", application.FirstTimer));
            prms.Add(new SqlParameter("@HowManyYears", application.HowManyYears));

            int applicationId =
                Convert.ToInt32(ExecuteScalar(
                    _cogsConnStr,
                    CommandType.StoredProcedure,
                    "ApplicationUpsert",
                    prms.ToArray()));

            application.Id = applicationId;

            return application;
        }

        public Application GetApplicationById(int id)
        {
            throw new NotImplementedException();
        }

        public int Delete(int id)
        {
            throw new NotImplementedException();
        }

        #region Converters
        #endregion
    }
}
