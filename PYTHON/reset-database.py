#%%

import pyodbc
import pandas as pd
from Query import Query
from configuration import Configuration
conn = pyodbc.connect(Configuration.getConfigValue('database_connection'))
query = Query.getQuery('revert_database')
pd.read_sql_query(query,conn)
cursor = conn.cursor()
cursor.execute(query)
conn.commit()