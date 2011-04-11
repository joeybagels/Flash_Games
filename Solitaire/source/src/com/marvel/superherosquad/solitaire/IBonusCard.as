package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.list.IListItem;
	
	import flash.events.IEventDispatcher;
	
	public interface IBonusCard extends IEventDispatcher, IListItem
	{
		function set enabled(en:Boolean):void;
		function increment():void;
		function decrement():void;
		function getCount():uint;
		function setCount(count:uint):void;
		function get width():Number;
		function get height():Number;
		function helpBubble(title:String, text:String):void;
		function setSelectOnClick(s:Boolean):void;
		function removeBubble():void;
	}
}