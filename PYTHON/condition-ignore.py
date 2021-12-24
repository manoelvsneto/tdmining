import pyodbc
from IPython.core.display import display

from Query import Query
import pyodbc
import pandas as pd
from Query import Query
from configuration import Configuration
pd.set_option('display.max_rows', None)
conn  = pyodbc.connect(Configuration.getConfigValue('database_connection'))
query_result = pd.read_sql_query('SELECT * FROM FT_TECHNICALDEBT_IGNORE_CONDITION',conn)
dataframes = pd.DataFrame(query_result)
condition = ''

for index, row in dataframes.iterrows():
    if(  str(row.ID_DEVELOPER).__eq__('None') or  str(row.ID_DEVELOPER).__eq__('nan') ):
        condition += ''
    else:
        condition += ' ID_DEVELOPER = {0} AND '.format(str(row[0]))

    if (str(row.ID_PROJECT).__eq__('None') or  str(row.ID_PROJECT).__eq__('nan') ):
        condition += ''
    else:
        condition += ' ID_PROJECT = {0} AND '.format(str(row[1]))

    if (str(row.ID_RULE).__eq__('None') or  str(row.ID_RULE).__eq__('nan') ):
        condition += ''
    else:
        condition += ' ID_RULE = {0} AND '.format(str(row[2]))

    if (str(row.ID_ACTION).__eq__('None') or   str(row.ID_ACTION).__eq__('nan') ):
        condition += ''
    else:
        condition += ' ID_ACTION = {0} AND '.format(str(row[3]))

    if (str(row.ID_TDITEM).__eq__('None') or  str(row.ID_TDITEM).__eq__('nan') ) :
        condition += ''
    else:
        condition += ' ID_TDITEM = {0} AND '.format(str(row[4]))

    if (str(row.ID_SEVERITY).__eq__('None') or  str(row.ID_SEVERITY).__eq__('nan') ):
        condition += ''
    else:
        condition += ' ID_SEVERITY = {0} AND '.format(str(row[5]))

    if (str(row.ID_TIME).__eq__('None') or  str(row.ID_TIME).__eq__('nan') ):
        condition += ''
    else:
        condition += ' ID_TIME = {0} AND '.format(str(row[6]))


    if (str(row.ID_VERSION).__eq__('None') or  str(row.ID_VERSION).__eq__('nan') ):
        condition += ''
    else:
        condition += ' ID_VERSION = {0} AND '.format(str(row[7]))

    condition += ' 1 = 1'
    condition = 'UPDATE FT_TECHNICALDEBT SET IGNORE = 1 WHERE {0}'.format(condition)
    print(condition)
    conn = pyodbc.connect(Configuration.getConfigValue('database_connection'))
    cursor = conn.cursor()
    cursor.execute(condition)
    conn.commit()
    condition = ''

