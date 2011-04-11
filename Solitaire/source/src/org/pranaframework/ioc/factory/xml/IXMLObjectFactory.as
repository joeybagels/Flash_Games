/**
 * Copyright (c) 2007-2008, the original author(s)
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the Prana Framework nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package org.pranaframework.ioc.factory.xml {
	import org.pranaframework.ioc.factory.config.IConfigurableListableObjectFactory;
	import org.pranaframework.ioc.factory.support.IObjectDefinitionRegistry;
	

	/**
	 * Interface to be implemented by object factories that load their object
	 * definitions from XML files.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public interface IXMLObjectFactory extends IConfigurableListableObjectFactory, IObjectDefinitionRegistry {
		/**
		 * Instructs the object factory to start loading the available configuration(s)
		 */
		function load():void;
		
		/**
		 * Use this method to add aditional configuration locations.
		 * 
		 * @param configLocation	The location to add. This is the path to the configuration xml file
		 */
		function addConfigLocation(configLocation:String):void;

		/**
		 * Use this method to add xml versions of configurations
		 * 
		 * @param config	The xml configuration to add
		 */
		function addConfig(config:XML):void;

		/**
		 * Returns an array of configuration locations.
		 */
		function get configLocations():Array;
	}
}