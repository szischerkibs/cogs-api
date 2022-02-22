using System;
using AutoMapper;
using cogs_api.Dtos;
using cogs_api.Models;

namespace cogs_api.Profiles
{
    public class UserCredentialsProfile : Profile
    {
        public UserCredentialsProfile()
        {
            //Source --> Target
            CreateMap<UserCredentialLoginDto, UserCredential>();
        }
    }
}
