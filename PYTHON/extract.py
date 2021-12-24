from pydriller import RepositoryMining

git_path = "C:\\processamento_sonar\\git-1\\wordpress\\"
f= open(git_path + f"\\commits.csv","w+")
f.write("Data|Autor|CommiterName|Hash|Msg|project_name; \n")
for commit in RepositoryMining(git_path).traverse_commits():
    s = commit.msg.encode("utf-8")
    f.write("{0}|{1}|{2}|{3}|{4}|{5}; \n".format(commit.committer_date.strftime("%d/%m/%Y %H:%M:%S"), commit.author.name, commit.committer.name, commit.hash,s,commit.project_name))

f.close()

q = open(git_path+f"\\modifications.csv","w+")
q.write('new_path|old_path|filename|Hash; \n')

for commit in RepositoryMining(git_path).traverse_commits():
    for modification in commit.modifications:
       q.write('{0}|{1}|{2}|{3}; \n'.format( modification.new_path, modification.old_path, modification.filename, commit.hash))

q.close()