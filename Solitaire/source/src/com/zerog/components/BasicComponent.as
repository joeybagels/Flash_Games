package com.zerog.components {
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;	

	/**
	 * @author Chris
	 * The base class for components
	 */
	public class BasicComponent extends MovieClip {
		protected var dispatcher:IEventDispatcher;

		public function BasicComponent(dispatcher:IEventDispatcher = null) {
			if (dispatcher == null) {
				this.dispatcher = this;
			}
			else {
				this.dispatcher = dispatcher;
			}
		}
	}
}
