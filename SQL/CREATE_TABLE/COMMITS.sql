------------------CRIAR TABELA COMMITS
CREATE TABLE COMMITS 
(
	id INT PRIMARY KEY IDENTITY (1,1),
	author_name VARCHAR(500),
	committer_hash VARCHAR(500),
	committer_date VARCHAR(500),
	date_insert datetime default GETDATE(),
	project_name varchar(500),
	worker int default 0
)

ALTER TABLE commits ADD processed int default 0



