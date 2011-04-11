package com.zerog.components.dialogs
{
	import flash.display.DisplayObjectContainer;
	
	public interface IDialog
	{
		function getParentContainer():DisplayObjectContainer;
		function setParent(parentContainer:DisplayObjectContainer):void;
		function showDialog(x:Number = Number.NaN, y:Number = Number.NaN):void;
		function showDialogAt(x:Number = Number.NaN, y:Number = Number.NaN, index:int = 0):void;
		function removeDialog():void;
	}
}