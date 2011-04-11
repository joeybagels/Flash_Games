package com.zerog.components.multilevelmenu {
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	import com.adobe.utils.ArrayUtil;
	import com.zerog.components.list.LinearList;
	import com.zerog.events.MultiLevelMenuEvent;	

	/**
	 * @author Chris
	 */
	public class AbstractMenuPanel extends LinearList {

		public function AbstractMenuPanel() {
			if (getQualifiedClassName(this) == "com.zerog.components.multilevelmenu::AbstractMenuPanel") {
				throw new ArgumentError("AbstractMenuPanel can't be instantiated directly");
			}
		}

		override public function setItems(listItems:Array):void {
			super.setItems(listItems);
			
			//if no event listener yet, attach one
			if (!hasEventListener(MultiLevelMenuEvent.ITEM_OVER)) {
				addEventListener(MultiLevelMenuEvent.ITEM_OVER, onItemOver);
			}
			
			dispatchEvent(new Event(Event.RESIZE));
		}

		
		protected function onItemOver(e:MultiLevelMenuEvent):void {
			var item:AbstractMultiLevelMenuItem = e.target as AbstractMultiLevelMenuItem;
			
			//only if its a party of your list
			if (ArrayUtil.arrayContainsValue(this.listItems, item)) {
				for each (var mlmi:AbstractMultiLevelMenuItem in this.listItems) {
					//if not the item that fired the event
					if (item != mlmi) {
						//hide it's menu panel
						mlmi.removeMenuPanel();
					}
				}
			}
		}

		public function removeChildren():void {
			//for each item 
			for each (var cmi:AbstractMultiLevelMenuItem in this.listItems) {
				//remove its children
				cmi.removeChildren();
			}
		}
	}
}
