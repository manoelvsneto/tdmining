INSERT INTO [dbo].[DM_DEVELOPER]
SELECT distinct author_name FROM Repository5.dbo.commits ORDER BY 1



DECLARE @DT_INICIO  DATETIME = '2000-01-01'
DECLARE @DT_FIM DATETIME =  GETDATE()

WHILE(@DT_INICIO <= @DT_FIM )
BEGIN
INSERT INTO dbo.[DM_TIME] ([DATE]) VALUES (@DT_INICIO)
SET @DT_INICIO = DATEADD(DAY,1,@DT_INICIO)
END



INSERT INTO  [DM_COMMITS]
           ([ID_DEVELOPER]
           ,[ID_PROJECT]
           ,[ID_TIME]
           ,[COMMIT_DATE]
           ,[COMMIT_HASH])
SELECT  DEV.ID_DEVELOPER ,P.ID_PROJECT, T.ID_TIME , CONVERT(DATETIME, C.committer_date,103), C.committer_hash  
FROM Repository5.dbo.commits c(nolock)
join DM_DEVELOPER dev (nolock)
on c.author_name COLLATE Latin1_General_CI_AS = dev.DEVELOPER_NAME COLLATE Latin1_General_CI_AS
join DM_PROJECT p (nolock)
on c.project_name COLLATE Latin1_General_CI_AS= p.project_name COLLATE Latin1_General_CI_AS
join DM_TIME  t (nolock)
on YEAR( t.[DATE]) = YEAR( CONVERT(DATETIME,c.committer_date,103))
AND MONTH( t.[DATE]) = MONTH( CONVERT(DATETIME,c.committer_date,103))
AND DAY( t.[DATE]) = DAY( CONVERT(DATETIME,c.committer_date,103))
ORDER BY C.id




INSERT INTO [dbo].[DM_ACTION] VALUES ('OPEN')
INSERT INTO [dbo].[DM_ACTION] VALUES ('CLOSED')


INSERT INTO DM_TDITEM SELECT 'CS'
INSERT INTO DM_TDITEM SELECT 'BUG'
INSERT INTO DM_TDITEM SELECT 'VUL'
INSERT INTO DM_TDITEM SELECT 'SHO'




INSERT INTO [dbo].[DM_RULE]
SELECT   ROW_NUMBER() OVER(ORDER BY name,uuid ASC) AS [id_RULE], name,uuid,plugin_rule_key FROM (
SELECT distinct name,uuid,plugin_rule_key FROM sonar5.dbo.rules
) AS Q


INSERT INTO DM_SEVERITY SELECT 'BLOCKER'
INSERT INTO DM_SEVERITY SELECT 'CRITICAL'
INSERT INTO DM_SEVERITY SELECT 'MAJOR'
INSERT INTO DM_SEVERITY SELECT 'MINOR'
INSERT INTO DM_SEVERITY SELECT 'INFO'




SELECT  
dev.ID_DEVELOPER,p.ID_PROJECT AS ID_PROJECT ,r.ID_RULE, 
ac.ID_ACTION , tdi.ID_TDITEM,  sev.ID_SEVERITY ,a.effort as EFFORT,c.ID_TIME,
vc.ID_VERSION 
INTO #FT_TECHNICALDEBT
FROM dbo.Analisys_Temp a (nolock) 
join dbo.DM_DEVELOPER dev (nolock)
on dev.DEVELOPER_NAME  COLLATE Latin1_General_CI_AS  = a.author_name COLLATE Latin1_General_CI_AS
join dbo.DM_PROJECT p (nolock)
on p.project_name COLLATE Latin1_General_CI_AS = a.project_name COLLATE Latin1_General_CI_AS
join dbo.DM_RULE r (nolock)
on r.ORIGIN_RULE_ID COLLATE Latin1_General_CI_AS = a.rule_uuid COLLATE Latin1_General_CI_AS
join  dbo.DM_ACTION  ac (nolock)
on (case when ac.DESCRIPTION = 'TO_REVIEW' THEN 'OPEN' ELSE ac.DESCRIPTION end) 
COLLATE Latin1_General_CI_AS = ( case when a.status = 'TO_REVIEW' THEN 'OPEN' else a.status end) COLLATE Latin1_General_CI_AS
join dbo.DM_TDITEM tdi (nolock)
on tdi.ID_TDITEM = a.issue_type
JOIN DM_COMMITS c (nolock)
on c.commit_hash COLLATE Latin1_General_CI_AS = a.committer_hash COLLATE Latin1_General_CI_AS
JOIN DM_SEVERITY  sev (nolock)
on sev.DESCRIPTION = a.severity
join dbo.DM_VERSION vc (nolock) ON vc.ID_COMMIT = c.ID_COMMIT
ORDER BY C.ID_COMMIT





INSERT INTO FT_TECHNICALDEBT
SELECT * FROM #FT_TECHNICALDEBT 