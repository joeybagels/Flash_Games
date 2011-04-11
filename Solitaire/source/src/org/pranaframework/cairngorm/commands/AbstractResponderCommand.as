package org.pranaframework.cairngorm.commands {
	
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.errors.IllegalOperationError;
	
	import mx.rpc.IResponder;
	
	import org.pranaframework.cairngorm.business.IBusinessDelegate;
	import org.pranaframework.cairngorm.business.IBusinessDelegateAware;
	import org.pranaframework.utils.Assert;
	
	/**
	 * 
	 */
	public class AbstractResponderCommand implements ICommand, IBusinessDelegateAware, IResponder {
		
		private var _businessDelegate:IBusinessDelegate;
		
		public function AbstractResponderCommand() {
		}
		
		public function get businessDelegate():IBusinessDelegate {
			return _businessDelegate;
		}
		
		public function set businessDelegate(value:IBusinessDelegate):void {
			_businessDelegate = value;
		}
		
		public function execute(event:CairngormEvent):void {
			Assert.state(businessDelegate != null, "The business delegate cannot be null");
		}
		
		public function result(data:Object):void {
			throw new IllegalOperationError("result must be implemented");
		}
		
		public function fault(info:Object):void {
			throw new IllegalOperationError("fault must be implemented");
		}
		
	}
}