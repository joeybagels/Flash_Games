package org.pranaframework.ioc.factory.config {

	import org.pranaframework.ioc.IObjectDefinition;
	import org.pranaframework.ioc.factory.IListableObjectFactory;

	/**
	 * This interface combines IConfigurableObjectFactory and IListableObjectFactory 
	 */
	public interface IConfigurableListableObjectFactory
		extends IConfigurableObjectFactory, IListableObjectFactory {

		/**
		 * Instantiates all definitions that are defined as singleton and are not lazy.
		 */
		function preInstantiateSingletons():void;

	}
}