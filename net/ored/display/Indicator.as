package net.ored.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	
	import org.osflash.signals.natives.NativeSignal;
	
	public class Indicator extends Sprite
	{
		public var mc:Indicator_mc;
		
		//here are what are supposed to be events
		public var introSignal:NativeSignal;
		public var partySignal:NativeSignal;
		public var springSignal:NativeSignal;
		public var diySignal:NativeSignal;
		public var antiSignal:NativeSignal;
		
		public function Indicator()
		{
			
			super();
			mc = new Indicator_mc();
			init();
		}//end constructor
		
		protected function init():void{
			addShadow();
			enableButtons();
			this.addChild(mc);
			
		}//end function init
		protected function addShadow():void{
			var filter:BitmapFilter = getBitmapFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			filters = myFilters;
			
		}//end function addShawdow
		private function getBitmapFilter():BitmapFilter {
			var color:Number = 0xFFFFFF;
			var angle:Number = 45;
			var alpha:Number = 0.8;
			var blurX:Number = 3;
			var blurY:Number = 3;
			var distance:Number = 0;
			var strength:Number = 2;
			var inner:Boolean = false;
			var knockout:Boolean = false;
			var quality:Number = BitmapFilterQuality.LOW;
			return new DropShadowFilter(distance,
				angle,
				color,
				alpha,
				blurX,
				blurY,
				strength,
				quality,
				inner,
				knockout);
		}//end getBitmapFilter
		
		protected function enableButtons():void{
			//instantiate signals
			introSignal = new NativeSignal(mc.intro, MouseEvent.CLICK, MouseEvent);
			partySignal = new NativeSignal(mc.party, MouseEvent.CLICK, MouseEvent);
			springSignal = new NativeSignal(mc.spring, MouseEvent.CLICK, MouseEvent);
			diySignal = new NativeSignal(mc.diy, MouseEvent.CLICK, MouseEvent);
			antiSignal = new NativeSignal(mc.anti, MouseEvent.CLICK, MouseEvent);
			
			mc.intro.buttonMode = true;
			mc.party.buttonMode = true;
			mc.spring.buttonMode = true;
			mc.diy.buttonMode = true;
			mc.anti.buttonMode = true;
		} //end add listeners
		
	}//end class
}//end package

