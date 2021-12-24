from configparser import ConfigParser
class Query:
    def getQuery(queryName):
        config_object = ConfigParser()
        config_object.read("query.ini")
        value_ = config_object["query"]
        return  value_.get(queryName)