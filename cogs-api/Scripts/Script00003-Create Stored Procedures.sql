/****** Object:  StoredProcedure [dbo].[AddSessionSwitch]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddSessionSwitch]
    @FromUserId INT,
    @ToUserId INT,
    @SessionId [int],
    @ForSessionId [int],
    @Type [int]
AS
BEGIN
    
    SET NOCOUNT ON
    
    	INSERT INTO dbo.SessionSwitches
    	(
    	    FromUserId
    	  , ToUserId
    	  , SessionId
    	  , CreatedTime
    	  , Status
    	)
    	VALUES
    	(
    	    @FromUserId
    	  , @ToUserId
    	  , @SessionId
    	  , getdate()
    	  , N'Pending'       
    	)
    
    	IF @Type = 2
    	BEGIN
    	    INSERT INTO dbo.SessionSwitches
    	    (
    	        FromUserId
    	      , ToUserId
    	      , SessionId
    	      , CreatedTime
    	      , Status
    	      , RelatedSessionSwitchId
    	    )
    	    VALUES
    	    (
    	        @FromUserId
    	      , @ToUserId 
    	      , @ForSessionId
    	      , getdate() 
    	      , N'Pending'
    	      , scope_identity()
    	    )
    	END
END
GO
/****** Object:  StoredProcedure [dbo].[ApplicationDelete]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ApplicationDelete]
    @applicationId INT
AS
BEGIN
    	SET NOCOUNT ON;
    DELETE dbo.Applications 
    WHERE Id = @applicationId
END
GO
/****** Object:  StoredProcedure [dbo].[ApplicationGetAll]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ApplicationGetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Applications
END
GO
/****** Object:  StoredProcedure [dbo].[ApplicationGetById]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ApplicationGetById]
    @applicationId INT
AS
BEGIN
    	SET NOCOUNT ON;
    SELECT * FROM dbo.Applications a
    WHERE a.Id = @applicationId
END
GO
/****** Object:  StoredProcedure [dbo].[ApplicationUpsert]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ApplicationUpsert]
    @Id [int],
    @School [nvarchar](max),
    @Major [nvarchar](max),
    @Topics [nvarchar](max),
    @Essay [nvarchar](max),
    @FirstTimer [bit],
    @HowManyYears [int],
    @AcceptedByCodemash [bit],
    @AcceptedByApplicant [bit],
    @Registered [bit]
AS
BEGIN
    	
    IF @Id is null OR @Id = -1
    BEGIN
    --Insert
    		INSERT INTO dbo.Applications
    		(
    		  School
    		  , Major
    		  , Topics
    		  , Essay
    		  , SubmitDate
    		  , FirstTimer
    		  , HowManyYears
    		  , AcceptedByCodemash
    		  , AcceptedByApplicant
    		  , Registered
    		)
    		VALUES
    		(
    		  @School
    		  , @Major 
    		  , @Topics
    		  , @Essay 
    		  , GETDATE()
    		  , @FirstTimer 
    		  , @HowManyYears 
    		  , @AcceptedByCodemash 
    		  , @AcceptedByApplicant 
    		  , @Registered 
    		)
    END
    ELSE
    BEGIN
    --Update
    			UPDATE dbo.Applications
    				SET School = @School
    		  , Major = @Major
    		  , Topics = @Topics
    		  , Essay = @Essay
    		  , FirstTimer = @FirstTimer
    		  , HowManyYears = @HowManyYears
    		  , AcceptedByCodemash = @AcceptedByCodemash
    		  , AcceptedByApplicant = @AcceptedByApplicant
    		  , Registered = @Registered
    		  WHERE id = @Id
    
    END
    
END
GO
/****** Object:  StoredProcedure [dbo].[AutoAssignUsersToSessions]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AutoAssignUsersToSessions]
AS
BEGIN
    
    SET NOCOUNT ON;
    
    DECLARE @SessionId INT
    DECLARE @UserId INT
    DECLARE @Msg VARCHAR(1000)
    DECLARE @UnableToAssign TABLE(SessionId INT)
    
    SELECT @SessionId = s.Id FROM dbo.Sessions s
    		INNER JOIN dbo.SessionTypes st 
    		ON st.Id = s.SessionType_Id
    WHERE s.SessionType_Id IN (SELECT Id FROM dbo.SessionTypes st WHERE Name IN ('General Session', 'Static Session', 'Pre-Compiler', 'PreCompiler', 'Sponsor Session'))  
    AND isnull(s.VolunteersRequired,1) > (SELECT count(*) FROM dbo.UserSessions su WHERE su.SessionId = s.Id)
    AND s.Id NOT IN (SELECT uta.SessionId FROM @UnableToAssign uta)
    	AND s.VolunteersRequired <> 99
    ORDER BY st.Priority, s.SessionStartTime DESC
    
    WHILE @SessionId IS NOT NULL
    BEGIN
    	SET @UserId = NULL 
    	SELECT TOP 1 @UserId = anu.Id
    	FROM dbo.Users anu
    	INNER JOIN dbo.UserRoles anur
    		ON anur.UserId = anu.Id
    	INNER JOIN dbo.Roles anr
    		ON anr.Id = anur.RoleId
    	LEFT JOIN dbo.UserSessions su
    		ON su.UserId = anu.Id
    	LEFT JOIN dbo.Sessions s
    		ON s.Id = su.SessionId
    	WHERE anr.Name = 'Volunteers'
    	AND dbo.HasCollision(@SessionId, anu.Id) = 0
    		AND dbo.HasException(@SessionId, anu.Id) = 0
    	GROUP BY anu.Id
    	ORDER BY sum(isnull(datediff(SECOND, s.SessionStartTime, s.SessionEndTime),0))
    
    	
    	IF @UserId IS NOT NULL
    	BEGIN
    		INSERT INTO dbo.UserSessions
    		(
    			SessionId
    			, UserId
    		)
    		VALUES
    		(
    			@SessionId   -- Session_Id - int
    			, @UserId -- User_Id - nvarchar(128)
    		)	
    		SET @Msg = 'Assigned session ' + CAST(@SessionId AS VARCHAR(20)) + ' to user ' + @UserId
    		RAISERROR (@Msg, 0, 0)
    	END
    	ELSE
    	BEGIN
    		INSERT INTO  @UnableToAssign
    		(
    			SessionId
    		)
    		VALUES
    		(
    			@SessionId -- SessionId - int
    		)
    		SET @Msg = 'Could not assign session ' + CAST(@SessionId AS VARCHAR(20)) + ' to any user.'
    		RAISERROR (@Msg, 0, 0)
    	END
    	SET @SessionId = NULL 
    	SELECT @SessionId = s.Id FROM dbo.Sessions s
    		        INNER JOIN dbo.SessionTypes st 
    		        ON st.Id = s.SessionType_Id
    WHERE s.SessionType_Id IN (SELECT Id FROM dbo.SessionTypes st WHERE Name IN ('General Session', 'Static Session', 'Pre-Compiler', 'PreCompiler', 'Sponsor Session'))  
    AND isnull(s.VolunteersRequired,1) > (SELECT count(*) FROM dbo.UserSessions su WHERE su.SessionId = s.Id)
    AND s.Id NOT IN (SELECT uta.SessionId FROM @UnableToAssign uta)
    	        AND s.VolunteersRequired <> 99
    ORDER BY st.Priority, s.SessionStartTime DESC
    END
    
END
GO
/****** Object:  StoredProcedure [dbo].[InsertDBError]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InsertDBError]
	@SourceServer VARCHAR(100),
	@SourceDatabase VARCHAR(100),
	@SourceObject VARCHAR(100),
	@ErrorNumber INT,
	@ErrorSeverity INT,
	@ErrorState INT,
	@ErrorLine INT,
	@ErrorMessage VARCHAR(255)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO dbo.Error(SourceServer,SourceDatabase,SourceObject,ErrorNumber,ErrorSeverity,ErrorState,ErrorLine,ErrorMessage)
	VALUES(@SourceServer,@SourceDatabase,@SourceObject,@ErrorNumber,@ErrorSeverity,@ErrorState,@ErrorLine,@ErrorMessage)
	RETURN scope_identity()
END
GO
/****** Object:  StoredProcedure [dbo].[MarkAsCancelled]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:      Name
-- Create Date: 
-- Description: 
-- =============================================
CREATE PROCEDURE [dbo].[MarkAsCancelled]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    -- Insert statements for procedure here
    UPDATE dbo.Sessions
		 SET Cancelled = 1
		 WHERE SessionType_Id NOT IN (6) and FeedSessionId NOT IN (SELECT FeedSessionId FROM sessionsimport)

	TRUNCATE TABLE sessionsimport

END
GO
/****** Object:  StoredProcedure [dbo].[RoleAddUser]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleAddUser]
    @userId int,
    @roleId int
AS
BEGIN
    	SET NOCOUNT ON;
    	INSERT INTO dbo.UserRoles
    	    (UserId, RoleId)
    	VALUES
			(@userId, @roleId)
END
GO
/****** Object:  StoredProcedure [dbo].[RoleDelete]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleDelete]
    @roleId INT
AS
BEGIN
    SET NOCOUNT ON;
    DELETE FROM dbo.Roles WHERE Id = @roleId
END
GO
/****** Object:  StoredProcedure [dbo].[RoleGetAll]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleGetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Roles
END
GO
/****** Object:  StoredProcedure [dbo].[RoleGetById]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleGetById]
    @roleId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Roles WHERE Id = @roleId
END
GO
/****** Object:  StoredProcedure [dbo].[RoleGetByName]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleGetByName]
    @roleName [nvarchar](max)
AS
BEGIN
	SET NOCOUNT ON;
    SELECT * FROM dbo.Roles WHERE Name = @roleName
END
GO
/****** Object:  StoredProcedure [dbo].[RoleGetUsersById]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleGetUsersById]
    @roleId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Users anu 
    	INNER JOIN dbo.UserRoles anur
    	ON anur.UserId = anu.Id
    	WHERE anur.RoleId = @roleId
END
GO
/****** Object:  StoredProcedure [dbo].[RoleGetUsersByName]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleGetUsersByName]
    @roleName [nvarchar](max)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Users anu 
    	INNER JOIN dbo.UserRoles anur
    		ON anur.UserId = anu.Id
    	INNER JOIN dbo.Roles anr
    		ON anr.Id = anur.RoleId
    	WHERE anr.Name = @roleName
END
GO
/****** Object:  StoredProcedure [dbo].[RoleRemoveUser]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoleRemoveUser]
    @userId int,
    @roleId int
AS
BEGIN
    SET NOCOUNT ON;
    DELETE dbo.UserRoles WHERE UserId = @userId AND RoleId = @roleId
END
GO
/****** Object:  StoredProcedure [dbo].[RoomGetAll]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoomGetAll]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Rooms Order By Name
END
GO
/****** Object:  StoredProcedure [dbo].[RoomGetBySessionId]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[RoomGetBySessionId]
    @SessionId [int]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Rooms r
    	INNER JOIN dbo.SessionRooms sr
    		ON sr.Room_Id = r.Id
    WHERE sr.Session_Id = @SessionId
END
GO
/****** Object:  StoredProcedure [dbo].[ScheduleExceptionGetAll]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ScheduleExceptionGetAll]
AS
BEGIN
    
    SET NOCOUNT ON
    
    SELECT se.Id
		, se.StartTime
		, se.EndTime
		, se.UserId
    FROM dbo.ScheduleExceptions se
    
END
GO
/****** Object:  StoredProcedure [dbo].[SessionAssignUser]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionAssignUser]
    @UserId [INT],
    @SessionId [INT]
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO dbo.UserSessions
	    (UserId, SessionId)
    VALUES
		(@UserId,@SessionId)
END
GO
/****** Object:  StoredProcedure [dbo].[SessionGetAll]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionGetAll]
AS
BEGIN
    SET NOCOUNT ON;
	SELECT
		s.Id
		, s.FeedSessionId
		, s.SessionTime
		, s.SessionStartTime
		, s.SessionEndTime
		, CASE WHEN s.Cancelled = 1 THEN '[CANCELLED] ' + s.Title ELSE s.Title END AS Title
		, s.Abstract
		, s.Category
		, s.VolunteersRequired
		, s.ActualSessionStartTime
		, s.ActualSessionEndTime
		, s.Attendees10
		, s.Attendees50
		, s.Notes
		, s.SessionType_Id
    FROM dbo.Sessions s
END
GO
/****** Object:  StoredProcedure [dbo].[SessionGetAllForUser]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionGetAllForUser]
    @UserId INT
AS
BEGIN
    
    SET NOCOUNT ON;
    SELECT
    	s.Id
		, s.FeedSessionId
		, s.SessionTime
		, s.SessionStartTime
		, s.SessionEndTime
		, CASE WHEN s.Cancelled = 1 THEN '[CANCELLED] ' + s.Title ELSE s.Title END AS Title
		, s.Abstract
		, s.Category
		, s.VolunteersRequired
		, s.ActualSessionStartTime
		, s.ActualSessionEndTime
		, s.Attendees10
		, s.Attendees50
		, s.Notes
    	, s.SessionType_Id
    	FROM dbo.Sessions s
    		LEFT JOIN dbo.UserSessions us
    		ON us.SessionId = s.Id
    	WHERE us.UserId = @UserId OR s.VolunteersRequired = 99
    
END
GO
/****** Object:  StoredProcedure [dbo].[SessionGetAllInfo]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionGetAllInfo]
AS
BEGIN
    	    SET NOCOUNT ON;
    
    SELECT * FROM dbo.SessionTypes st
    
    SELECT r.*, sr.Session_Id FROM dbo.Rooms r
    INNER JOIN dbo.SessionRooms sr
    	ON sr.Room_Id = r.Id
    	
    
    SELECT s.*, ss.Session_Id FROM dbo.Speakers s
    	INNER JOIN dbo.SpeakerSessions ss
    		ON ss.Speaker_Id = s.Id
    	
    
    SELECT t.*, ts.Session_Id FROM dbo.Tags t
    	INNER JOIN dbo.TagSessions ts
    		ON ts.Tag_Id = t.Id
    	
    
    SELECT * FROM dbo.UserCheckIns uci
    	
    
    SELECT anu.*, us.SessionId FROM dbo.Users anu
    	INNER JOIN dbo.UserSessions us
    		ON us.UserId = anu.Id
    	UNION
    	SELECT anu.*, us.Id AS Session_Id FROM dbo.Users anu
    	CROSS JOIN dbo.Sessions us
    		WHERE us.VolunteersRequired = 99
END
GO
/****** Object:  StoredProcedure [dbo].[SessionGetById]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionGetById]
    @SessionId [int]
AS
BEGIN
    
    SET NOCOUNT ON;
    SELECT
    	s.Id
		, s.FeedSessionId
		, s.SessionTime
		, s.SessionStartTime
		, s.SessionEndTime
		, CASE WHEN s.Cancelled = 1 THEN '[CANCELLED] ' + s.Title ELSE s.Title END AS Title
		, s.Abstract
		, s.Category
		, s.VolunteersRequired
		, s.ActualSessionStartTime
		, s.ActualSessionEndTime
		, s.Attendees10
		, s.Attendees50
		, s.Notes
    	, s.SessionType_Id
    	FROM dbo.Sessions s
    	WHERE Id = @SessionId
    
END
GO
/****** Object:  StoredProcedure [dbo].[SessionGetResults]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionGetResults]
AS
BEGIN
    SET NOCOUNT ON;
    
    	SELECT s.[Id]
    		  ,[FeedSessionId] AS SessionAlternateId
    		  ,[SessionStartTime]
    		  ,[SessionEndTime]
    		  , r.Name AS Rooms
    		  ,[Title]
    		  , st.Name AS SessionType
    		  , uci.CheckInTime AS ProctorCheckInTime
    		  ,[ActualSessionStartTime]
    		  ,[ActualSessionEndTime]
    		  ,[Attendees10]
    		  ,[Attendees50]
    		  ,[Notes]
    	  FROM [Sessions] s
    		INNER JOIN dbo.SessionTypes st
    			ON st.Id = s.SessionType_Id
    		LEFT JOIN dbo.UserCheckIns uci
    			ON uci.SessionId = s.Id AND uci.CheckInTime IS NOT NULL
    		LEFT JOIN dbo.SessionRooms sr
    			ON sr.Session_Id = s.Id
    		LEFT JOIN dbo.Rooms r
    			ON r.Id = sr.Room_Id
    			WHERE st.Name IN ('General Session', 'Pre-Compiler', 'PreCompiler', 'Sponsor Session')
    			AND s.FeedSessionId IS NOT NULL
END
GO
/****** Object:  StoredProcedure [dbo].[SessionImport]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionImport]
    @Abstract [nvarchar](max) = null,
    @Category [nvarchar](max) = null,
    @Id [int],
    @FeedSessionId [int] = null,
    @SessionEndTime [datetime] = null,
    @SessionStartTime [datetime] = null,
    @SessionTime [datetime] = null,
    @SessionType [nvarchar](max) = null,
    @Title [nvarchar](max) = null,
    @Rooms [nvarchar](max) = null,
    @Tags [nvarchar](max) = null,
    @Speakers [nvarchar](max) = null,
    @ActualSessionStartTime [DATETIME] = null,
    @ActualSessionEndTime [datetime] = null,
    @Attendees10 [int] = 0,
    @Attendees50 [int] = 0,
    @Notes [nvarchar](max) = null,
    @VolunteersRequired [INT] = 1
AS
BEGIN
    
    SET NOCOUNT ON;
    	
    	DECLARE @SessionId INT = NULL
    	DECLARE @SessionTypeId INT
    
    	SELECT @SessionTypeId = Id FROM dbo.SessionTypes st WHERE st.Name = @SessionType
    		IF @SessionTypeId IS NULL
    		BEGIN
    		    INSERT INTO dbo.SessionTypes ( Name ) VALUES ( @SessionType )
    			SET @SessionTypeId = scope_identity()
    		END
    
    	--Add session type if it does not exist
    	IF @SessionTypeId IS NULL
    	BEGIN
    		INSERT INTO dbo.SessionTypes (Name)
    		VALUES (@SessionType)
    		SET @SessionTypeId = @@identity
    	END 
    
    		--INSERT
    		INSERT INTO dbo.SessionsImport
    		(
    		    FeedSessionId
    		  , SessionTime
    		  , SessionStartTime
    		  , SessionEndTime
    		  , Title
    		  , Abstract
    		  , Category
    		  , VolunteersRequired
    		  , SessionType_Id
    		  , Attendees10
    		  , Attendees50		  
    		)
    		VALUES
    		(
    		    @FeedSessionId         
    		  , @SessionTime
    		  , @SessionStartTime
    		  , @SessionEndTime
    		  , @Title
    		  , @Abstract
    		  , @Category
    		  , @VolunteersRequired
    		  , @SessionTypeId
    		  , 0
    		  , 0
    		)
    		SET @SessionId = @@identity
    
    	--Add room if it doesn't exist
    	INSERT INTO dbo.Rooms (Name)
    	SELECT r.RESULT FROM dbo.CSVtoTable(@Rooms,',') r
    	WHERE r.RESULT NOT IN (SELECT Name FROM dbo.Rooms)
    
   
    	--Add tags if it doesn't exist
    	INSERT INTO dbo.Tags (Name)
    	SELECT t.RESULT FROM dbo.CSVtoTable(@Tags,',') t
    	WHERE t.RESULT NOT IN (SELECT Name FROM dbo.Tags)
    
    
    	RETURN @SessionId
    
END
GO
/****** Object:  StoredProcedure [dbo].[SessionImportFromFeed]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionImportFromFeed]
    @Abstract [nvarchar](max) = null,
    @Category [nvarchar](max) = null,
    @FeedSessionId [int] = null,
    @SessionEndTime [datetime] = null,
    @SessionStartTime [datetime] = null,
    @SessionTime [datetime] = null,
    @SessionType [nvarchar](max) = null,
    @Title [nvarchar](max) = null,
    @Rooms [nvarchar](max) = null,
    @Tags [nvarchar](max) = null,
    @Speakers [nvarchar](max) = null,
    @VolunteersRequired [INT] = 1
AS
BEGIN
    
    SET NOCOUNT ON;
    	DECLARE @SessionId INT
    	DECLARE @SessionTypeId INT
    
    	SELECT @SessionTypeId = Id FROM dbo.SessionTypes st WHERE st.Name = @SessionType
    		IF @SessionTypeId IS NULL
    		BEGIN
    		    INSERT INTO dbo.SessionTypes ( Name ) VALUES ( @SessionType )
    			SET @SessionTypeId = scope_identity()
    		END
    
    
    	SELECT @SessionId = Id FROM dbo.Sessions s WHERE s.FeedSessionId = @FeedSessionId		
    
    	--Add session type if it does not exist
    	IF @SessionTypeId IS NULL
    	BEGIN
    		INSERT INTO dbo.SessionTypes (Name)
    		VALUES (@SessionType)
    		SET @SessionTypeId = scope_identity()
    	END 
    
    	IF @SessionId IS NOT NULL
    	BEGIN
    		--UPDATE
    		UPDATE [dbo].[Sessions]
    		   SET Abstract = @Abstract
    			  ,Category = @Category
    			  ,SessionEndTime = @SessionEndTime
    			  ,SessionStartTime = @SessionStartTime
    			  ,SessionTime = @SessionTime
    			  ,SessionType_Id = @SessionTypeId
    			  ,Title = @Title			
    			  ,VolunteersRequired = @VolunteersRequired
    		 WHERE Id = @SessionId
    	END
    	ELSE
    	BEGIN
    		--INSERT
    		INSERT INTO dbo.Sessions
    		(
    		    FeedSessionId
    		  , SessionTime
    		  , SessionStartTime
    		  , SessionEndTime
    		  , Title
    		  , Abstract
    		  , Category
    		  , VolunteersRequired
    		  , SessionType_Id
    		  , Attendees10
    		  , Attendees50		  
    		)
    		VALUES
    		(
    		    @FeedSessionId         
    		  , @SessionTime
    		  , @SessionStartTime
    		  , @SessionEndTime
    		  , @Title
    		  , @Abstract
    		  , @Category
    		  , @VolunteersRequired
    		  , @SessionTypeId
    		  , 0
    		  , 0
    		)
    		SET @SessionId = scope_identity()
    	END
    
    	--Add room if it doesn't exist
    	INSERT INTO dbo.Rooms (Name)
    	SELECT r.RESULT FROM dbo.CSVtoTable(@Rooms,',') r
    	WHERE r.RESULT NOT IN (SELECT Name FROM dbo.Rooms)
    
    	--INSERT ROOMS
    	INSERT INTO dbo.SessionRooms
    	( Session_Id, Room_Id)
    	SELECT @SessionId, r.Id FROM dbo.CSVtoTable(@Rooms,',') cvt
    			INNER JOIN dbo.Rooms r ON r.Name = cvt.RESULT
    		WHERE r.Id NOT IN (SELECT sr.Room_Id FROM dbo.SessionRooms sr WHERE sr.Session_Id = @SessionId)
    
    	--DELETE ROOMS
    	DELETE dbo.SessionRooms WHERE Session_Id = @SessionId AND Room_Id IN (
    	SELECT sr.Room_Id FROM dbo.SessionRooms sr WHERE sr.Session_Id = @SessionId
    		AND sr.Room_Id NOT IN (SELECT r.Id FROM dbo.CSVtoTable(@Rooms,',') cvt INNER JOIN dbo.Rooms r ON r.Name = cvt.RESULT))
    
    
    	--Add tags if it doesn't exist
    	INSERT INTO dbo.Tags (Name)
    	SELECT t.RESULT FROM dbo.CSVtoTable(@Tags,',') t
    	WHERE t.RESULT NOT IN (SELECT Name FROM dbo.Tags)
    
    	--INSERT Tags
    	INSERT INTO dbo.TagSessions
    	( Session_Id, Tag_Id)
    	SELECT @SessionId, r.Id FROM dbo.CSVtoTable(@Tags,',') cvt
    			INNER JOIN dbo.Tags r ON r.Name = cvt.RESULT
    		WHERE r.Id NOT IN (SELECT sr.Tag_Id FROM dbo.TagSessions sr WHERE sr.Session_Id = @SessionId)
    
    	--DELETE Tags
    	DELETE dbo.TagSessions WHERE Session_Id = @SessionId AND Tag_Id IN (
    	SELECT sr.Tag_Id FROM dbo.TagSessions sr WHERE sr.Session_Id = @SessionId
    		AND sr.Tag_Id NOT IN (SELECT r.Id FROM dbo.CSVtoTable(@Tags,',') cvt INNER JOIN dbo.Tags r ON r.Name = cvt.RESULT))
    
    	--INSERT Speakers
    	INSERT INTO dbo.SpeakerSessions	
    	( Session_Id, Speaker_Id)
    	SELECT @SessionId, r.Id FROM dbo.CSVtoTable(@Speakers,',') cvt
    			INNER JOIN dbo.Speakers r ON r.Id = cvt.RESULT
    		WHERE r.Id NOT IN (SELECT sr.Speaker_Id FROM dbo.SpeakerSessions sr WHERE sr.Session_Id = @SessionId)
    
    	--DELETE Speakers
    	DELETE dbo.SpeakerSessions WHERE Session_Id = @SessionId AND Speaker_Id IN (
    	SELECT sr.Speaker_Id FROM dbo.SpeakerSessions sr WHERE sr.Session_Id = @SessionId
    		AND sr.Speaker_Id NOT IN (SELECT r.Id FROM dbo.CSVtoTable(@Speakers,',') cvt INNER JOIN dbo.Speakers r ON r.Id = cvt.RESULT))
    
    	RETURN @SessionId
    
END
GO
/****** Object:  StoredProcedure [dbo].[SessionTypeGetBySessionId]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionTypeGetBySessionId]
    @SessionTypeId [int]
AS
BEGIN
    
    SET NOCOUNT ON;
    SELECT * FROM dbo.SessionTypes st
    WHERE st.Id = @SessionTypeId
END
GO
/****** Object:  StoredProcedure [dbo].[SessionUnassignUser]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionUnassignUser]
    @UserId INT,
    @SessionId [int]
AS
BEGIN
    SET NOCOUNT ON;
    DELETE dbo.UserSessions WHERE SessionId = @SessionId AND UserId = @UserId
END
GO
/****** Object:  StoredProcedure [dbo].[SessionUpsert]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SessionUpsert]
    @Abstract [nvarchar](max) = null,
    @Category [nvarchar](max) = null,
    @Id [int],
    @FeedSessionId [int] = null,
    @SessionEndTime [datetime] = null,
    @SessionStartTime [datetime] = null,
    @SessionTime [datetime] = null,
    @SessionType [nvarchar](max) = null,
    @Title [nvarchar](max) = null,
    @Rooms [nvarchar](max) = null,
    @Tags [nvarchar](max) = null,
    @Speakers [nvarchar](max) = null,
    @ActualSessionStartTime [DATETIME] = null,
    @ActualSessionEndTime [datetime] = null,
    @Attendees10 [int] = 0,
    @Attendees50 [int] = 0,
    @Notes [nvarchar](max) = null,
    @VolunteersRequired [INT] = 1
AS
BEGIN
    
    SET NOCOUNT ON;
    	
    	DECLARE @SessionId INT = NULL
    	DECLARE @SessionTypeId INT
    
    	SELECT @SessionTypeId = Id FROM dbo.SessionTypes st WHERE st.Name = @SessionType
    		IF @SessionTypeId IS NULL
    		BEGIN
    		    INSERT INTO dbo.SessionTypes ( Name ) VALUES ( @SessionType )
    			SET @SessionTypeId = scope_identity()
    		END
    
    
    	IF @FeedSessionId <> 0 AND @FeedSessionId IS NOT NULL
    	BEGIN
    		SELECT @SessionId = Id FROM dbo.Sessions s WHERE s.FeedSessionId = @FeedSessionId		
    	END
    	ELSE
    	BEGIN
    		IF(@Id = 0 OR @Id = NULL)
    		BEGIN
    			SELECT @SessionId = NULL
    		END
    		ELSE
    		BEGIN
    			SELECT @SessionId = @Id
    		END
    	END 
    
    	--Add session type if it does not exist
    	IF @SessionTypeId IS NULL
    	BEGIN
    		INSERT INTO dbo.SessionTypes (Name)
    		VALUES (@SessionType)
    		SET @SessionTypeId = @@identity
    	END 
    
    	IF @SessionId IS NOT NULL
    	BEGIN
    		--UPDATE
    		UPDATE [dbo].[Sessions]
    		   SET Abstract = @Abstract
    			  ,Category = @Category
    			  ,SessionEndTime = @SessionEndTime
    			  ,SessionStartTime = @SessionStartTime
    			  ,SessionTime = @SessionTime
    			  ,SessionType_Id = @SessionTypeId
    			  ,Title = @Title			
    			  ,ActualSessionStartTime = @ActualSessionStartTime
    			  ,ActualSessionEndTime = @ActualSessionEndTime
    			  ,Attendees10 = @Attendees10
    			  ,Attendees50 = @Attendees50  
    			  ,Notes =@Notes
    			  ,VolunteersRequired = @VolunteersRequired
    		 WHERE Id = @Id
    	END
    	ELSE
    	BEGIN
    		--INSERT
    		INSERT INTO dbo.Sessions
    		(
    		    FeedSessionId
    		  , SessionTime
    		  , SessionStartTime
    		  , SessionEndTime
    		  , Title
    		  , Abstract
    		  , Category
    		  , VolunteersRequired
    		  , SessionType_Id
    		  , Attendees10
    		  , Attendees50		  
    		)
    		VALUES
    		(
    		    @FeedSessionId         
    		  , @SessionTime
    		  , @SessionStartTime
    		  , @SessionEndTime
    		  , @Title
    		  , @Abstract
    		  , @Category
    		  , @VolunteersRequired
    		  , @SessionTypeId
    		  , 0
    		  , 0
    		)
    		SET @SessionId = @@identity
    	END
    
    	--Add room if it doesn't exist
    	INSERT INTO dbo.Rooms (Name)
    	SELECT r.RESULT FROM dbo.CSVtoTable(@Rooms,',') r
    	WHERE r.RESULT NOT IN (SELECT Name FROM dbo.Rooms)
    
    	--INSERT ROOMS
    	INSERT INTO dbo.SessionRooms
    	( Session_Id, Room_Id)
    	SELECT @SessionId, r.Id FROM dbo.CSVtoTable(@Rooms,',') cvt
    			INNER JOIN dbo.Rooms r ON r.Name = cvt.RESULT
    		WHERE r.Id NOT IN (SELECT sr.Room_Id FROM dbo.SessionRooms sr WHERE sr.Session_Id = @SessionId)
    
    	--DELETE ROOMS
    	DELETE dbo.SessionRooms WHERE Session_Id = @SessionId AND Room_Id IN (
    	SELECT sr.Room_Id FROM dbo.SessionRooms sr WHERE sr.Session_Id = @SessionId
    		AND sr.Room_Id NOT IN (SELECT r.Id FROM dbo.CSVtoTable(@Rooms,',') cvt INNER JOIN dbo.Rooms r ON r.Name = cvt.RESULT))
    
    
    	--Add tags if it doesn't exist
    	INSERT INTO dbo.Tags (Name)
    	SELECT t.RESULT FROM dbo.CSVtoTable(@Tags,',') t
    	WHERE t.RESULT NOT IN (SELECT Name FROM dbo.Tags)
    
    	--INSERT Tags
    	INSERT INTO dbo.TagSessions
    	( Session_Id, Tag_Id)
    	SELECT @SessionId, r.Id FROM dbo.CSVtoTable(@Tags,',') cvt
    			INNER JOIN dbo.Tags r ON r.Name = cvt.RESULT
    		WHERE r.Id NOT IN (SELECT sr.Tag_Id FROM dbo.TagSessions sr WHERE sr.Session_Id = @SessionId)
    
    	--DELETE Tags
    	DELETE dbo.TagSessions WHERE Session_Id = @SessionId AND Tag_Id IN (
    	SELECT sr.Tag_Id FROM dbo.TagSessions sr WHERE sr.Session_Id = @SessionId
    		AND sr.Tag_Id NOT IN (SELECT r.Id FROM dbo.CSVtoTable(@Tags,',') cvt INNER JOIN dbo.Tags r ON r.Name = cvt.RESULT))
    
    	--INSERT Speakers
    	INSERT INTO dbo.SpeakerSessions	
    	( Session_Id, Speaker_Id)
    	SELECT @SessionId, r.Id FROM dbo.CSVtoTable(@Speakers,',') cvt
    			INNER JOIN dbo.Speakers r ON r.Id = cvt.RESULT
    		WHERE r.Id NOT IN (SELECT sr.Speaker_Id FROM dbo.SpeakerSessions sr WHERE sr.Session_Id = @SessionId)
    
    	--DELETE Speakers
    	DELETE dbo.SpeakerSessions WHERE Session_Id = @SessionId AND Speaker_Id IN (
    	SELECT sr.Speaker_Id FROM dbo.SpeakerSessions sr WHERE sr.Session_Id = @SessionId
    		AND sr.Speaker_Id NOT IN (SELECT r.Id FROM dbo.CSVtoTable(@Speakers,',') cvt INNER JOIN dbo.Speakers r ON r.Id = cvt.RESULT))
    
    	RETURN @SessionId
    
END
GO
/****** Object:  StoredProcedure [dbo].[SpeakerGetBySessionId]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SpeakerGetBySessionId]
    @SessionId [int]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Speakers s
    	INNER JOIN dbo.SpeakerSessions ss
    		ON ss.Speaker_Id = s.Id
    WHERE ss.Session_Id = @SessionId
END
GO
/****** Object:  StoredProcedure [dbo].[SpeakerUpsert]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SpeakerUpsert]
    @Biography [nvarchar](max) = 'null',
    @BlogUrl [nvarchar](max) = 'null',
    @FirstName [nvarchar](max) = 'null',
    @GitHubLink [nvarchar](max) = 'null',
    @GravatarUrl [nvarchar](max) = 'null',
    @Id [nvarchar](max),
    @LastName [nvarchar](max) = 'null',
    @LinkedInProfile [nvarchar](max) = 'null',
    @TwitterLink [nvarchar](max) = 'null'
AS
BEGIN
    SET NOCOUNT ON;
    IF (SELECT 1 FROM Speakers WHERE Id = @Id) = 1
    BEGIN
    	--UPDATE
    	UPDATE [dbo].[Speakers]
    		SET [FirstName] = @FirstName
    			,[LastName] = @LastName
    			,[Biography] = @Biography
    			,[GravatarUrl] = @GravatarUrl
    			,[TwitterLink] = @TwitterLink
    			,[GitHubLink] = @GitHubLink
    			,[LinkedInProfile] = @LinkedInProfile
    			,[BlogUrl] = @BlogUrl
    		WHERE Id = @Id
    END
    ELSE
    BEGIN
    	--INSERT
    	INSERT INTO dbo.Speakers
    	(
    		Id
    		, FirstName
    		, LastName
    		, Biography
    		, GravatarUrl
    		, TwitterLink
    		, GitHubLink
    		, LinkedInProfile
    		, BlogUrl
    	)
    	VALUES
    	(
    		@Id
    		, @FirstName
    		, @LastName
    		, @Biography
    		, @GravatarUrl
    		, @TwitterLink
    		, @GitHubLink
    		, @LinkedInProfile
    		, @BlogUrl
    	)
    END
END
GO
/****** Object:  StoredProcedure [dbo].[TagGetBySessionId]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TagGetBySessionId]
    @SessionId [int]
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Rooms r
    	INNER JOIN dbo.SessionRooms sr
    		ON sr.Room_Id = r.Id
    WHERE sr.Session_Id = @SessionId
END
GO
/****** Object:  StoredProcedure [dbo].[UserCheckInGetBySessionId]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserCheckInGetBySessionId]
    @SessionId [int]
AS
BEGIN
	SET NOCOUNT ON;
    SELECT * FROM dbo.UserCheckIns uci
    WHERE uci.SessionId = @SessionId
END
GO
/****** Object:  StoredProcedure [dbo].[UserCheckInUpsert]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserCheckInUpsert]
    @SessionId [int],
    @UserId INT,
    @CheckInTime [datetime]
AS
BEGIN
    
    SET NOCOUNT ON
    	IF (SELECT count(*) FROM dbo.UserCheckIns uci WHERE uci.UserId = @UserId AND uci.SessionId = @SessionId) > 0
    	BEGIN
    		--UPDATE
    		UPDATE dbo.UserCheckIns
    			SET CheckInTime = @CheckInTime
    			WHERE UserId = @UserId AND SessionId = @SessionId
    	END
    	ELSE
    	BEGIN
    		--INSERT
    		INSERT dbo.UserCheckIns
    		(
    			SessionId
    		  , UserId
    		  , CheckInTime
    		)
    		VALUES
    		(
    			@SessionId         -- SessionId - int
    		  , @UserId       -- UserId - nvarchar(128)
    		  , @CheckInTime -- CheckInTime - datetime
    		)
    
    	END
    
END
GO
/****** Object:  StoredProcedure [dbo].[UserDelete]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserDelete]
    @userId INT
AS
BEGIN
    
    SET NOCOUNT ON;
    SELECT * INTO #user FROM dbo.Users anu WHERE Id = @userId
    DELETE FROM dbo.Users WHERE Id = @userId
    SELECT * FROM #user
END
GO
/****** Object:  StoredProcedure [dbo].[UserGetAll]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserGetAll]
AS
BEGIN
	SET NOCOUNT ON;
    SELECT * FROM dbo.Users anu
END
GO
/****** Object:  StoredProcedure [dbo].[UserGetById]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserGetById]
    @userId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM dbo.Users anu WHERE Id = @userId
END
GO
/****** Object:  StoredProcedure [dbo].[UserGetBySessionId]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserGetBySessionId]
    @SessionId [int]
AS
BEGIN
    SET NOCOUNT ON;
    IF (SELECT s.VolunteersRequired FROM dbo.Sessions s WHERE id = @SessionId) = 99
    BEGIN
    	SELECT * FROM dbo.Users anu
    END
    ELSE
    BEGIN
    	SELECT * FROM dbo.Users anu
    	INNER JOIN dbo.UserSessions us
    		ON us.UserId = anu.Id
    	WHERE us.SessionId = @SessionId    
    END  
END
GO
/****** Object:  StoredProcedure [dbo].[UserUpdate]    Script Date: 1/31/2022 1:04:14 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UserUpdate]
    @userId INT,
    @FirstName [nvarchar](max),
    @LastName [nvarchar](max),
    @Gravatar [nvarchar](max),
    @CellNumber [nvarchar](max),
    @Email [nvarchar](max),
    @UserName [nvarchar](max)
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.Users 
    	SET FirstName = @FirstName,
    		LastName = @LastName,
    		Gravatar = @Gravatar,
    		CellNumber = @CellNumber,
    		Email = @Email
    		WHERE Id = @userId
END
GO
