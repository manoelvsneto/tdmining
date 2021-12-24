from pydriller import RepositoryMining
from configuration import Configuration
import pyodbc

def inserir(_committer_date, _author_name, _hash):
    conn = pyodbc.connect(Configuration.getConfigValue('database_connection'))
    cursor = conn.cursor()
    _author_name = _author_name.replace("'", "")
    cursor.execute(
        f"INSERT INTO dbo.commits (author_name, committer_hash, committer_date,project_name,worker) VALUES ('{_author_name}','{_hash}','{_committer_date}','{ Configuration.getConfigValue('project_name')}',1)")
    conn.commit()

def insertCommits():
    for commit in RepositoryMining(Configuration.getConfigValue('path_git')).traverse_commits():
        print(commit.hash)
        inserir(commit.committer_date.strftime("%d/%m/%Y %H:%M:%S"), commit.author.name, commit.hash)

insertCommits()