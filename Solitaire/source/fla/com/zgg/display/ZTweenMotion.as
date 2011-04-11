package com.zgg.display
{
// ***********************************************
// Copyright 2008 by Zero G Games, Inc.
// All rights reserved.
//
// This FLASH code library is the confidential and proprietary information of Zero G Games, Inc.
// You shall not disclose such Confidential Information and shall use it only
// in accordance with the terms of the license agreement you entered into with Zero G Games.
// ***********************************************
	import flash.display.DisplayObject;
	
	import org.goasap.items.LinearGo;
	
	public class ZTweenMotion extends LinearGo
	{
		
		public function set oTarget(oTarget:DisplayObject):void
		{
			if(super._state == STOPPED)
			{
				_oTarget = oTarget;
			}
		}
		
		public function get oTarget():DisplayObject
		{
			return _oTarget;
		}
		
		
		public function set nXto(oTarget:Number):void
		{
			if(super._state == STOPPED)
			{
				_nXto = nXto;
			}
		}
		
		public function get nXto():Number
		{
			return _nXto;
		}
		
		
		public function set nYto(oTarget:Number):void
		{
			if(super._state == STOPPED)
			{
				_nYto = nYto;
			}
		}
		
		public function get nYto():Number
		{
			return _nYto;
		}
		
		
		protected var _oTarget:DisplayObject;
		protected var _nXto:Number;
		protected var _nYto:Number;
		
		public var _startX:Number;
		public var _startY:Number;
		public var _changeX:Number;
		public var _changeY:Number;
		
		public function ZTweenMotion(oTarget:DisplayObject = null,
									 nXto:Number = NaN,
									 nYto:Number = NaN,
									 easing:Function = null)
		{
			if (oTarget != null)
			{
				this._oTarget = oTarget;
			}
			
			if (isNaN(nXto) == false)
			{
				this._nXto = nXto;
			}
			
			if (isNaN(nYto) == false)
			{
				this._nYto = nYto;
			}
			
			if (easing != null)
			{
				super._easing = easing;
			}
		}
		
		//overriding because the interface is actually implemented on the class this one extends
		override public function start():Boolean
		{
			if(oTarget == null || (isNaN(nXto) && isNaN(nYto)) )
			{
				return false;
			}
			
			if (isNaN(_nXto) == false)
			{
			_startX = oTarget.x;
			_changeX = (_nXto - _startX);
			}
			
			if (isNaN(_nYto) == false)
			{
			_startY = oTarget.y;
			_changeY = (_nYto - _startY);
			}
			return super.start();
		}
		
		override protected function onUpdate(type:String):void
		{
			if (isNaN(_nXto) == false)
			{
				oTarget.x = super.correctValue(_startX + (_changeX * _position));
			//oTarget.x = _startX + (_changeX * _position);
			}
			
			if (isNaN(_nYto) == false)
			{
				oTarget.y = super.correctValue(_startY + (_changeY * _position));
			//oTarget.y = _startY + (_changeY * _position);
			}
			
			trace(super._position);
		}

	}
}