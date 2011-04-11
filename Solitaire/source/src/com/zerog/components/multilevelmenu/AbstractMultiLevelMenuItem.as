package com.zerog.components.multilevelmenu {
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import com.zerog.components.buttons.AbstractBasicListButton;
	import com.zerog.events.MultiLevelMenuEvent;	

	/**
	 * @author Chris
	 */
	public class AbstractMultiLevelMenuItem extends AbstractBasicListButton {
		public var label:DisplayObject;
		
		/*
		 * Child menus positioned to the right hand side, going up
		 */
		public static const BOTTOM_RIGHT:uint = 0;
		
		/*
		 * Child menus positioned to the right hand side, going down
		 */
		public static const TOP_RIGHT:uint = 0;
		
		protected var menu:AbstractMenuPanel;
		
		protected var leaf:Boolean;

		public function AbstractMultiLevelMenuItem() {
			if (getQualifiedClassName(this) == "com.zerog.components.list::AbstractMultiLevelMenuItem") {
				throw new ArgumentError("AbstractMultiLevelMenuItem can't be instantiated directly");
			}
			
			this.leaf = true;
		}

		public function isLeaf():Boolean {
			return this.leaf;
		}

		public function getMenu():AbstractMenuPanel {
			return this.menu;
		}

		public function setMenuPanel(menu:AbstractMenuPanel):void {
			//no longer a leaf
			this.leaf = false;
			
			//set a reference
			this.menu = menu;
			
			//position it
			positionMenu();
			
			//add an event lsitener for a resize event
			menu.addEventListener(Event.RESIZE, onMenuResize);
		}

		protected function onMenuResize(e:Event):void {
			//reposition
			positionMenu();
		}

		public function showMenuPanel():void {
			throw new IllegalOperationError("operation not supported");
		}
		
		public function removeMenuPanel():void {
			throw new IllegalOperationError("operation not supported");
		}

		override protected function ourRollOut(e:MouseEvent):void {
			super.ourRollOut(e);
			
			if (this.isEnabled) {
				dispatchEvent(new MultiLevelMenuEvent(MultiLevelMenuEvent.ITEM_OUT, this.myData));
			}
		}
		
		override protected function ourRollOver(e:MouseEvent):void {
			super.ourRollOver(e);
			
			if (this.isEnabled) {
				dispatchEvent(new MultiLevelMenuEvent(MultiLevelMenuEvent.ITEM_OVER, this.myData));
			}
		}
		
		override protected function ourClick(e:MouseEvent):void {
			super.ourClick(e);
			
			//if this was clicked
			if (e.target == this && this.isEnabled) {
				//if it's a leaf node
				if (this.leaf) {
					//dispatch event
					dispatchEvent(new MultiLevelMenuEvent(MultiLevelMenuEvent.ITEM_CLICK, this.myData));
				}
			}
		}
		
		override public function getLabel():Object {
			return this.label;
		}

		/*
		 * Positions the menu
		 */
		public function positionMenu():void {
			throw new IllegalOperationError("operation not supported");
		}

		/*
		 * Positions the label
		 */
		public function positionLabel():void {
			throw new IllegalOperationError("operation not supported");
		}
		
		public function removeChildren():void {
			if (this.menu != null) {
				//remove children of menu
				this.menu.removeChildren();
				
				//remove menu itself
				removeMenuPanel();
			}
		}
	}
}
