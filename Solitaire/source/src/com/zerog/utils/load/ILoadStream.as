package com.zerog.utils.load {
	import flash.utils.ByteArray;	
	import flash.events.IEventDispatcher;		

	/**
	 * @author Chris
	 */
	public interface ILoadStream extends IEventDispatcher {
		function getData():*;
		
		function getUrl():String; 
		
		function getByteArray():ByteArray;
		
		function getType():uint;
		
		function getId():String;
		
		function getStatus():String;

		function getPercentLoaded():Number;

		function getTotalBytes():Number;

		function getBytesLoaded():Number;
		
		function setLoader(loader:IEventDispatcher):void;
	}
}
