using System;
using AutoMapper;
using cogs_api.Dtos;
using cogs_api.Models;

namespace cogs_api.Profiles
{
    public class UsersProfile : Profile
    {
        public UsersProfile()
        {
            //Source --> Target
            CreateMap<User, UserReadDto>();
            CreateMap<UserCreateDto, User>();
        }
    }
}
