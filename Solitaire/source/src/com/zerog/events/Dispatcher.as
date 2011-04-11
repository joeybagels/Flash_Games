package com.zerog.events {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;		

	/**
	 * Singleton event dispatcher
	 *  
	 * @author Chris.Lam
	 * 
	 */
	public class Dispatcher extends EventDispatcher {
		private static var dispatcher:Dispatcher;
		private static var target:IEventDispatcher;
		
		public function Dispatcher(target:IEventDispatcher, pvt:PrivateClass) {
			this.target = target;
		}

		public static function getInstance(target:IEventDispatcher = null):Dispatcher {
			if (dispatcher == null) {
				dispatcher = new Dispatcher(target, new PrivateClass());
			}
			
			return dispatcher;
		}
		
		override public function dispatchEvent(e:Event):Boolean {
			if (this.target == null) {
				return super.dispatchEvent(e);
			}
			else {
				return this.target.dispatchEvent(e);
			}
		}
	}
}

class PrivateClass {
	public function PrivateClass() {
	}
}