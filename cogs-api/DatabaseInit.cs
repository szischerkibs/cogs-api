using System;
using System.Configuration;
using System.Reflection;
using DbUp;

namespace cogs_api
{
    public static class DatabaseInit
    {
        public static void Start(string connectionString)
        {
            //Create DB if not already there
            EnsureDatabase.For.SqlDatabase(connectionString);

            var upgrader =
                DeployChanges.To
                    .SqlDatabase(connectionString)
                    .WithScriptsEmbeddedInAssembly(Assembly.GetExecutingAssembly())
                    .LogToConsole()
                    .Build();

            var result = upgrader.PerformUpgrade();

        }
    }
}
