package org.pranaframework.ioc.factory.xml.parser.support.nodeparsers {
	
	import flash.utils.Dictionary;
	
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	import org.pranaframework.utils.XMLUtils;
	
	/**
	 * Parses a dictionary node.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class DictionaryNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs the DictionaryNodeParser.
		 * 
		 * @param xmlObjectDefinitionsParser	The definitions parser using this NodeParser
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#DICTIONARY_ELEMENT
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#MAP_ELEMENT
		 */
		public function DictionaryNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.DICTIONARY_ELEMENT);
			addNodeNameAlias(XMLObjectDefinitionsParser.MAP_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			var result:Dictionary = new Dictionary();
			
			for each (var n:XML in node.children()) {
				n = XMLUtils.convertAttributeToNode(n, XMLObjectDefinitionsParser.KEY_ATTRIBUTE);
				n = XMLUtils.convertAttributeToNode(n, XMLObjectDefinitionsParser.VALUE_ATTRIBUTE);
				result[xmlObjectDefinitionsParser.parsePropertyValue(n.key[0])] = xmlObjectDefinitionsParser.parsePropertyValue(n.value[0]);
			}
			
			return result;
		}
		
	}
}
