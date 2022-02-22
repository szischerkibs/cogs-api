using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Reflection;
using cogs_api.Interfaces;
using cogs_api.Utilities;
using Microsoft.Extensions.Configuration;

namespace cogs_api.Repositories
{
    public class BaseSqlRepository
    {
        
        public string _errorLogConnStr = "";
        public string _cogsConnStr = "";
        public string _username = "Unknown";
        public readonly IConfiguration _appConfig;

        public BaseSqlRepository(IConfiguration configuration)
        {
            _appConfig = configuration;            
            _errorLogConnStr = _appConfig.GetConnectionString("ErrorLog");
            _cogsConnStr = _appConfig.GetConnectionString("CogsDB");
        }

        #region Sql Error Handling

        /// <summary>
        /// Executes a non query in sql
        /// </summary>
        /// <param name="connectionString">Connection string</param>
        /// <param name="commandType">SqlCommand command type.  Stored Procedure, Table, text</param>
        /// <param name="commandText">Stored proc name or t-sql statement</param>
        /// <param name="parameters">Sql parameters array</param>
        protected void ExecuteNonQuery(string connectionString, CommandType commandType, string commandText, SqlParameter[] parameters)
        {
            try
            {
                using (var conn = new SqlConnection(connectionString))
                {
                    using (var cmd = new SqlCommand(commandText, conn))
                    {
                        cmd.CommandType = commandType;
                        if (parameters != null)
                            cmd.Parameters.AddRange(parameters);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (SqlException se)
            {
                int logId = LogSqlError(se, connectionString);
                throw new CogsException(logId, "Sql ExecuteNonQuery error", se);
            }
            catch (Exception ex)
            {
                int logId = LogError(ex);
                throw new CogsException(logId, "General ExecuteNonQuery error", ex);
            }
        }

        /// <summary>
        /// Executes a scalar sql call
        /// </summary>
        /// <param name="connectionString">Connection string</param>
        /// <param name="commandType">SqlCommand command type.  Stored Procedure, Table, text</param>
        /// <param name="commandText">Stored proc name or t-sql statement</param>
        /// <param name="parameters">Sql parameters array</param>
        /// <returns>Object that is returned by the Scalar call</returns>
        protected object ExecuteScalar(string connectionString, CommandType commandType, string commandText, SqlParameter[] parameters)
        {
            try
            {
                using (var conn = new SqlConnection(connectionString))
                {
                    using (var cmd = new SqlCommand(commandText, conn))
                    {
                        cmd.CommandType = commandType;
                        if (parameters != null)
                            cmd.Parameters.AddRange(parameters);
                        conn.Open();
                        return cmd.ExecuteScalar();

                    }
                }
            }
            catch (SqlException se)
            {
                int logId = LogSqlError(se, connectionString);
                throw new CogsException(logId, "Sql ExecuteScalar error", se);
            }
            catch (Exception ex)
            {
                int logId = LogError(ex);
                throw new CogsException(logId, "General ExecuteScalar error", ex);
            }            
        }

        /// <summary>
        /// Executes a sql datareader call
        /// </summary>
        /// <typeparam name="T">Type that should be returned</typeparam>
        /// <param name="connectionString">Connection string</param>
        /// <param name="commandType">SqlCommand command type.  Stored Procedure, Table, text</param>
        /// <param name="commandText">Stored proc name or t-sql statement</param>
        /// <param name="converter">Function that should be used to populate T</param>
        /// <param name="parameters">Sql parameters array</param>
        /// <returns>List of T</returns>
        protected List<T> ExecuteReader<T>(string connectionString, CommandType commandType, string commandText, Func<SqlDataReader, T> converter, SqlParameter[] parameters)
        {
            List<T> retval = new List<T>();

            try
            {
                using (var conn = new SqlConnection(connectionString))
                {
                    using (var cmd = new SqlCommand(commandText, conn))
                    {
                        cmd.CommandType = commandType;
                        if (parameters != null)
                            cmd.Parameters.AddRange(parameters);
                        conn.Open();
                        var dr = cmd.ExecuteReader();

                        while (dr.Read())
                        {
                            retval.Add(converter(dr));
                        }

                    }
                }
            }
            catch (SqlException se)
            {
                int logId = LogSqlError(se, connectionString);
                throw new CogsException(logId, "Sql ExecuteReader error", se);
            }
            catch (Exception ex)
            {
                int logId = LogError(ex);
                throw new CogsException(logId, "General ExecuteReader error", ex);
            }

            return retval;
        }

        /// <summary>
        /// Executes a sql datareader call and returns 1 row
        /// </summary>
        /// <typeparam name="T">Type that should be returned</typeparam>
        /// <param name="connectionString">Connection string</param>
        /// <param name="commandType">SqlCommand command type.  Stored Procedure, Table, text</param>
        /// <param name="commandText">Stored proc name or t-sql statement</param>
        /// <param name="converter">Function that should be used to populate T</param>
        /// <param name="parameters">Sql parameters array</param>
        /// <returns>Single T</returns>
        protected T ExecuteReaderSingle<T>(string connectionString, CommandType commandType, string commandText, Func<SqlDataReader, T> converter, SqlParameter[] parameters)
        {
            T retval = default(T);

            try
            {
                using (var conn = new SqlConnection(connectionString))
                {
                    using (var cmd = new SqlCommand(commandText, conn))
                    {
                        cmd.CommandType = commandType;
                        if (parameters != null)
                            cmd.Parameters.AddRange(parameters);
                        conn.Open();
                        var dr = cmd.ExecuteReader();

                        while (dr.Read())
                        {
                            return converter(dr);
                        }

                    }
                }
            }
            catch (SqlException se)
            {
                int logId = LogSqlError(se, connectionString);
                throw new CogsException(logId, "Sql ExecuteReaderSingle error", se);
            }
            catch (Exception ex)
            {
                int logId = LogError(ex);
                throw new CogsException(logId, "General ExecuteReaderSingle error", ex);
            }

            return retval;
        }

        /// <summary>
        /// Logs sql error to SQL Errors DB
        /// </summary>
        /// <param name="se">Accepts a SQL exception</param>
        /// <param name="connectionString">Accepts a connection string</param>
        /// <returns>Error Id</returns>
        protected int LogSqlError(SqlException se, string connectionString)
        {
            try
            {
                var errorConnString = new SqlConnection(connectionString);
                using (var conn = new SqlConnection(_errorLogConnStr))
                {
                    using (var cmd = new SqlCommand("InsertDBError", conn))
                    {
                        conn.Open();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("SourceServer", se.Server);
                        cmd.Parameters.AddWithValue("SourceDatabase", errorConnString.Database);
                        cmd.Parameters.AddWithValue("SourceObject", se.Procedure);
                        cmd.Parameters.AddWithValue("ErrorNumber", se.Number);
                        cmd.Parameters.AddWithValue("ErrorSeverity", se.Class);
                        cmd.Parameters.AddWithValue("ErrorState", se.State);
                        cmd.Parameters.AddWithValue("ErrorLine", se.LineNumber);
                        cmd.Parameters.AddWithValue("ErrorMessage", se.Message);
                        //cmd.Parameters.AddWithValue("Username", _username);

                        int id = Convert.ToInt32(cmd.ExecuteScalar());

                        return id;
                    }
                }
            }
            catch
            {
                //Need to swallow error if this doesn't work, return a -99 to indicate that error logging failed.
                return -99;
            }
        }

        /// <summary>
        /// Logs general error to SQL Errors DB
        /// </summary>
        /// <param name="ge">Accepts a general exception</param>
        /// <returns>Error Id</returns>
        protected int LogError(Exception ge)
        {
            try
            {                
                using (var conn = new SqlConnection(_errorLogConnStr))
                {
                    //using (var cmd = new SqlCommand("InsertDBError", conn))
                    //{
                    //    conn.Open();
                    //    cmd.CommandType = CommandType.StoredProcedure;
                    //    cmd.Parameters.AddWithValue("SourceServer", se.Server);
                    //    cmd.Parameters.AddWithValue("SourceDatabase", errorConnString.Database);
                    //    cmd.Parameters.AddWithValue("SourceObject", se.Procedure);
                    //    cmd.Parameters.AddWithValue("ErrorNumber", se.Number);
                    //    cmd.Parameters.AddWithValue("ErrorSeverity", se.Class);
                    //    cmd.Parameters.AddWithValue("ErrorState", se.State);
                    //    cmd.Parameters.AddWithValue("ErrorLine", se.LineNumber);
                    //    cmd.Parameters.AddWithValue("ErrorMessage", se.Message);
                    //    //cmd.Parameters.AddWithValue("Username", _username);

                    //    int id = Convert.ToInt32(cmd.ExecuteScalar());

                    //    return id;
                    return -1;
                    //}
                }
            }
            catch
            {
                //Need to swallow error if this doesn't work, return a -99 to indicate that error logging failed.
                return -99;
            }
        }

        #endregion

        #region Value Conversion

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>boolean value for the field</returns>
        protected bool BoolValue(object value)
        {
            return value == null || value == System.DBNull.Value ? false : Convert.ToBoolean(Convert.ToInt32(value));
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>Decimal value for the field</returns>
        protected decimal DecimalValue(object value)
        {
            return value == null || value == System.DBNull.Value ? 0 : Convert.ToDecimal(value);
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>String value for the field</returns>
        protected string StringValue(object value)
        {
            return value == null || value == System.DBNull.Value ? string.Empty : value.ToString();
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>DateTime value for the field</returns>
        protected DateTime DateTimeValue(object value)
        {
            return value == null || value == System.DBNull.Value ? DateTime.MinValue : Convert.ToDateTime(value);
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>DateTime value for the field</returns>
        protected DateTimeOffset DateTimeOffsetValue(object value)
        {
            return value == null || value == System.DBNull.Value ? DateTime.MinValue : DateTimeOffset.Parse(value.ToString());
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>DateTime? value for the field</returns>
        protected DateTime? NullableDateTimeValue(object value)
        {
            if (value == null || value == System.DBNull.Value)
            {
                return null;
            }
            else
            {
                DateTime dtHolder;
                if (DateTime.TryParse(value.ToString(), out dtHolder))
                {
                    return dtHolder;
                }
                else
                {
                    return null;
                }
            }
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>Double value for the field</returns>
        protected double DoubleValue(object value)
        {
            return value == null || value == System.DBNull.Value ? 0 : Convert.ToDouble(value);
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>Double value for the field</returns>
        protected double? NullableDoubleValue(object value)
        {
            if (value == null || value == System.DBNull.Value)
            {
                return null;
            }
            else
            {
                return Convert.ToDouble(value);
            }
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>Nullable Boolean value for the field</returns>
        protected bool? NullableBoolValue(object value)
        {
            if (value == null || value == DBNull.Value)
                return null;

            try
            {
                return Convert.ToBoolean(value);
            }
            catch (Exception)
            {
                return false;
            }
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>Nullable Integer value for the field</returns>
        protected int? NullableIntValue(object value)
        {
            if (value == null || value == DBNull.Value)
                return null;

            try
            {
                return Convert.ToInt32(value);
            }
            catch (Exception)
            {
                return -1;
            }
        }

        /// <summary>
        /// Retrieves a field value from the Data objects
        /// </summary>
        /// <param name="value">Name of the field in the dataset</param>
        /// <returns>Integer value for the field</returns>
        protected int IntValue(object value)
        {
            return value == null || value == System.DBNull.Value ? 0 : Convert.ToInt32(value);
        }

        #endregion

        public T AutoConvert<T>(SqlDataReader reader) where T : new()
        {
            T ret = new T();
            for (int i = 0; i < reader.FieldCount; i++)
            {
                var columnName = reader.GetName(i);

                PropertyInfo pi = typeof(T).GetProperty(columnName);

                object v = reader[columnName];

                if (v != DBNull.Value)
                {
                    pi.SetValue(ret, Convert.ChangeType(v, pi.PropertyType), null);
                }
            }

            return ret;
        }
    }
}
