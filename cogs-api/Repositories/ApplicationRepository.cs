using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using cogs_api.Models;
using cogs_api.Utilities;

namespace cogs_api.Repositories
{
    public class ApplicationRepository : BaseSqlRepository
    {
        private string _connStr;

        public ApplicationRepository(string username) : base(username)
        {
            _connStr = AppSettingsJson.GetAppSettings()["ConnectionStrings:CogsDB"];
        }

        public List<Application> GetAllApplications()
        {
            List<SqlParameter> prms = new List<SqlParameter>();

            List<Application> applications =
                ExecuteReader(
                    _connStr,
                    CommandType.StoredProcedure,
                    "ApplicationGetAll",
                    AutoConvert<Application>,
                    prms.ToArray());

            return applications;
        }

        #region Converters
        #endregion
    }
}
