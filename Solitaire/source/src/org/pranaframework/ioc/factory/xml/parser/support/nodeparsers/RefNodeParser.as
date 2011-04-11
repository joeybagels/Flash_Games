package org.pranaframework.ioc.factory.xml.parser.support.nodeparsers {
	
	import org.pranaframework.ioc.factory.config.RuntimeObjectReference;
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * Parses an reference node.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class RefNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs the RefNodeParser.
		 * 
		 * @param xmlObjectDefinitionsParser	The definitions parser using this NodeParser
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#REF_ELEMENT
		 */	
		public function RefNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.REF_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			return new RuntimeObjectReference(node.toString());
		}
		
	}
}