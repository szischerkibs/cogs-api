﻿using System;
using System.Collections.Generic;

namespace cogs_api.Models
{
    public class Session
    {
        public Session()
        {
            Rooms = new List<Room>();
            Tags = new List<Tag>();
            Assignees = new List<User>();
            Speakers = new List<Speaker>();
            ProctorCheckIns = new List<UserCheckIn>();
        }

        public int Id { get; set; }
        public int FeedSessionId { get; set; }
        public DateTime? SessionTime { get; set; }
        public DateTime? SessionStartTime { get; set; }
        public DateTime? SessionEndTime { get; set; }
        public string Title { get; set; }
        public string Abstract { get; set; }
        public SessionType SessionType { get; set; }
        public string Category { get; set; }
        public int VolunteersRequired { get; set; }
        public DateTime? ActualSessionStartTime { get; set; }
        public DateTime? ActualSessionEndTime { get; set; }
        public int Attendees10 { get; set; }
        public int Attendees50 { get; set; }
        public string Notes { get; set; }
        public bool Cancelled { get; set; }
        public List<Room> Rooms { get; set; }
        public List<Tag> Tags { get; set; }
        public List<Speaker> Speakers { get; set; }
        public List<UserCheckIn> ProctorCheckIns { get; set; }
        public List<User> Assignees { get; set; }
        public int SessionType_Id { get; set; }
    }
}
