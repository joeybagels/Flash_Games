package org.pranaframework.ioc.factory.xml.parser.support.nodeparsers {
	
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * Parses an array node.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class ArrayNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs the ArrayNodeParser.
		 * 
		 * @param xmlObjectDefinitionsParser	The definitions parser using this NodeParser
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#ARRAY_ELEMENT
		 */
		public function ArrayNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.ARRAY_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			var result:Array = [];
			
            for each (var n:XML in node.children()) 
            {
                result.push(xmlObjectDefinitionsParser.parsePropertyValue(n));
            }
            
            return result;
		}
		
	}
}