using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using cogs_api.Interfaces;
using cogs_api.Models;
using cogs_api.Utilities;
using Microsoft.Extensions.Configuration;

namespace cogs_api.Repositories
{
    public class AuthRepository : BaseSqlRepository, IAuthRepository
    {
        public AuthRepository(IConfiguration configuration) : base(configuration)
        {
        }

        public int Login(UserCredential userCredential)
        {
            List<SqlParameter> prms = new List<SqlParameter>();
            prms.Add(new SqlParameter("@Username", userCredential.UserName));
            prms.Add(new SqlParameter("@PasswordHash", userCredential.PasswordHash));

            int userId = (int)ExecuteScalar(
                _cogsConnStr,
                CommandType.StoredProcedure,
                "LoginAuth",
                prms.ToArray());

            return userId;
        }
    }
}
