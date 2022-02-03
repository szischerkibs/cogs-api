using System;
using System.Collections.Generic;

namespace cogs_api.Models
{
    public class Room
    {
        public Room()
        {
            Sessions = new List<Session>();
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public List<Session> Sessions { get; set; }
    }
}
