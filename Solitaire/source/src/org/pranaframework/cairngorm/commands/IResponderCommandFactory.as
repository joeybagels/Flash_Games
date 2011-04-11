package org.pranaframework.cairngorm.commands {
	
	import org.pranaframework.cairngorm.business.IBusinessDelegateFactory;
	
	public interface IResponderCommandFactory extends ICommandFactory {
		
		function addBusinessDelegateFactory(businessDelegateFactory:IBusinessDelegateFactory, commandClasses:Array):void;
		
	}
}