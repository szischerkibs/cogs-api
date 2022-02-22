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
    public class UserRepository : BaseSqlRepository, IUserRepository
    {
        public UserRepository(IConfiguration configuration) : base(configuration)
        {
        }

        public IEnumerable<User> GetAll()
        {
            List<SqlParameter> prms = new();

            List<User> users =
                ExecuteReader(
                    _cogsConnStr,
                    CommandType.StoredProcedure,
                    "UserGetAll",
                    AutoConvert<User>,
                    prms.ToArray());

            return users;
        }

        public User Create(User user)
        {
            List<SqlParameter> prms = new();            
            prms.Add(new SqlParameter("@FirstName", user.FirstName));
            prms.Add(new SqlParameter("@LastName", user.LastName));
            prms.Add(new SqlParameter("@CellNumber", user.CellNumber));
            prms.Add(new SqlParameter("@Email", user.Email));            
            prms.Add(new SqlParameter("@PasswordHash", Security.HashText(user.Password)));
            prms.Add(new SqlParameter("@Gender", user.Gender));

            int userId = Convert.ToInt32(ExecuteScalar(
                _cogsConnStr,
                CommandType.StoredProcedure,
                "UserCreate",
                prms.ToArray()));

            user.Id = userId;

            return user;
        }

        public User GetById(int id)
        {
            List<SqlParameter> prms = new ();
            prms.Add(new SqlParameter("UserId", id));

            User user =
                ExecuteReaderSingle(
                    _cogsConnStr,
                    CommandType.StoredProcedure,
                    "UserGetById",
                    AutoConvert<User>,
                    prms.ToArray());

            return user;
        }
    }
}
