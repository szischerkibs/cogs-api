using System;
namespace cogs_api.Interfaces
{
    public interface ICogsSettings
    {
        string GetConnectionString(string name);
        string GetAppSetting(string name);
    }
}
