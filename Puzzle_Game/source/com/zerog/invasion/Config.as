/***************************************************************

	Copyright 2008, Zero G Games Limited.
	
	Redistribution of part or whole of this file and
	the accompanying files is strictly prohibited.
	
	Redistribution of modified versions of this file and
	the accompaying files is also strictly prohibited.
	
****************************************************************/
	
	
	
package com.zerog.invasion {
	public class Config {
		public static var GROUPSIZE:int = 3;
		
		//public static var BLOCKSIZE:Number = 40;
		// public static var BLOCKSIZE:Number = 48;
		public static var BLOCKSIZE:Number = 52;
		
		public static var GEMS_TYPES:int = 8;
		//public static var GEMS_TYPES:int = 5;
		
		public static var BLOCK_TYPES:int = 9;
		public static var POWERUP_TYPES:int = 18;
		public static var GEM_TYPE_RND_COLOR1:int = 10;//11;
		public static var GEM_TYPE_RND_COLOR2:int = 11;//12;
		public static var GEM_TYPE_RND_DIR1:int = 9;
		public static var GEM_TYPE_RND_DIR2:int = 12;//13;
		public static var GEM_TYPE_ROWS:int = 17;
		
		public static var PUP_WAITTIME:int = 2000;//1250;//750;
		public static var PUP_COLORWAITTIME:int = 750;
		public static var PUP_TYPE_DESTROY:int = 0;
		public static var PUP_TYPE_COLOR:int = 1;
		public static var DIR_ROWS:int = -2;
		public static var DIR_ALL:int = -1;
		public static var DIR_UP:int = 0;
		public static var DIR_UPRIGHT:int = 1;
		public static var DIR_DOWNRIGHT:int = 2;
		public static var DIR_DOWN:int = 3;
		public static var DIR_DOWNLEFT:int = 4;
		public static var DIR_UPLEFT:int = 5;
		public static var COLOR_ALL:int = -1;
		
		public static var PUP_TYPE_1:int = 9;
		public static var PUP_TYPE_2:int = 10;
		public static var PUP_TYPE_3:int = 11;
		public static var PUP_TYPE_4:int = 12;
		public static var PUP_TYPE_5:int = 13;
		public static var PUP_TYPE_6:int = 14;
		public static var PUP_TYPE_7:int = 15;
		public static var PUP_TYPE_8:int = 16;
		public static var PUP_TYPE_9:int = 17;
		
		
		/*
		public static var GEMS_LEFT:Number = 180;
		//public static var GEMS_TOP:Number = 0;
		public static var GEMS_TOP:Number = 70;
		//public static var GEMS_RIGHT:Number = 580;
		//public static var GEMS_BOTTOM:Number = 400;
		public static var GEMS_RIGHT:Number = 610;
		public static var GEMS_BOTTOM:Number = 500;
		
		public static var GEMS_LEFT:Number = 120;//170;
		public static var GEMS_TOP:Number = 140;
		public static var GEMS_RIGHT:Number = 642;
		public static var GEMS_BOTTOM:Number = 602;
		*/
		
		public static var GEM_STATE_PRE:int = 0;
		public static var GEM_STATE_INTRO:int = 1;
		public static var GEM_STATE_READY:int = 2;
		public static var GEM_STATE_DESTROY:int = 3;
		
		public static var GEMS_LEFT:Number = 120;
		public static var GEMS_TOP:Number = 110;
		public static var GEMS_RIGHT:Number = 642;
		public static var GEMS_BOTTOM:Number = 572;
		
		public static var GEM_START_X:Number = 500;
		//public static var GEM_START_Y:Number = -60;
		
		//public static var GEM_START_Y:Number = -30;
		public static var GEM_START_Y:Number = -43;
		
		//public static var GEM_PUP_START_X:Number = -40;
		public static var GEM_PUP_START_X:Number = -160;
		//public static var GEM_PUP_START_Y:Number = -30;
		public static var GEM_PUP_START_Y:Number = -40;
		
		public static var GEMS_INIT_ACCELERATION:Number = 500;
		//public static var GEMS_ACCELERATION:Number = 1000;
		public static var GEMS_ACCELERATION:Number = 400;
		public static var GEMS_SWAPTIME:int = 200;
		public static var GEMS_DESTROYTIME:int = 200;
		public static var GEMS_DESTROYROTATE:Number = 180;
		
		public static var LEVEL_CLEAR_TIME:int = 50;
		
		
		public static var SCORE_GROUP:int = 10;
		public static var SCORE_EXTRAGEM:int = 5;
		public static var SCORE_EXTRAGROUP:int = 10;
		public static var SCORE_COMBO:int = 10;
		public static var SCORE_LEVEL:int = 500;
		public static var SCORE_UNUSED_SPECIAL:int = 100;
		
		public static var SCOREPOPUP_PREFIX:String = '+';
		public static var SCOREPOPUP_MOVETIME:int = 400;//200;
		public static var SCOREPOPUP_MOVEHEIGHT:Number = 80;//40;//30;
		public static var SCOREPOPUP_STAYTIME:int = 500;
		
		public static var LEVEL_INITIALTIME:int = 400000;
		public static var LEVEL_TIMEDECREASE:int = 2000;
		
		
		public static var LEVEL_MATCHES_REQ_BASE:int = 10;//25;
		public static var LEVEL_MATCHES_REQ_MULT:int = 5;
		public static var LEVEL_COLORS_BASE:int = 5;
		
		
		public static var LEVEL_BLOCK_FREQ:Number = 0.075;
		//public static var LEVEL_BLOCK_FREQ_LEVEL_INC:Number = 0.002;
		//public static var LEVEL_BLOCK_FREQ_MAX:Number = 0.2;
		public static var LEVEL_BLOCK_FREQ_LEVEL_INC:Number = 0.005;
		public static var LEVEL_BLOCK_FREQ_MAX:Number = 0.325;
		
		public static var SPEC_FREQ:Number = 0.01;
		//public static var SPEC_FREQ_LEVEL_INC:Number = 0.002;
		//public static var SPEC_FREQ_MAX:Number = 0.2;
		public static var SPEC_FREQ_LEVEL_INC:Number = 0.003;
		public static var SPEC_FREQ_MAX:Number = 0.3;
		/*
		public static var SPEC_FREQ_1:Number = 0.12;
		public static var SPEC_FREQ_2:Number = 0.11;
		public static var SPEC_FREQ_3:Number = 0.11;
		public static var SPEC_FREQ_4:Number = 0.11;
		public static var SPEC_FREQ_5:Number = 0.11;
		public static var SPEC_FREQ_6:Number = 0.11;
		public static var SPEC_FREQ_7:Number = 0.11;
		public static var SPEC_FREQ_8:Number = 0.11;
		public static var SPEC_FREQ_9:Number = 0.11;
		*/
		public static var SPEC_FREQ_1:Number = 0.12;
		public static var SPEC_FREQ_2:Number = 0.12;
		public static var SPEC_FREQ_3:Number = 0.11;
		public static var SPEC_FREQ_4:Number = 0.12;
		public static var SPEC_FREQ_5:Number = 0.12;
		public static var SPEC_FREQ_6:Number = 0.12;
		public static var SPEC_FREQ_7:Number = 0.12;
		public static var SPEC_FREQ_8:Number = 0.12;
		public static var SPEC_FREQ_9:Number = 0.05;
		/*
		public static var LEVEL_BLOCK_FREQ:Number = 0.025;
		public static var SPEC_FREQ_1:Number = 0.025;
		public static var SPEC_FREQ_2:Number = 0.02;
		public static var SPEC_FREQ_3:Number = 0.0125;
		public static var SPEC_FREQ_4:Number = 0.01;
		public static var SPEC_FREQ_5:Number = 0.0175;
		public static var SPEC_FREQ_6:Number = 0.02;
		public static var SPEC_FREQ_7:Number = 0.0075;
		public static var SPEC_FREQ_8:Number = 0.0125;
		public static var SPEC_FREQ_9:Number = 0.005;
		*/
		
		public static var LEVEL_INFOS:Array = [
			[
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000'
			],
			[
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000',
				'00000000'
			]
		];
		/*
			[
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000'
			],
			[
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000',
				'0000000000'
			]
		*/
		
		public static var MESSAGE_LEVELTIME:int = 1000;
		public static var MESSAGE_LEVELCLEARTIME:int = 2000;
		public static var MESSAGE_GAMEOVERTIME:int = 1000;
	}
}