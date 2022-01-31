using System;
namespace cogs_api.Utilities
{
    public class CogsException : Exception
    {
        public int LogId { get; set; }
        public string ExceptionType { get { return "CogsException"; } }

        public CogsException()
        {
            LogId = 0;
        }

        public CogsException(int logId)
        {
            LogId = logId;

        }

        public CogsException(int logId, string message) : base(message)
        {
            LogId = logId;

        }

        public CogsException(int logId, string message, Exception innerException) : base(message, innerException)
        {
            LogId = logId;
        }

    }
}
