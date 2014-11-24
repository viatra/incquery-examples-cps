package org.eclipse.incquery.examples.cps.tests

import java.io.FileInputStream
import java.io.IOException
import java.util.Properties
import org.apache.log4j.Level
import org.apache.log4j.Logger

class PropertiesUtil {
	
	protected static Logger logger = Logger.getLogger("cps.xform.PropertyUtil")
	static Properties properties = loadPropertiesFile
	
	public static val CPS_XFORM_LOGLEVEL_PROP_KEY = "cps.xform.loglevel"
	public static val CPS_GENERATOR_LOGLEVEL_PROP_KEY = "cps.generator.loglevel"
	public static val INCQUERY_LOGLEVEL_PROP_KEY = "org.eclipse.incquery.loglevel"
	public static val GIT_CLONE_LOCATION_PROP_KEY = "git.clone.location"
	
	private def static loadPropertiesFile() {
		val configPath = "cps2dep.properties"
		val properties = new Properties()
        var FileInputStream fileInputStream = null
    	try {
    		//load a properties file
            fileInputStream = new FileInputStream(configPath);
            properties.load(fileInputStream);
    	} catch (IOException ex) {
    		logger.debug('''Could not find properties at «configPath»''')
        } finally {
            if (fileInputStream != null) {
                try {
                    fileInputStream.close()
                } catch (IOException e) {
                    logger.fatal("Should never happen!",e)
                }
            }
        }
        properties
	}
	
	def static getPropertyValue(String propertyKey, String defaultValue) {
		if(properties != null){
			properties.getProperty(propertyKey, defaultValue)
		}
	}
	
	def static getCPSXformLogLevel(){
		getLogLevel(CPS_XFORM_LOGLEVEL_PROP_KEY, "INFO")
	}
	
	def static getCPSGeneratorLogLevel(){
		getLogLevel(CPS_GENERATOR_LOGLEVEL_PROP_KEY, "INFO")
	}
	
	def static getIncQueryLogLevel(){
		getLogLevel(INCQUERY_LOGLEVEL_PROP_KEY, "WARN")
	}
	
	def static getLogLevel(String key, String defaultLevel) {
		val level = getPropertyValue(key, defaultLevel)
		Level.toLevel(level, Level.WARN)
	}
	
	def static getGitCloneLocation(){
		val location = getPropertyValue(GIT_CLONE_LOCATION_PROP_KEY, "my-git-location")
		System.getProperty("git.clone.location", location)		
	}
}