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

	import flash.errors.IOError;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.pranaframework.collections.Properties;
	import org.pranaframework.ioc.factory.support.DefaultListableObjectFactory;
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;

	use namespace prana_objects;

	/**
	 * Dispatched as a result of a call to the load method when all available 
	 * configurations have been parsed.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 * @see #load()
	 */
	[Event(name="complete", type="flash.events.Event")]

	/**
	 * Dispatched when an input or output error occurs that causes a load operation to fail.
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]

	/**
	 * Manages object definitions and creates new objects based on those
	 * definitions.
	 *
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class XMLObjectFactory extends DefaultListableObjectFactory implements IXMLObjectFactory {
		/**
		 * Contains the parser of the XML definitions. The instance is created in the constructor 
		 * if it does not exist allready.
		 * 
		 * @default an intance of XMLObjectDefinitionsParser
		 */
		protected var parser:XMLObjectDefinitionsParser;
		
		private var _xml:XML;
		
		private var _loadingConfig:Boolean;
		private var _loader:URLLoader;
		
		private var _configLocations:Array = [];
		private var _currentConfigLocation:String = "";

		private var _currentProperties:Properties;
		// Will contain instances of PropertiesInfo that will be loaded
		private var _propertiesQueue:Array = [];
		// Will contain instances of Properties that have been loaded
		private var _loadedProperties:Array = [];
		
		/**
		 * Creates a new XmlObjectFactory
		 *
		 * @param source the path to the xml config file as a String or as an Array
		 */
		public function XMLObjectFactory(source:* = null) {
			super();

			if (source is String) {
				_configLocations.push(source);
			}
			else if (source is Array) {
				_configLocations = _configLocations.concat(source);
			}
			else if (source) {
				throw new IllegalOperationError("XMLObjectFactory can only be constructed using an a String or an Array");
			}
			
			_initialize();
		}
		
		/**
		 * Creates a parser if it does not yet exists (it might be created in a sub class) and 
		 * will create the loader that is used to load the config locations.
		 */
		private function _initialize():void {
			if (!parser) {
				parser = new XMLObjectDefinitionsParser(this);
			}
			
			/*
				We only need one loader. Browser restrictions allow us to only have a 
				maximum of 2 threads to the server. It is proper however to only use 
				one at a time.
			*/
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, _onLoaderComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
		}
		
		// ====================================================================
		// IXMLObjectFactory implementation
		// ====================================================================

		/**
		 * @inheritDoc
		 */
		public function addConfigLocation(configLocation:String):void {
			_configLocations.push(configLocation);
		}

		/**
		 * @inheritDoc
		 */
		public function get configLocations():Array {
			return _configLocations;
		}

		/**
		 * @inheritDoc
		 * 
		 * This method will internaly do the following:
		 * - Load all configuration entries (if any)
		 * - Load all imports (if any)
		 * - Load all property files (if any)
		 * - Give the resuls to the XMLObjectDefinitionsParser
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.XMLObjectDefinitionsParser
		 */
		public function load():void {
			_loadNextConfigLocation();
		}
		
		/**
		 * @inheritDoc
		 */
		public function addConfig(config:XML):void {
			/*
				If we are not retrieving the xml using a loader, we should reset 
				the _currentConfigLocation. When using the loader the _loadingConfig
				flag is set to true and the location will not be reset.
				
				The _currentConfigLocation is used in the _addImportLocationsIfAny and 
				_addPropertyLocationsIfAny methods.
			*/
			if (!_loadingConfig) {
				_currentConfigLocation = "";
			}
			
			_mergeXML(config);
			
			/*
				check if there are any xml or properties file references in
				the given xml data
			*/
			_addImportLocationsIfAny(config);
			_addPropertyLocationsIfAny(config);
		}
	
		// ====================================================================

		/**
		 * Will load a configLocation
		 */
		protected function loadConfigLocation(configLocation:String):void {
			_currentConfigLocation = configLocation;
			
			_loadingConfig = true;
			
			var request:URLRequest = new URLRequest(configLocation);
			
			_loader.load(request);
		}
	

		private function _mergeXML(xml:XML):void {
			if (_xml) {
				var childNodes:XMLList = xml.children();
				_xml.appendChild(childNodes);
			}
			else {
				_xml = xml;
			}			
		}

		/**
		 * Returns the base url of the file this loading is loading.
		 */
		private function _getBaseURL(url:String):String {
			var lastSlashIndex:int = url.lastIndexOf("/");
			var result:String = (lastSlashIndex == -1) ? "" : url.substr(0, lastSlashIndex + 1);
			
			return result;
		}

		/**
		 * Will grab the xml and add it as config
		 */
		private function _onLoaderComplete(event:Event):void {
			// if the loading is done, we need to check if the xml contains
			// import or property tags
			// if it does, we first load these

			// TODO catch malformed xml
			var xml:XML = new XML(_loader.data);

			addConfig(xml);
			
			_loadingConfig = false;
			
			_loadNextConfigLocation();
		}
		
		/**
		 * Checks if the given xml data contains any <import> tags. If any are found,
		 * their corresponding xml file is added to the load queue.
		 */
		private function _addImportLocationsIfAny(xml:XML):void {
			var importNodes:XMLList = xml.descendants("import").(attribute("file") != undefined);
			
			for each (var importNode:XML in importNodes) {
				var importLocation:String = _getBaseURL(_currentConfigLocation) + importNode.@file.toString();
				addConfigLocation(importLocation);
			}
		}

		/**
		 * Checks if the given xml data contains any <property> tags. If any are found, 
		 * the information is added to a queue for later loading. 
		 */
		private function _addPropertyLocationsIfAny(xml:XML):void {
			// select all property nodes that have a file attribute
			var propertyNodes:XMLList = xml..property.(attribute("file") != undefined);

			for each (var node:XML in propertyNodes) {
				var propertiesInfo:PropertiesInfo = new PropertiesInfo();
				propertiesInfo.properties = new Properties();
				propertiesInfo.location = _getBaseURL(_currentConfigLocation) + node.@file.toString();
				
				_propertiesQueue.push(propertiesInfo);

			}
		}
		
		/**
		 * If there are any config locations left, the next will be loaded.
		 */
		private function _loadNextConfigLocation():void {
			// load the next config location if we have one
			if (_configLocations.length) {
				var nextConfigLocation:String = String(_configLocations.shift());
				loadConfigLocation(nextConfigLocation);
			}
			else {
				_loadNextProperties();
			}
		}
		
		/**
		 * If there are any properties left to be loaded, the next will be loaded.
		 */
		private function _loadNextProperties():void {
			if (_propertiesQueue.length) {
				var propertyInfo:PropertiesInfo = PropertiesInfo(_propertiesQueue.shift());
				 
				var properties:Properties = propertyInfo.properties; 
				properties.addEventListener(Event.COMPLETE, _onPropertiesComplete);
				properties.addEventListener(IOErrorEvent.IO_ERROR, _onIOError);
				
				//save a reference to prevent garbage collection
				_currentProperties = properties;
				
				properties.load(propertyInfo.location);
			}
			else {
				_doParse();
			}
		}

		private function _onPropertiesComplete(event:Event):void {
			_loadedProperties.push(_currentProperties);
		
			_currentProperties.removeEventListener(Event.COMPLETE, _onPropertiesComplete);
			_currentProperties.removeEventListener(IOErrorEvent.IO_ERROR, _onIOError);
			
			_currentProperties = null;

			_loadNextProperties();
		}

		private function _doParse():void {
			beforeParse();
			parser.parse(_xml, _loadedProperties);
			afterParse();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

		/**
		 * Will throw an error (just like the Flash player core classes) if 
		 * no listener has been specified.
		 */
		private function _onIOError(event:IOErrorEvent):void {
			if (hasEventListener(event.type)) {
				dispatchEvent(event);
			}
			else {
				throw new IOError("Unhandled ioError: " + event.text);
			}
		}

		/**
		 * Hook method, executed before the xml context is parsed.
		 */
		protected function beforeParse():void {
			// nothing here, just a hook
		}

		/**
		 * Hook method, executed after the xml context is parsed.
		 */
		protected function afterParse():void {
			// nothing here, just a hook
		}

	}
}

import org.pranaframework.collections.Properties;
	

/**
 * Contains information that needs to be stored temporary
 */
class PropertiesInfo {
	public var properties:Properties;
	public var location:String;
}