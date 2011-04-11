package org.pranaframework.ioc.factory.xml.parser.support.nodeparsers {
	
	import flash.errors.IllegalOperationError;
	
	import org.pranaframework.ioc.factory.xml.parser.INodeParser;
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * Abstract base class for node parsers.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class AbstractNodeParser implements INodeParser {
		/**
		 * The xmlObjectDefinitionsParser using this NodeParser
		 */
		protected var xmlObjectDefinitionsParser:XMLObjectDefinitionsParser;
		
		/**
		 * An array containing the compatible node names.
		 */
		protected var nodeNames:Array = [];
		
		/**
		 * This class should not be instantiated directly. Create a subclass that implements the parse method.
		 * 
		 * @param xmlObjectDefinitionsParser	The definitions parser using this NodeParser
		 * @param nodeName						The name of the node this parser should react to
		 */
		public function AbstractNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser, nodeName:String) {
			this.xmlObjectDefinitionsParser = xmlObjectDefinitionsParser;
			this.nodeNames.push(nodeName);
		}
		
		/**
		 * @inheritDoc
		 */
		public function addNodeNameAlias(alias:String):void {
			nodeNames.push(alias);
		}

		/**
		 * @inheritDoc
		 */
		public function canParse(node:XML):Boolean {
			return (nodeNames.indexOf(node.name().localName.toLowerCase()) != -1);
		}
		
		/**
		 * @inheritDoc 
		 */
		public function getNodeNames():Array {
			return this.nodeNames;
		}
		
		/**
		 * This is an abstract method and should be overridden in a subclass.
		 * 
		 * @inheritDoc
		 */
		public function parse(node:XML):Object {
			throw new IllegalOperationError("parse() is abstract");
		}
		
		
	}
}