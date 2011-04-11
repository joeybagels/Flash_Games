package org.pranaframework.ioc.factory.xml.parser.support.nodeparsers {
	
	import mx.collections.ArrayCollection;
	
	import org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser;
	
	/**
	 * Parses an array-collection node.
	 * 
	 * @author Christophe Herreman
	 * @author Erik Westra
	 */
	public class ArrayCollectionNodeParser extends AbstractNodeParser {
		
		/**
		 * Constructs the ArrayCollectionNodeParser.
		 * 
		 * @param xmlObjectDefinitionsParser	The definitions parser using this NodeParser
		 * 
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#ARRAY_COLLECTION_ELEMENT
		 * @see org.pranaframework.ioc.factory.xml.parser.support.XMLObjectDefinitionsParser.#LIST_ELEMENT
		 */
		public function ArrayCollectionNodeParser(xmlObjectDefinitionsParser:XMLObjectDefinitionsParser) {
			super(xmlObjectDefinitionsParser, XMLObjectDefinitionsParser.ARRAY_COLLECTION_ELEMENT);
			addNodeNameAlias(XMLObjectDefinitionsParser.LIST_ELEMENT);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function parse(node:XML):Object {
			/*
				Putting the items in an array first, the ArrayCollection performs actions
				on every addItem call. This way we can set the source as a onetime operation.
			*/
			var parsedNodes:Array = new Array();
			var result:ArrayCollection = new ArrayCollection();
			
            for each (var n:XML in node.children()) 
            {
            	parsedNodes.push(xmlObjectDefinitionsParser.parsePropertyValue(n));
            }
            
            result.source = parsedNodes;
            
            return result;
		}
	}
}