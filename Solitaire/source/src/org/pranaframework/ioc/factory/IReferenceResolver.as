package org.pranaframework.ioc.factory {
	/**
	 * The interface definting a reference resolver. Reference resolvers are used to find references 
	 * to IObjectReference implementations and resolve them.
	 * 
	 * @see org.pranaframework.ioc.factory.IObjectFactory
	 * @see org.pranaframework.ioc.factory.config.IObjectReference
	 */
	public interface IReferenceResolver {
		/**
		 * Indicates if the given property can be resolved by this reference resolver
		 * 
		 * @param property		The property to check
		 * 
		 * @return true if this reference resolver can process the given property
		 */
		function canResolve(property:Object):Boolean;
		
		/**
		 * Resolves all references of IObjectReference contained within the given property.
		 * 
		 * @param property		The property to resolve
		 * 
		 * @return The property with all references resolved
		 * 
		 * @see org.pranaframework.ioc.factory.config.IObjectReference
		 */
		function resolve(property:Object):Object;
	}
}