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
 package org.pranaframework.ioc.factory.xml.parser.support 
 {

	import org.pranaframework.ioc.IObjectDefinition;
	import org.pranaframework.ioc.ObjectDefinition;
	import org.pranaframework.ioc.ObjectDefinitionScope;
	import org.pranaframework.ioc.factory.xml.IXMLObjectFactory;
	import org.pranaframework.ioc.factory.xml.XMLObjectFactory;
	import org.pranaframework.ioc.factory.xml.parser.INodeParser;
	import org.pranaframework.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.ArrayNodeParser;
	import org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.DictionaryNodeParser;
	import org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.KeyValueNodeParser;
	import org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.ObjectNodeParser;
	import org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.RefNodeParser;
	import org.pranaframework.ioc.factory.xml.prana_objects;
	import org.pranaframework.ioc.factory.xml.preprocessors.AttributeToElementPreprocessor;
	import org.pranaframework.ioc.factory.xml.preprocessors.IdAttributePreprocessor;
	import org.pranaframework.ioc.factory.xml.preprocessors.MethodInvocationPreprocessor;
	import org.pranaframework.ioc.factory.xml.preprocessors.PropertiesPreprocessor;
	import org.pranaframework.ioc.factory.xml.preprocessors.ScopeAttributePrepocessor;
	import org.pranaframework.ioc.factory.xml.preprocessors.SpringNamesPreprocessor;
	import org.pranaframework.ioc.factory.xml.preprocessors.TemplatePreprocessor;
	import org.pranaframework.utils.Assert;

	use namespace prana_objects;

	/**
	 * Xml parser for object definitions.
	 *
	 * @author Christophe Herreman
	 * @author Damir Murat
	 * @author Erik Westra
	 */
	public class XMLObjectDefinitionsParser {
		/** Constant value 'id' */
		public static const ID_ATTRIBUTE:String = "id";
		/** Constant value 'class' */
		public static const CLASS_ATTRIBUTE:String = "class";
		/** Constant value 'factory-method' */
		public static const FACTORY_METHOD_ATTRIBUTE:String = "factory-method";
		/** Constant value 'init-method' */
		public static const INIT_METHOD_ATTRIBUTE:String = "init-method";
		/** Constant value 'lazy-init' */
		public static const LAZY_INIT_ATTRIBUTE:String = "lazy-init";
		/** Constant value 'scope' */
		public static const SCOPE_ATTRIBUTE:String = "scope";
		/** Constant value 'value' */
		public static const VALUE_ATTRIBUTE:String = "value";
		/** Constant value 'key' */
		public static const KEY_ATTRIBUTE:String = "key";
		/** Constant value 'ref' */
		public static const REF_ATTRIBUTE:String = "ref";

		/** Constant value 'object' */
		public static const OBJECT_ELEMENT:String = "object";
		/** Constant value 'value' */
		public static const VALUE_ELEMENT:String = "value";
		/** Constant value 'key' */
		public static const KEY_ELEMENT:String = "key";
		/** Constant value 'ref' */
		public static const REF_ELEMENT:String = "ref";
		/** Constant value 'property' */
		public static const PROPERTY_ELEMENT:String = "property";
		/** Constant value 'constructor-arg' */
		public static const CONSTRUCTOR_ARG_ELEMENT:String = "constructor-arg";
		/** Constant value 'template' */
		public static const TEMPLATE_ELEMENT:String = "template";
		/** Constant value 'array' */
		public static const ARRAY_ELEMENT:String = "array";
		/** Constant value 'array-collection' */
		public static const ARRAY_COLLECTION_ELEMENT:String = "array-collection";
		/** Constant value 'dictionary' */
		public static const DICTIONARY_ELEMENT:String = "dictionary";
		/** Constant value 'list' */
		public static const LIST_ELEMENT:String = "list";
		/** Constant value 'map' */
		public static const MAP_ELEMENT:String = "map";
		/** Constant value 'entry' */
		public static const ENTRY_ELEMENENT:String = "entry";

		private var _objectFactory:IXMLObjectFactory;
		private var _preprocessorsInitialized:Boolean = false;
		
		// Will contain instances of INodeParser
		private var _nodeParsers:Array = [];
		// Will contain instances of IXMLObjectDefinitionsPreprocessor
		private var _preprocessors:Array = [];

		/**
		 * Constructs a new <code>XmlObjectDefinitionsParser</code>.
		 * An optional objectFactory can be passed to store the definitions. If no
		 * container is passed then a new instance will be created of type XMLObjectFactory.
		 * <p />
		 * Will add the following node parsers by default:
		 * <ul>
		 * 	<li>ObjectNodeParser</li>
		 * 	<li>KeyValueNodeParser</li>
		 * 	<li>ArrayNodeParser</li>
		 * 	<li>RefNodeParser</li>
		 * 	<li>DictionaryNodeParser</li>
		 * </ul>
		 *
		 * @param objectFactory 	the objectFactory where the object definitions will be stored
		 * 
		 * @see org.pranaframework.ioc.factory.xml.XMLObjectFactory
		 * @see org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.ObjectNodeParser
		 * @see org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.KeyValueNodeParser
		 * @see org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.ArrayNodeParser
		 * @see org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.RefNodeParser
		 * @see org.pranaframework.ioc.factory.xml.parser.support.nodeparsers.DictionaryNodeParser
		 */
		public function XMLObjectDefinitionsParser(objectFactory:IXMLObjectFactory = null) {
			this.objectFactory = !objectFactory ? new XMLObjectFactory() : objectFactory;
			
			_initialize();
		}
		
		/**
		 * Will add the default node parsers
		 */
		private function _initialize():void {
			addNodeParser(new ObjectNodeParser(this));
			addNodeParser(new KeyValueNodeParser(this));
			addNodeParser(new ArrayNodeParser(this));
			addNodeParser(new RefNodeParser(this));
			addNodeParser(new DictionaryNodeParser(this));			
		}

		/**
		 * Adds a preprocessor to the parser.
		 * 
		 * @param preprocessor		The inplementation of IXMLObjectDefinitionsPreprocessor that will be added
		 */
		public function addPreprocessor(preprocessor:IXMLObjectDefinitionsPreprocessor):void {
			Assert.notNull(preprocessor, "The preprocessor argument must not be null");
			_preprocessors.push(preprocessor);
		}

		/**
		 * Adds a NodeParser to the parser.
		 * 
		 * @param parser		The inplementation of INodeParser that will be added
		 */
		public function addNodeParser(parser:INodeParser):void {
			_nodeParsers.push(parser);
		}

		/**
		 * Parses all object definitions and returns the objectFactory that contains
		 * the parsed results.
		 *
		 * @param xml 			the xml object with the object definitions
		 * @param properties 	an array of Properties objects
		 * 
		 * @return the objectFactory with the parsed object definitions
		 */
		public function parse(xml:XML, properties:Array = null):IXMLObjectFactory {
			/*
				initialize the preprocessors
				do this here because the properties preprocessor needs the properties
			*/
			if (!_preprocessorsInitialized) {
				_preprocessorsInitialized = true;
				
				addPreprocessor(new AttributeToElementPreprocessor());
				addPreprocessor(new SpringNamesPreprocessor());
				addPreprocessor(new TemplatePreprocessor());
				addPreprocessor(new IdAttributePreprocessor());
				addPreprocessor(new ScopeAttributePrepocessor());
				
				if (properties && properties.length) {
					addPreprocessor(new PropertiesPreprocessor(properties));
				}
				
				addPreprocessor(new MethodInvocationPreprocessor());
			}
			
			/* 
				Preprocess the xml.
			*/
			xml = _preprocess(xml);

			/*
				Retrieve all objects containing the class attribute
			*/
			var objectNodes:XMLList = xml..object.(attribute(CLASS_ATTRIBUTE) != undefined);

			for each (var objectDefinitionNode:XML in objectNodes) {
				/*
					only parse object nodes that are not part of a template
				*/
				if (objectDefinitionNode.parent().name() != TEMPLATE_ELEMENT) {
					parseAndRegisterObjectDefinition(objectDefinitionNode);
				}
			}

			return objectFactory;
		}

		/**
		 * Will loop through the IXMLObjectDefinitionsPreprocessor and let them 
		 * preprocess the xml;
		 * 
		 * @param xml	The XML to be preprocessed
		 * 
		 * @return 		The preprocessed xml
		 */
		private function _preprocess(xml:XML):XML {
			for each (var preprocessor:IXMLObjectDefinitionsPreprocessor in _preprocessors) {
				xml = preprocessor.preprocess(xml);
			}
			
			return xml;
		}

		/**
		 * Parses and registers an object definition.
		 *
		 * @param node 		The xml node to create an object definition from.
		 * 
		 * @returns 		the id of the object definition
		 */
		public function parseAndRegisterObjectDefinition(node:XML):String {
			var id:String = node.@id.toString();
			
			var objectDefinition:IObjectDefinition = parseObjectDefinition(node);
			
			objectFactory.registerObjectDefinition(id, objectDefinition);
			
			return id;
		}

		/**
		 * Parses the given object definition node into an implementation of IObjectDefinition.
		 * 
		 * @param xml	The object definition node
		 * 
		 * @return an implementation of IObjectDefinition
		 */
		public function parseObjectDefinition(xml:XML):IObjectDefinition {
			var result:IObjectDefinition = new ObjectDefinition(xml.attribute(CLASS_ATTRIBUTE));
			result.factoryMethod = (xml.attribute(FACTORY_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(FACTORY_METHOD_ATTRIBUTE);
			result.initMethod = (xml.attribute(INIT_METHOD_ATTRIBUTE) == undefined) ? null : xml.attribute(INIT_METHOD_ATTRIBUTE);
			result.isLazyInit = (xml.attribute(LAZY_INIT_ATTRIBUTE) == "true") ? true : false;
			result.constructorArguments = _parseConstructorArguments(xml);
			result.properties = _parseProperties(xml.property, Object);
			result.scope = ObjectDefinitionScope.fromName(xml.attribute(SCOPE_ATTRIBUTE));
			
			return result;
		}

		/**
		 * Will retrieve the constructor arguments and parses them as if they were property nodes.
		 * 
		 * @param xml		The xml to check for nodes
		 * 
		 * @return			an array containing the results of the parseProperty method.
		 * 
		 * @see #parseProperty()
		 */
		private function _parseConstructorArguments(xml:XML):Array {
			var result:Array = new Array();
			for each (var node:XML in xml.children().(name().localName == CONSTRUCTOR_ARG_ELEMENT)) {
				result.push(parseProperty(node));
			}
			
			return result;
		}

		/**
		 * Parses the given property nodes.
		 * 
		 * @param propertyNodes		An xmlList containing propery nodes
		 * @param resultType		The type of the container that will hold the properties
		 * 
		 * @return 	an instance of resultType containing the properties. The name of the propery 
		 * 			will be used as key and the value is producued by the parseProperty method.
		 */
		private function _parseProperties(propertyNodes:XMLList, resultType:Class):Object {
			var result:Object = new resultType();
			
			for each (var node:XML in propertyNodes) {
				result[node.@name.toString()] = parseProperty(node);
			}
			
			return result;
		}

		/**
		 * Will parse the given property node. If the given property does not contain 
		 * a value attribute, the first childNode will be used as value else the value 
		 * of the property will be parsed and returned using the parsePropertyValue 
		 * method.
		 * 
		 * @param node		The property node to be parsed
		 * 
		 * @return the value of the parsed node
		 * 
		 * @see #parsePropertyValue()
		 */
		public function parseProperty(node:XML):Object {
			var result:Object;
			
			if (node.@value != undefined) {
				// move the "value" attribute to the node
				node.value = new String(node.@value);
				delete node.@value;
			}

			if (node.value == undefined) {
				var subNodes:XMLList = node.children();
				var propertyNode:XML = subNodes[0];
				result = parsePropertyValue(propertyNode);
			}
			else {
				if (node.@type != undefined) {
					// move the "type" attribute to the value node
					node.value.@type = node.@type.toString();
					delete node.@type;
				}
				result = parsePropertyValue(node.value[0]);
			}
			
			return result;
		}

		/**
		 * Will parse the given property value using the node parsers.
		 * <p />
		 * Will loop through the node parsers in the order that they have 
		 * been added. The first parser able to parse the node is used to
		 * retrieve the value.
		 * 
		 * @param node		The property value node to be parsed
		 * 
		 * @return the value of the node after parsing
		 */
		public function parsePropertyValue(node:XML):Object {
			var result:Object;
			var numNodeParsers:int = _nodeParsers.length;
			
			for (var i:int = 0; i < numNodeParsers; i++) {
				var nodeParser:INodeParser = _nodeParsers[i];
				if (nodeParser.canParse(node)) {
					result = nodeParser.parse(node);
					break;
				}
			}

			return result;
		}
		
		/**
		 * Returns all registered implementations of INodeParser. Node parsers can 
		 * be added using the addNodeParser method.
		 * 
		 * @see #addNodeParser()
		 */
		public function get nodeParsers():Array {
			return _nodeParsers;
		}
		
		/**
		 * The objectFactory currently in use
		 * 
		 * @default an instance of XMLObjectFactory
		 * 
		 * @see org.pranaframework.ioc.factory.xml.XMLObjectFactory
		 */
		public function get objectFactory():IXMLObjectFactory {
			return _objectFactory;
		}

		public function set objectFactory(value:IXMLObjectFactory):void {
			_objectFactory = value;
		}
		
		/**
		 *
		 */
		/*private function preProcessObjectNode(node:XML):void {
			preProcessObjectSubNodes(node, CONSTRUCTOR_ARG_ELEMENT);
			preProcessObjectSubNodes(node, PROPERTY_ELEMENT);
		}*/

		/**
		 *
		 */
		/*private function preProcessObjectSubNodes(node:XML, nodeName:String):void {
			for each (var subNode:XML in node.children().(name().localName == nodeName)) {
				subNode = XMLUtils.convertAttributeToNode(subNode, REF_ATTRIBUTE);
			}
		}*/		
	}
}