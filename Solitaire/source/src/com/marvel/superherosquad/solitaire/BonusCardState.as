package com.marvel.superherosquad.solitaire
{
	public class BonusCardState
	{
		public static const IRON_MAN_TYPE:uint = 1;
		public static const THOR_TYPE:uint = 2;
		public static const HULK_TYPE:uint = 3;
		public static const WOLVERINE_TYPE:uint = 4;
		public static const DR_DOOM_TYPE:uint = 5;
		public static const MS_MARVEL_TYPE:uint = 6;
		public static const CAPTAIN_AMERICA_TYPE:uint = 7;
		
		private var type:uint;
		private var count:uint;
		
		public function BonusCardState() {
		}
		
		public function getType():uint {
			return this.type;
		}

		public function setType(type:uint):void {
			this.type = type;
		}

		public function getCount():uint {
			return this.count;
		}

		public function setCount(count:uint):void {
			this.count = count;
		}
	}
}