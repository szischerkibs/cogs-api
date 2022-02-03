using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using cogs_api.Models;
using cogs_api.Utilities;

namespace cogs_api.Repositories
{
    public class UserRepository : BaseSqlRepository
    {
        private string _connStr;

        public UserRepository(string username) : base(username)
        {
            _connStr = AppSettingsJson.GetAppSettings()["ConnectionStrings:CogsDB"];
        }

        public List<User> GetUsers()
        {
            List<SqlParameter> prms = new List<SqlParameter>();

            List<User> users =
                ExecuteReader(
                    _connStr,
                    CommandType.StoredProcedure,
                    "UserGetAll",
                    AutoConvert<User>,
                    prms.ToArray());

            return users;
        }

        public int CreateUser(User user)
        {
            List<SqlParameter> prms = new List<SqlParameter>();
            int userId = (int) ExecuteScalar(
                _connStr,
                CommandType.StoredProcedure,
                "UserCreate",
                prms.ToArray());

            return userId;
        }

        public User GetUserById(int id)
        {
            List<SqlParameter> prms = new List<SqlParameter>();

            List<User> users =
                ExecuteReader(
                    _connStr,
                    CommandType.StoredProcedure,
                    "UserGetAll",
                    AutoConvert<User>,
                    prms.ToArray());

            return users[0];
        }
    }
}
