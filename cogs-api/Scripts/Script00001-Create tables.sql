/****** Object:  Table [Applications]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Applications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Gender] [nvarchar](max) NULL,
	[EmailAddress] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[School] [nvarchar](max) NULL,
	[Major] [nvarchar](max) NULL,
	[Topics] [nvarchar](max) NULL,
	[Essay] [nvarchar](max) NULL,
	[SubmitDate] [nvarchar](max) NULL,
	[FirstTimer] [bit] NOT NULL,
	[HowManyYears] [int] NOT NULL,
	[AcceptedByCodemash] [bit] NOT NULL,
	[AcceptedByApplicant] [bit] NOT NULL,
	[Registered] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Applications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [AspNetRoles]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetRoles](
	[Id] [nvarchar](128) NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
	[Discriminator] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AspNetUserClaims]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUserClaims](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
	[ClaimType] [nvarchar](max) NULL,
	[ClaimValue] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.AspNetUserClaims] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [AspNetUserLogins]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUserLogins](
	[LoginProvider] [nvarchar](128) NOT NULL,
	[ProviderKey] [nvarchar](128) NOT NULL,
	[UserId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserLogins] PRIMARY KEY CLUSTERED 
(
	[LoginProvider] ASC,
	[ProviderKey] ASC,
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AspNetUserRoles]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUserRoles](
	[UserId] [nvarchar](128) NOT NULL,
	[RoleId] [nvarchar](128) NOT NULL,
 CONSTRAINT [PK_dbo.AspNetUserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [AspNetUsers]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [AspNetUsers](
	[Id] [nvarchar](128) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[ContactAddress] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[Gravatar] [nvarchar](max) NULL,
	[CellNumber] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[EmailConfirmed] [bit] NOT NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[SecurityStamp] [nvarchar](max) NULL,
	[PhoneNumber] [nvarchar](max) NULL,
	[PhoneNumberConfirmed] [bit] NOT NULL,
	[TwoFactorEnabled] [bit] NOT NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[Gender] [nvarchar](6) NULL,
	[School] [nvarchar](100) NULL,
	[Major] [nvarchar](100) NULL,
	[TopicsInterestedIn] [nvarchar](100) NULL,
	[Essay] [nvarchar](max) NULL,
	[PreviousVolunteer] [bit] NOT NULL,
	[VolunteerYears] [int] NOT NULL,
	[Accepted] [bit] NOT NULL,
	[AcceptedDate] [datetime] NULL,
	[Cancelled] [bit] NOT NULL,
	[CancelledDate] [datetime] NULL,
 CONSTRAINT [PK_dbo.AspNetUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Rooms]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Rooms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Rooms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [ScheduleExceptions]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ScheduleExceptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[User_Id] [nvarchar](128) NULL,
 CONSTRAINT [PK_dbo.ScheduleExceptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [SessionRooms]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SessionRooms](
	[Session_Id] [int] NOT NULL,
	[Room_Id] [int] NOT NULL,
 CONSTRAINT [PK_dbo.SessionRooms] PRIMARY KEY CLUSTERED 
(
	[Session_Id] ASC,
	[Room_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Sessions]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Sessions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FeedSessionId] [int] NULL,
	[SessionTime] [datetime] NULL,
	[SessionStartTime] [datetime] NULL,
	[SessionEndTime] [datetime] NULL,
	[Title] [nvarchar](max) NULL,
	[Abstract] [nvarchar](max) NULL,
	[Category] [nvarchar](max) NULL,
	[VolunteersRequired] [int] NOT NULL,
	[ActualSessionStartTime] [datetime] NULL,
	[ActualSessionEndTime] [datetime] NULL,
	[Attendees10] [int] NOT NULL,
	[Attendees50] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[SessionType_Id] [int] NULL,
	[Cancelled] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.Sessions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SessionsImport]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SessionsImport](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FeedSessionId] [int] NULL,
	[SessionTime] [datetime] NULL,
	[SessionStartTime] [datetime] NULL,
	[SessionEndTime] [datetime] NULL,
	[Title] [nvarchar](max) NULL,
	[Abstract] [nvarchar](max) NULL,
	[Category] [nvarchar](max) NULL,
	[VolunteersRequired] [int] NOT NULL,
	[ActualSessionStartTime] [datetime] NULL,
	[ActualSessionEndTime] [datetime] NULL,
	[Attendees10] [int] NOT NULL,
	[Attendees50] [int] NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[SessionType_Id] [int] NULL,
	[Cancelled] [bit] NOT NULL,
 CONSTRAINT [PK_dbo.SessionsImport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SessionSwitches]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SessionSwitches](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FromUserId] [nvarchar](max) NULL,
	[ToUserId] [nvarchar](max) NULL,
	[SessionId] [int] NOT NULL,
	[CreatedTime] [datetime] NOT NULL,
	[StatusChangeTime] [datetime] NULL,
	[Status] [nvarchar](max) NULL,
	[RelatedSessionSwitchId] [int] NULL,
 CONSTRAINT [PK_dbo.SessionSwitches] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SessionTypes]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SessionTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_dbo.SessionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [Speakers]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Speakers](
	[Id] [nvarchar](128) NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[Biography] [nvarchar](max) NULL,
	[GravatarUrl] [nvarchar](max) NULL,
	[TwitterLink] [nvarchar](max) NULL,
	[GitHubLink] [nvarchar](max) NULL,
	[LinkedInProfile] [nvarchar](max) NULL,
	[BlogUrl] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Speakers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [SpeakerSessions]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SpeakerSessions](
	[Speaker_Id] [nvarchar](128) NOT NULL,
	[Session_Id] [int] NOT NULL,
 CONSTRAINT [PK_dbo.SpeakerSessions] PRIMARY KEY CLUSTERED 
(
	[Speaker_Id] ASC,
	[Session_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Tags]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Tags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Tags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [TagSessions]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [TagSessions](
	[Tag_Id] [int] NOT NULL,
	[Session_Id] [int] NOT NULL,
 CONSTRAINT [PK_dbo.TagSessions] PRIMARY KEY CLUSTERED 
(
	[Tag_Id] ASC,
	[Session_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserCheckIns]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserCheckIns](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [int] NOT NULL,
	[UserId] [nvarchar](128) NULL,
	[CheckInTime] [datetime] NULL,
 CONSTRAINT [PK_dbo.UserCheckIns] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [UserSessions]     ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [UserSessions](
	[User_Id] [nvarchar](128) NOT NULL,
	[Session_Id] [int] NOT NULL,
 CONSTRAINT [PK_dbo.UserSessions] PRIMARY KEY CLUSTERED 
(
	[User_Id] ASC,
	[Session_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [AspNetRoles] ADD  DEFAULT ('') FOR [Discriminator]
GO
ALTER TABLE [AspNetUsers] ADD  DEFAULT ((0)) FOR [PreviousVolunteer]
GO
ALTER TABLE [AspNetUsers] ADD  DEFAULT ((0)) FOR [VolunteerYears]
GO
ALTER TABLE [AspNetUsers] ADD  DEFAULT ((0)) FOR [Accepted]
GO
ALTER TABLE [AspNetUsers] ADD  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [Sessions] ADD  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [SessionsImport] ADD  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [SessionTypes] ADD  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [AspNetUserClaims]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserClaims] CHECK CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [AspNetUserLogins]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserLogins] CHECK CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [AspNetRoles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]
GO
ALTER TABLE [AspNetUserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [AspNetUserRoles] CHECK CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [ScheduleExceptions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.ScheduleExceptions_dbo.AspNetUsers_User_Id] FOREIGN KEY([User_Id])
REFERENCES [AspNetUsers] ([Id])
GO
ALTER TABLE [ScheduleExceptions] CHECK CONSTRAINT [FK_dbo.ScheduleExceptions_dbo.AspNetUsers_User_Id]
GO
ALTER TABLE [SessionRooms]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SessionRooms_dbo.Rooms_Room_Id] FOREIGN KEY([Room_Id])
REFERENCES [Rooms] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SessionRooms] CHECK CONSTRAINT [FK_dbo.SessionRooms_dbo.Rooms_Room_Id]
GO
ALTER TABLE [SessionRooms]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SessionRooms_dbo.Sessions_Session_Id] FOREIGN KEY([Session_Id])
REFERENCES [Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SessionRooms] CHECK CONSTRAINT [FK_dbo.SessionRooms_dbo.Sessions_Session_Id]
GO
ALTER TABLE [Sessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Sessions_dbo.SessionTypes_SessionType_Id] FOREIGN KEY([SessionType_Id])
REFERENCES [SessionTypes] ([Id])
GO
ALTER TABLE [Sessions] CHECK CONSTRAINT [FK_dbo.Sessions_dbo.SessionTypes_SessionType_Id]
GO
ALTER TABLE [SpeakerSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Sessions_Session_Id] FOREIGN KEY([Session_Id])
REFERENCES [Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SpeakerSessions] CHECK CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Sessions_Session_Id]
GO
ALTER TABLE [SpeakerSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Speakers_Speaker_Id] FOREIGN KEY([Speaker_Id])
REFERENCES [Speakers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [SpeakerSessions] CHECK CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Speakers_Speaker_Id]
GO
ALTER TABLE [TagSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TagSessions_dbo.Sessions_Session_Id] FOREIGN KEY([Session_Id])
REFERENCES [Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [TagSessions] CHECK CONSTRAINT [FK_dbo.TagSessions_dbo.Sessions_Session_Id]
GO
ALTER TABLE [TagSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TagSessions_dbo.Tags_Tag_Id] FOREIGN KEY([Tag_Id])
REFERENCES [Tags] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [TagSessions] CHECK CONSTRAINT [FK_dbo.TagSessions_dbo.Tags_Tag_Id]
GO
ALTER TABLE [UserCheckIns]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserCheckIns_dbo.AspNetUsers_UserId] FOREIGN KEY([UserId])
REFERENCES [AspNetUsers] ([Id])
GO
ALTER TABLE [UserCheckIns] CHECK CONSTRAINT [FK_dbo.UserCheckIns_dbo.AspNetUsers_UserId]
GO
ALTER TABLE [UserCheckIns]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserCheckIns_dbo.Sessions_SessionId] FOREIGN KEY([SessionId])
REFERENCES [Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [UserCheckIns] CHECK CONSTRAINT [FK_dbo.UserCheckIns_dbo.Sessions_SessionId]
GO
ALTER TABLE [UserSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessions_dbo.AspNetUsers_User_Id] FOREIGN KEY([User_Id])
REFERENCES [AspNetUsers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [UserSessions] CHECK CONSTRAINT [FK_dbo.UserSessions_dbo.AspNetUsers_User_Id]
GO
ALTER TABLE [UserSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessions_dbo.Sessions_Session_Id] FOREIGN KEY([Session_Id])
REFERENCES [Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [UserSessions] CHECK CONSTRAINT [FK_dbo.UserSessions_dbo.Sessions_Session_Id]
GO
