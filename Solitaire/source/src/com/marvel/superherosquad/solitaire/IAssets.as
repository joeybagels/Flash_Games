package com.marvel.superherosquad.solitaire
{
	import com.zerog.components.buttons.AbstractButton;
	import com.zerog.components.dialogs.IDialog;
	import flash.display.MovieClip;
	
	public interface IAssets
	{
		function getGoldCards():IGoldCard;
		function getBonusCardAnimation(name:String):BonusCardAnimation;
		function getBonusCard(name:String):IBonusCard;
		function getButton(name:String):AbstractButton;
		function getMovieClip(name:String):MovieClip;
		function getOptionsMenu():OptionsMenu;
		function getHowToPlay():IDialog;
	}
}