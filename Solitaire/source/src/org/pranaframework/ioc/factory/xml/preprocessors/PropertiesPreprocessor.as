package org.pranaframework.ioc.factory.xml.preprocessors {

	import org.pranaframework.ioc.factory.xml.parser.IXMLObjectDefinitionsPreprocessor;
	import org.pranaframework.ioc.factory.xml.prana_objects;
	import org.pranaframework.utils.Assert;
	import org.pranaframework.utils.PropertiesUtils;

	use namespace prana_objects;

	/**
	 * Replaces all properties placeholders in the xml of the application context
	 * with the values in the Properties objects.
	 *
	 * @author Christophe Herreman
	 * @author Kristof Neirynck
	 */
	public class PropertiesPreprocessor implements IXMLObjectDefinitionsPreprocessor {

		private static const PROPERTY_REGEXP:RegExp = /\$\{[^}]+\}/g;

		private var _properties:Array;

		/**
		 * Creates a new PropertiesPreprocessor object.
		 *
		 * @param properties the collection of Properties objects to apply
		 */
		public function PropertiesPreprocessor(properties:Array) {
			Assert.notNull(properties, "The properties cannot be null.");
			_properties = properties;
		}

		/**
		 *
		 */
		public function preprocess(xml:XML):XML {
			var nodes:XMLList = xml..object;

			for (var i:int = 0; i<nodes.length(); i++) {
				var node:XML = nodes[i];
				var s:String = node.toXMLString();
				var match:Object;

				while (match = PROPERTY_REGEXP.exec(s)) {
					var property:String = match[0];
					var key:String = property.substring(2, property.length-1);
					var value:String = PropertiesUtils.getProperty(_properties, key);
					s = s.replace(property, value);
				}

				nodes[i] = new XML(s);
			}

			return xml;
		}

	}
}