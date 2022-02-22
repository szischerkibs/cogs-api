using System;
using System.Collections.Generic;
using System.Linq;

namespace cogs_api.Dtos
{
    public class ApplicationReadDto
    {
        public int Id { get; set; }
        public int UserId { get; set; }
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

        public List<string> TopicsList
        {
            get
            {
                return this.Topics.Split(",").ToList();
            }
        }
    }
}
