using System;
using AutoMapper;
using cogs_api.Dtos;
using cogs_api.Models;

namespace cogs_api.Profiles
{
    public class ApplicationsProfile : Profile
    {
        public ApplicationsProfile()
        {
            //Source --> Target
            CreateMap<Application, ApplicationReadDto>();
            CreateMap<ApplicationCreateDto, Application>();
        }
    }
}
