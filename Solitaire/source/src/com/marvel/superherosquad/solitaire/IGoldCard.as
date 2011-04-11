package com.marvel.superherosquad.solitaire
{
	public interface IGoldCard
	{
		function reset():void;
		function showSuit(suit:int):void;
		function dropCoins():void;
		function set x(n:Number):void;
		function set y(n:Number):void;
	}
}