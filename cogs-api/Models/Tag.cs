using System;
using System.Collections.Generic;

namespace cogs_api.Models
{
    public class Tag
    {
        public Tag()
        {
            Sessions = new List<Session>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public List<Session> Sessions { get; set; }
    }
}
