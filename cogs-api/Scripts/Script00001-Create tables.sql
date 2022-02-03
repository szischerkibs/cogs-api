/****** Object:  Table [dbo].[Applications]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Applications](
	[Id] [int] IDENTITY(1,1) NOT NULL,
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
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.Applications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Error]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Error](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceServer] [varchar](100) NOT NULL,
	[SourceDatabase] [varchar](100) NOT NULL,
	[SourceObject] [varchar](100) NOT NULL,
	[ErrorNumber] [int] NOT NULL,
	[ErrorSeverity] [int] NOT NULL,
	[ErrorState] [int] NOT NULL,
	[ErrorLine] [int] NOT NULL,
	[ErrorMessage] [varchar](255) NOT NULL,
	[UTCRecordTime] [datetimeoffset](7) NOT NULL,
	[EasternRecordTime]  AS (([UTCRecordTime] AT TIME ZONE 'US Eastern Standard Time')),
	[UserName] [varchar](100) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] NOT NULL,
	[Name] [nvarchar](256) NOT NULL,
 CONSTRAINT [PK_dbo.Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rooms]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rooms](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Rooms] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ScheduleExceptions]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ScheduleExceptions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[UserId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.ScheduleExceptions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SchemaVersions]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchemaVersions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ScriptName] [nvarchar](255) NOT NULL,
	[Applied] [datetime] NOT NULL,
 CONSTRAINT [PK_SchemaVersions_Id] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SessionRooms]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SessionRooms](
	[Session_Id] [int] NOT NULL,
	[Room_Id] [int] NOT NULL,
 CONSTRAINT [PK_dbo.SessionRooms] PRIMARY KEY CLUSTERED 
(
	[Session_Id] ASC,
	[Room_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sessions]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sessions](
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
/****** Object:  Table [dbo].[SessionsImport]    Script Date: 1/31/2022 1:25:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SessionsImport](
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
/****** Object:  Table [dbo].[SessionSwitches]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SessionSwitches](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[FromUserId] [int] NULL,
	[ToUserId] [int] NULL,
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
/****** Object:  Table [dbo].[SessionTypes]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SessionTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Priority] [int] NOT NULL,
 CONSTRAINT [PK_dbo.SessionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Speakers]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Speakers](
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
/****** Object:  Table [dbo].[SpeakerSessions]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SpeakerSessions](
	[Speaker_Id] [nvarchar](128) NOT NULL,
	[Session_Id] [int] NOT NULL,
 CONSTRAINT [PK_dbo.SpeakerSessions] PRIMARY KEY CLUSTERED 
(
	[Speaker_Id] ASC,
	[Session_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tags]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tags](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.Tags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TagSessions]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TagSessions](
	[Tag_Id] [int] NOT NULL,
	[Session_Id] [int] NOT NULL,
 CONSTRAINT [PK_dbo.TagSessions] PRIMARY KEY CLUSTERED 
(
	[Tag_Id] ASC,
	[Session_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserCheckIns]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserCheckIns](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SessionId] [int] NOT NULL,
	[UserId] [int] NULL,
	[CheckInTime] [datetime] NULL,
 CONSTRAINT [PK_dbo.UserCheckIns] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserId] [int] NOT NULL,
	[RoleId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[IsActive] [bit] NOT NULL,
	[Gravatar] [nvarchar](max) NULL,
	[CellNumber] [nvarchar](max) NULL,
	[Email] [nvarchar](256) NULL,
	[PasswordHash] [nvarchar](max) NULL,
	[LockoutEndDateUtc] [datetime] NULL,
	[LockoutEnabled] [bit] NOT NULL,
	[AccessFailedCount] [int] NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[Gender] [nvarchar](6) NULL,
 CONSTRAINT [PK_dbo.Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserSessions]    Script Date: 1/31/2022 1:25:04 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserSessions](
	[UserId] [int] NOT NULL,
	[SessionId] [int] NOT NULL,
 CONSTRAINT [PK_dbo.UserSessions] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[SessionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF__AspNetUse__Previ__02084FDA]  DEFAULT ((0)) FOR [PreviousVolunteer]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF__AspNetUse__Volun__02FC7413]  DEFAULT ((0)) FOR [VolunteerYears]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF__AspNetUse__Accep__03F0984C]  DEFAULT ((0)) FOR [Accepted]
GO
ALTER TABLE [dbo].[AspNetUsers] ADD  CONSTRAINT [DF__AspNetUse__Cance__04E4BC85]  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [dbo].[Error] ADD  DEFAULT (sysutcdatetime()) FOR [UTCRecordTime]
GO
ALTER TABLE [dbo].[Error] ADD  DEFAULT (suser_sname()) FOR [UserName]
GO
ALTER TABLE [dbo].[Sessions] ADD  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [dbo].[SessionsImport] ADD  DEFAULT ((0)) FOR [Cancelled]
GO
ALTER TABLE [dbo].[SessionTypes] ADD  DEFAULT ((0)) FOR [Priority]
GO
ALTER TABLE [dbo].[Applications]  WITH CHECK ADD  CONSTRAINT [FK_Applications_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Applications] CHECK CONSTRAINT [FK_Applications_Users]
GO
ALTER TABLE [dbo].[ScheduleExceptions]  WITH CHECK ADD  CONSTRAINT [FK_ScheduleExceptions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ScheduleExceptions] CHECK CONSTRAINT [FK_ScheduleExceptions_Users]
GO
ALTER TABLE [dbo].[SessionRooms]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SessionRooms_dbo.Rooms_Room_Id] FOREIGN KEY([Room_Id])
REFERENCES [dbo].[Rooms] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SessionRooms] CHECK CONSTRAINT [FK_dbo.SessionRooms_dbo.Rooms_Room_Id]
GO
ALTER TABLE [dbo].[SessionRooms]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SessionRooms_dbo.Sessions_Session_Id] FOREIGN KEY([Session_Id])
REFERENCES [dbo].[Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SessionRooms] CHECK CONSTRAINT [FK_dbo.SessionRooms_dbo.Sessions_Session_Id]
GO
ALTER TABLE [dbo].[Sessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.Sessions_dbo.SessionTypes_SessionType_Id] FOREIGN KEY([SessionType_Id])
REFERENCES [dbo].[SessionTypes] ([Id])
GO
ALTER TABLE [dbo].[Sessions] CHECK CONSTRAINT [FK_dbo.Sessions_dbo.SessionTypes_SessionType_Id]
GO
ALTER TABLE [dbo].[SpeakerSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Sessions_Session_Id] FOREIGN KEY([Session_Id])
REFERENCES [dbo].[Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpeakerSessions] CHECK CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Sessions_Session_Id]
GO
ALTER TABLE [dbo].[SpeakerSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Speakers_Speaker_Id] FOREIGN KEY([Speaker_Id])
REFERENCES [dbo].[Speakers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[SpeakerSessions] CHECK CONSTRAINT [FK_dbo.SpeakerSessions_dbo.Speakers_Speaker_Id]
GO
ALTER TABLE [dbo].[TagSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TagSessions_dbo.Sessions_Session_Id] FOREIGN KEY([Session_Id])
REFERENCES [dbo].[Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TagSessions] CHECK CONSTRAINT [FK_dbo.TagSessions_dbo.Sessions_Session_Id]
GO
ALTER TABLE [dbo].[TagSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.TagSessions_dbo.Tags_Tag_Id] FOREIGN KEY([Tag_Id])
REFERENCES [dbo].[Tags] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TagSessions] CHECK CONSTRAINT [FK_dbo.TagSessions_dbo.Tags_Tag_Id]
GO
ALTER TABLE [dbo].[UserCheckIns]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserCheckIns_dbo.Sessions_SessionId] FOREIGN KEY([SessionId])
REFERENCES [dbo].[Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserCheckIns] CHECK CONSTRAINT [FK_dbo.UserCheckIns_dbo.Sessions_SessionId]
GO
ALTER TABLE [dbo].[UserCheckIns]  WITH CHECK ADD  CONSTRAINT [FK_UserCheckIns_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserCheckIns] CHECK CONSTRAINT [FK_UserCheckIns_Users]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.tUserRoles_dbo.Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_dbo.tUserRoles_dbo.Roles_RoleId]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserRoles_dbo.Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_dbo.UserRoles_dbo.Users_UserId]
GO
ALTER TABLE [dbo].[UserSessions]  WITH CHECK ADD  CONSTRAINT [FK_dbo.UserSessions_dbo.Sessions_Session_Id] FOREIGN KEY([SessionId])
REFERENCES [dbo].[Sessions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[UserSessions] CHECK CONSTRAINT [FK_dbo.UserSessions_dbo.Sessions_Session_Id]
GO
ALTER TABLE [dbo].[UserSessions]  WITH CHECK ADD  CONSTRAINT [FK_UserSessions_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[UserSessions] CHECK CONSTRAINT [FK_UserSessions_Users]
GO
