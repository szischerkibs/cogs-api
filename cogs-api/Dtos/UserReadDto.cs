using System;
namespace cogs_api.Dtos
{
    public class UserReadDto
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string UserName { get; set; }
        public bool IsActive { get; set; }
        public string Gravatar { get; set; }
        public string CellNumber { get; set; }
        public string Email { get; set; }
        public bool LockoutEnabled { get; set; }
        public bool Accepted { get; set; }
        public DateTime? AcceptedDate { get; set; }
        public bool Cancelled { get; set; }
        public DateTime? CancelledDate { get; set; }
        public bool NeedHotel { get; set; }
        public string Gender { get; set; }        
    }
}
