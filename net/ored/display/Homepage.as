package net.ored.display
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.ored.model.Model;
	
	import org.osflash.signals.natives.NativeSignal;

	public class Homepage extends Sprite implements IScreen 
	{
		private var _m				:Model;
		public var stateName	:String;
		public var clicked		:NativeSignal;
		
		public function Homepage(stateName:String)
		{
			super();
			_m = Model.getInstance();
			this.stateName = stateName;
			init();			
		}//end constructor
		
		protected function init():void{
			

			clicked = new NativeSignal(this, MouseEvent.CLICK, MouseEvent);
			this.buttonMode = true;
		}//end function init
		
		public function show():void
		{
			//TODO: implement function
			
		}//end function show
		
		public function hide():void
		{
			//TODO: implement function
		}
		
		public function get id():String
		{
			//TODO: implement function
			return null;
		}
		
		
		private function _createIndicator():void{
			
		}//end function
	}//end class State
}//end package