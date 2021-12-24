--ETL_3.SQL
CREATE TABLE dbo.ORGANIZATION(
	ID_ORGANIZATION INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ORGANIZATION_NAME VARCHAR(100)
)
CREATE TABLE [dbo].[DM_PROJECT](
	[ID_PROJECT] [int] PRIMARY  KEY NOT NULL,
	[PROJECT_NAME] [varchar](100) NULL
) 

CREATE TABLE dbo.ORGANIZATION_PROJECT(
	ID_ORGANIZATION_PROJECT INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	ID_ORGANIZATION INT,
    ID_PROJECT INT
)
ALTER TABLE ORGANIZATION_PROJECT ADD FOREIGN KEY ([ID_PROJECT]) REFERENCES  DM_PROJECT([ID_PROJECT]);
ALTER TABLE ORGANIZATION_PROJECT ADD FOREIGN KEY (ID_ORGANIZATION) REFERENCES ORGANIZATION(ID_ORGANIZATION);



CREATE TABLE dbo.[DM_TIME] (
[ID_TIME] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[DATE] DATETIME
)

CREATE TABLE [dbo].[DM_ACTION](
	[ID_ACTION]  INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] [varchar](10) NULL
) 

CREATE TABLE DM_TDITEM (
ID_TDITEM  INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
[DESCRIPTION] VARCHAR(50)
)

CREATE TABLE [dbo].[DM_DEVELOPER](
	[ID_DEVELOPER] INT PRIMARY KEY IDENTITY(1,1),
	[DEVELOPER_NAME] [varchar](100) NULL
) 

CREATE TABLE DM_SEVERITY (
ID_SEVERITY INT PRIMARY KEY IDENTITY(1,1),
[DESCRIPTION] VARCHAR(50)
)



CREATE TABLE [dbo].[PROJECT_VERSION](
	ID_PROJECT_VERSION INT PRIMARY KEY IDENTITY(1,1) ,
	ID_PROJECT INT NOT NULL,
	[VERSION_NAME] [varchar](255) NULL,
	[DATE_VERSION_STR] [varchar](255) NOT NULL,
	[DATE_VERSION] DATETIME NOT NULL
)
ALTER TABLE [PROJECT_VERSION] ADD FOREIGN KEY (ID_PROJECT) REFERENCES DM_PROJECT(ID_PROJECT);


CREATE TABLE [dbo].[DM_COMMITS](
	[ID_COMMIT]  INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[ID_DEVELOPER] INT NULL,
	[ID_PROJECT] INT NULL,
	[ID_TIME] [int] NOT NULL,
	[COMMIT_DATE] DATETIME NULL,
	[COMMIT_HASH] [varchar](500) NULL
) 

ALTER TABLE [DM_COMMITS] ADD FOREIGN KEY ([ID_DEVELOPER]) REFERENCES DM_DEVELOPER([ID_DEVELOPER]);
ALTER TABLE [DM_COMMITS] ADD FOREIGN KEY ([ID_PROJECT]) REFERENCES DM_PROJECT([ID_PROJECT]);
ALTER TABLE [DM_COMMITS] ADD FOREIGN KEY ([ID_TIME]) REFERENCES DM_TIME([ID_TIME]);


CREATE TABLE [dbo].[DM_VERSION](
	[ID_VERSION]  INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[ID_PROJECT_VERSION] INT NULL,
	[ID_COMMIT] INT NULL,
) 
ALTER TABLE [DM_VERSION] ADD FOREIGN KEY ([ID_PROJECT_VERSION]) REFERENCES [PROJECT_VERSION](ID_PROJECT_VERSION);
ALTER TABLE [DM_VERSION] ADD FOREIGN KEY ([ID_COMMIT]) REFERENCES [DM_COMMITS]([ID_COMMIT]);


CREATE TABLE [dbo].[DM_RULE](
	[ID_RULE] [int] PRIMARY KEY NOT NULL,
	[RULE_NAME] [varchar](max) NULL,
	[ORIGIN_RULE_ID] [varchar](100) NULL,
	[RULE_DESCRIPTION] [varchar](max) NULL
)
/*
CREATE TABLE PROGLANGUAGE(
	[ID_PROGLANGUAGE] INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[DESCRIPTION] VARCHAR(50)
)


CREATE TABLE [PROFILE](
	[ID_PROFILE] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[LEVEL] [int] NULL,
	[ID_DEVELOPER] [int] NULL,
	[DES_GITHUB_URL] [varchar](55) NULL,
	[SALARY_HOUR] [decimal](18, 2) NULL,
	[MTBI]  INT NULL
)
ALTER TABLE [PROFILE] ADD FOREIGN KEY ([ID_DEVELOPER]) REFERENCES DM_DEVELOPER([ID_DEVELOPER]);

CREATE TABLE PROFILE_DETAIL
(
	ID_PROFILE_DETAIL INT PRIMARY KEY IDENTITY(1,1),
	[ID_PROFILE] INT,
	[ID_PROGLANGUAGE] INT,
	[LEVEL_KNOWLEGE] INT
)
ALTER TABLE PROFILE_DETAIL ADD FOREIGN KEY ([ID_PROFILE]) REFERENCES [PROFILE]([ID_PROFILE]);
ALTER TABLE PROFILE_DETAIL ADD FOREIGN KEY ([ID_PROGLANGUAGE]) REFERENCES PROGLANGUAGE([ID_PROGLANGUAGE]);


CREATE TABLE PROFILE_REMEDIATION(
	[ID_REMEDIATION] INT PRIMARY KEY IDENTITY(1,1),
	ID_RULE INT,
	MINUTES_REMEDIATION INT,
	ID_DEVELOPER INT
)
ALTER TABLE PROFILE_REMEDIATION ADD FOREIGN KEY (ID_RULE) REFERENCES DM_RULE(ID_RULE);
ALTER TABLE PROFILE_REMEDIATION ADD FOREIGN KEY (ID_DEVELOPER) REFERENCES DM_DEVELOPER(ID_DEVELOPER);
*/

CREATE TABLE [dbo].[FT_TECHNICALDEBT](
	[ID_FTECHNICALDEBT] INT PRIMARY KEY IDENTITY(1,1),
	[ID_DEVELOPER] [int] NOT NULL,
	[ID_PROJECT] [int] NOT NULL,
	[ID_RULE] [int] NOT NULL,
	[ID_ACTION] [int] NOT NULL,
	[ID_TDITEM] [int] NOT NULL,
	[ID_SEVERITY] [int] NOT NULL,
	[EFFORT] [int] NULL,
	[ID_TIME] [int]  NULL,
	[ID_VERSION] [int]  NULL,
	[IGNORE] INT DEFAULT  0
) 

ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_DEVELOPER]) REFERENCES DM_DEVELOPER([ID_DEVELOPER]);
ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_PROJECT]) REFERENCES DM_PROJECT([ID_PROJECT]);
ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_RULE]) REFERENCES DM_RULE([ID_RULE]);
ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_ACTION]) REFERENCES DM_ACTION([ID_ACTION]);
ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_TDITEM]) REFERENCES DM_TDITEM([ID_TDITEM]);
ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_SEVERITY]) REFERENCES DM_SEVERITY([ID_SEVERITY]);
ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_VERSION]) REFERENCES DM_VERSION([ID_VERSION]);
ALTER TABLE [FT_TECHNICALDEBT] ADD FOREIGN KEY ([ID_TIME]) REFERENCES DM_TIME([ID_TIME]);



CREATE TABLE [dbo].[FT_TECHNICALDEBT_IGNORE_CONDITION](
	[ID_DEVELOPER] [int]  NULL,
	[ID_PROJECT] [int]  NULL,
	[ID_RULE] [int]  NULL,
	[ID_ACTION] [int] NOT NULL,
	[ID_TDITEM] [int]  NULL,
	[ID_SEVERITY] [int]  NULL,
	[ID_TIME] [int]  NULL,
	[ID_VERSION] [int]  NULL,
) 
