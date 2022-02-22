using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace cogs_api.Dtos
{
    public class ApplicationCreateDto
    {
        public int UserId { get; set; }
        public string School { get; set; }
        public string Major { get; set; }
        public string Topics { get; set; }
        public string Essay { get; set; }
        public bool FirstTimer { get; set; }
        public int HowManyYears { get; set; }
    }
}
