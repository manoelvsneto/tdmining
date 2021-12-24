from configparser import ConfigParser
class Configuration:
    def getConfigValue(_config):
        config_object = ConfigParser()
        config_object.read("config.ini")
        value_ = config_object["configuration"]
        return value_.get(_config)