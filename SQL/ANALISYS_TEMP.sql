ETL_1.SQL
--TD QUE FORAM ABERTOS
select    KEE collate Latin1_General_CS_AS as kee  , MIN(iss.date_insert) AS date_insert 
INTO Resultado.dbo.OpenKee
from Repository5.dbo.issues i (nolock)
join RepositoryStage.dbo.issues_sonar iss (nolock)
on i.kee  collate Latin1_General_CS_AS = iss.kee  collate Latin1_General_CS_AS
and i.committer_hash  collate Latin1_General_CS_AS = iss.committer_hash
group by KEE collate Latin1_General_CS_AS



--TD QUE FORAM FECHADOS
select    KEE collate Latin1_General_CS_AS as kee  , MIN(iss.date_insert) AS date_insert 
INTO Resultado.dbo.CloseKee
from RepositoryStage.dbo.issues_sonar iss (nolock)
where status = 'CLOSED'
GROUP BY KEE



SELECT
c.author_name, c.project_name ,q.rule_uuid, q.severity, q.effort,q.tags, c.committer_date, q.status, q.issue_type,c.committer_hash,q.kee
into Resultado.dbo.Analisys_Temp_Closed
FROM Repository5.dbo.commits c (nolock)
join RepositoryStage.dbo.issues_sonar q (nolock)
on q.committer_hash   collate Latin1_General_CS_AS = c.committer_hash  collate Latin1_General_CS_AS
and q.status = 'CLOSED' 
join  Resultado.dbo.CloseKee o (nolock)
on o.date_insert = q.date_insert
and o.kee  collate Latin1_General_CS_AS = q.kee  collate Latin1_General_CS_AS



SELECT  
c.author_name, c.project_name ,q.rule_uuid, q.severity, q.effort,q.tags, c.committer_date, q.status, q.issue_type,c.committer_hash,q.kee
into Resultado.dbo.Analisys_Temp_Open
FROM RepositoryStage.dbo.issues_sonar q (nolock)
JOIN Repository5.dbo.commits c (nolock) 
on c.committer_hash collate Latin1_General_CS_AS = q.committer_hash collate Latin1_General_CS_AS
join  Resultado.dbo.OpenKee o (nolock)
on o.date_insert = q.date_insert
and o.kee  collate Latin1_General_CS_AS = q.kee  collate Latin1_General_CS_AS


select * into Analisys_Temp from (
select * from Analisys_Temp_Closed
union all
select * from Analisys_Temp_Open
) as q


select distinct kee collate Latin1_General_CS_AS as kee into Resultado.dbo.kee from Repository5.dbo.issues
ALTER TABLE Resultado.dbo.kee ADD OPEN_COMMITHASH VARCHAR(55)
ALTER TABLE Resultado.dbo.kee ADD CLOSED_COMMITHASH VARCHAR(55)
ALTER TABLE Resultado.dbo.kee ADD OPEN_DATETIME DATETIME
ALTER TABLE Resultado.dbo.kee ADD CLOSED_DATETIME DATETIME


UPDATE kee set OPEN_COMMITHASH = x.committer_hash, OPEN_DATETIME =  convert(datetime, x.committer_date,103)
from kee  c join
(select kee,committer_date,committer_hash from Analisys_Temp  where [status] = 'OPEN') as x
on x.kee collate Latin1_General_CS_AS  = c.kee collate Latin1_General_CS_AS


UPDATE kee set CLOSED_COMMITHASH = x.committer_hash, CLOSED_DATETIME =  convert(datetime, x.committer_date,103)
from kee  c join
(select kee,committer_date,committer_hash from Analisys_Temp  where [status] = 'CLOSED') as x
on x.kee collate Latin1_General_CS_AS  = c.kee collate Latin1_General_CS_AS


UPDATE kee SET OPEN_COMMITHASH = x.committer_hash, OPEN_DATETIME =  convert(datetime, x.committer_date,103)
from kee k (nolock)
join (
select kee  collate Latin1_General_CS_AS as kee,c.committer_hash,c.committer_date from Repository5.dbo.issues i (nolock)
join Repository5.dbo.commits c (nolock)
on c.committer_hash collate Latin1_General_CS_AS = i.committer_hash collate Latin1_General_CS_AS
) x on x.kee collate Latin1_General_CS_AS  = k.kee collate Latin1_General_CS_AS
where k.OPEN_COMMITHASH is null
