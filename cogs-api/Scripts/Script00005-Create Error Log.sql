/****** Object:  Table [dbo].[Error]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Error](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SourceServer] [VARCHAR](100) NOT NULL,
	[SourceDatabase] [VARCHAR](100) NOT NULL,
	[SourceObject] [VARCHAR](100) NOT NULL,
	[ErrorNumber] [INT] NOT NULL,
	[ErrorSeverity] [INT] NOT NULL,
	[ErrorState] [INT] NOT NULL,
	[ErrorLine] [INT] NOT NULL,
	[ErrorMessage] [VARCHAR](255) NOT NULL,
	[UTCRecordTime] [DATETIMEOFFSET](7) NOT NULL,
	[EasternRecordTime]  AS (([UTCRecordTime] AT TIME ZONE 'US Eastern Standard Time')),
	[UserName] [VARCHAR](100) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Error] ADD  DEFAULT (sysutcdatetime()) FOR [UTCRecordTime]
GO

ALTER TABLE [dbo].[Error] ADD  DEFAULT (suser_sname()) FOR [UserName]
GO


/****** Object:  StoredProcedure [dbo].[InsertDBError]    Script Date: 1/31/2022 6:25:20 AM ******/
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


