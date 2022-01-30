using System;
namespace cogs_api.Models
{
    public class Application
    {
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Gender { get; set; }
        public string EmailAddress { get; set; }
        public string Phone { get; set; }
        public string School { get; set; }
        public string Major { get; set; }
        public string Topics { get; set; }
        public string Essay { get; set; }
        public string SubmitDate { get; set; }
        public bool FirstTimer { get; set; }
        public int HowManyYears { get; set; }
        public bool AcceptedByCodemash { get; set; }
        public bool AcceptedByApplicant { get; set; }
        public bool Registered { get; set; }
    }
}
