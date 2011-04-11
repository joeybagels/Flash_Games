package org.pranaframework.ioc.factory.config {

	public interface IObjectFactoryPostProcessor {

		function postProcessObjectFactory(objectFactory:IConfigurableListableObjectFactory):void;

	}
}