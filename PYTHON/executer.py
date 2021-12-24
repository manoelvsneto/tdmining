import pyodbc
from git import *
import time
from datetime import datetime
import os
from configuration import Configuration
database_result =  Configuration.getConfigValue('database_result')
database_result_sonar =  Configuration.getConfigValue('database_result_sonar')
schema_result =   Configuration.getConfigValue('schema_result')
schema_result_sonar =  Configuration.getConfigValue('schema_result_sonar')
database_connection = Configuration.getConfigValue('database_connection')
database_connection_sonar = Configuration.getConfigValue('database_connection_sonar')
path_base_sonarscanner = Configuration.getConfigValue('path_base_sonarscanner')
path_git = Configuration.getConfigValue('path_git')
project_name =  Configuration.getConfigValue('project_name')

def deleteSonarProjectProperties():
    path = f"{path_base_sonarscanner}\\bin\\sonar-project.properties"
    os.remove(path)
    time.sleep(1)

def updateCommit(_committer_hash):
    conn = pyodbc.connect(database_connection)
    cursor = conn.cursor()
    cursor.execute(
        f"update  dbo.commits set processed = 1 where committer_hash = '{_committer_hash}' and processed = 0")
    conn.commit()

def writeSonarProjectProperties(_hash):
    file = open(f"{path_base_sonarscanner}\\bin\\sonar-project.properties", 'w')
    file.writelines(f'sonar.projectKey={project_name}\n')
    file.writelines(f'sonar.projectName={project_name}\n')
    file.writelines(f'sonar.projectVersion=1.0.0.{_hash}\n')
    file.writelines(f'sonar.sources={path_git}\n')
    file.writelines(f'sonar.projectBaseDir={path_git}\n')
    file.writelines('sonar.sourceEncoding=UTF-8\n')
    file.writelines('sonar.scm.disabled=True\n')
    file.writelines('sonar.verbose=True\n')
    file.close()
    time.sleep(1)
    updateCommit(_hash)
    generateBranch(_hash)

def generateBranch(_hash, _project):
    repo = Repo(path_git)
    new_branch = repo.create_head(f'branch_{_hash}', _hash)
    time.sleep(1)
    new_branch.checkout()
    time.sleep(1)
    filepath = f"{path_base_sonarscanner}\\bin\\sonar-scanner.bat"
    os.chdir(f'{path_base_sonarscanner}\\bin')
    os.system(filepath)
    islast(_project,_hash)

def setProject(_hash):
    deleteSonarProjectProperties()
    writeSonarProjectProperties(_hash)

def islast(_project, _committer_hash):
    islastbool = 0
    print(f"Processing Start: {_committer_hash}")
    while islastbool == 0:
        conn = pyodbc.connect(database_connection_sonar)
        cursor = conn.cursor()
        cursor.execute(f"select top 1 islast from {schema_result_sonar}.dbo.snapshots s (nolock)   where s.version = '1.0.0.' + '{_committer_hash}'")
        records = cursor.fetchall()

        for row in records:
            islastbool = row[0]
            cursor.close()
            conn.close()
            
        if islastbool == 1:
            print(f"Running: {_committer_hash} ")
            insertInssues(_project, _committer_hash)


def insertInssues(_project, _committer_hash):
    time.sleep(1)
    conn = pyodbc.connect(database_connection_sonar)
    cursor = conn.cursor()
    cursor.execute(
        f"insert into {schema_result_sonar}.[dbo].[issues_sonar] SELECT  s.*,'{_committer_hash}',GETDATE()  FROM {schema_result_sonar}.dbo.issues s (nolock) where project_uuid  in  (select project_uuid from {schema_result_sonar}.dbo.projects p(nolock) where p.name = '{_project}')")
    conn.commit()
    insertInssues2(_project,_committer_hash)

def insertInssues2(_project, _committer_hash):
    time.sleep(1)
    conn = pyodbc.connect(database_connection)
    cursor = conn.cursor()
    cursor.execute(
            f"insert into {schema_result_sonar}.[dbo].[issues] ( [kee] ,[committer_hash]) SELECT  s.kee,'{_committer_hash}'  FROM {schema_result_sonar}.dbo.issues s (nolock) where project_uuid  in  (select project_uuid from {schema_result_sonar}.dbo.projects p(nolock)  where p.name = '{_project}' )   and kee not in ( SELECT   kee  FROM {schema_result}.dbo.[issues] (nolock) )")
    conn.commit()
    print('Finish')


def selectHashs():
    print('Start')
    conn = pyodbc.connect(database_connection)
    cursor = conn.cursor()
    cursor.execute(
        f"select committer_hash from {schema_result}.dbo.commits where project_name = '{project_name}' and processed = 0 order by id asc")
    row = cursor.fetchone()

    while row is not None:
        start = datetime.now()
        start_dt_string = start.strftime("%d/%m/%Y %H:%M:%S")
        setProject(row[0])
        print("start date and time =", start_dt_string)
        end = datetime.now()
        end_dt_string = end.strftime("%d/%m/%Y %H:%M:%S")
        print("end date and time =", end_dt_string)
        row = cursor.fetchone()

    cursor.close()
    conn.close()


selectHashs()
