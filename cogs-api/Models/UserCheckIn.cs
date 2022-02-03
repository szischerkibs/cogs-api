using System;
namespace cogs_api.Models
{
    public class UserCheckIn
    {
        public UserCheckIn()
        {
        }

        public int Id { get; set; }
        public int SessionId { get; set; }
        public string UserId { get; set; }
        public DateTime? CheckInTime { get; set; }
    }
}
