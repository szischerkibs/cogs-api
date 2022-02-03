using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using cogs_api.Models;
using cogs_api.Utilities;

namespace cogs_api.Repositories
{
    public class AuthRepository : BaseSqlRepository
    {
        private string _connStr;

        public AuthRepository(string username) : base(username)
        {
            _connStr = AppSettingsJson.GetAppSettings()["ConnectionStrings:CogsDB"];
        }

        public int Login(UserCredential userCredential)
        {
            List<SqlParameter> prms = new List<SqlParameter>();
            prms.Add(new SqlParameter("@Username", userCredential.UserName));
            prms.Add(new SqlParameter("@PasswordHash", Utilities.Security.HashText(userCredential.Password)));
            int userId = (int)ExecuteScalar(
                _connStr,
                CommandType.StoredProcedure,
                "LoginAuth",
                prms.ToArray());

            return userId;
        }
    }
}
