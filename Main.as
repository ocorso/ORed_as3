package {
	
	import com.bigspaceship.display.PreloaderClip;
	import com.bigspaceship.display.SiteLoader;
	import com.bigspaceship.loading.BigLoader;
	import com.bigspaceship.utils.Environment;
	import com.bigspaceship.utils.Out;
	import com.bigspaceship.utils.adaptors.ArthropodAdapter;
	import com.bigspaceship.utils.adaptors.FirebugAdapter;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import net.ored.model.Constants;
	import net.ored.model.Model;
	import net.ored.views.Homepage;
	import net.ored.views.Indicator;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.osflash.signals.natives.NativeSignal;

	[SWF(width="713", height="370", backgroundColor="#ffffff", frameRate="30")]
	public class Main extends MovieClip
	{
		private static const __LOAD_STATE_INIT						:String 		= "init";
		private static const __LOAD_STATE_COMPONENTS_BEGIN			:String			= "initialLoadAssetsInit";
		private static const __LOAD_STATE_COMPONENTS_COMPLETE		:String			= "initialLoadAssetsLoaded";
		private static const __LOAD_STATE_INITIAL_SCREEN_BEGIN		:String			= "initialLoadScreenBegin";
		private static const __LOAD_STATE_SCREEN_BEGIN				:String			= "screenLoadBegin";
		private static const __LOAD_STATE_SCREEN_COMPLETE			:String			= "screenLoadComplete";
		private static const __LOAD_STATE_SCREEN_SPECIFICS_BEGIN	:String			= "screenComponentLoadBegin";
		private var _loadState										:String;
		private var _m								:Model;
		private var _pl								:PreloaderClip;
		private var debugger						:MonsterDebugger;
		protected var stateNames					:Array = ["intro"];
		protected var stateArray					:Array = [];
		
		protected var slide:Sprite;
		protected var indicator:Indicator;
		protected var counter:int = 0;
		protected var nextState:Homepage;
		
		protected var timer:Timer;
		protected const timerDelay:Number = 3000;
		protected var run:NativeSignal;
		protected var isFirst:Boolean = true;
		protected var isInBrowser:Boolean = true;
		
		protected var _cl:URLLoader;
		protected var _bl:BigLoader;
		
		private const configId:String
		public function Main()
		{
			if(!stage) addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			else _init();

		}//end constructor
		
		protected function _init($evt:Event = null):void{
			Out.status(this, "init()::");
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			
			_m = Model.getInstance();
			_m.initialize(stage.loaderInfo);
			
			if(!Environment.IS_IN_BROWSER){
				Out.enableAllLevels();
				Out.registerDebugger(new ArthropodAdapter(true));
				
				isInBrowser = false;
			}else{
				_pl = SiteLoader.getInstance().preloader_mc;
				_pl.addEventListener(Event.COMPLETE, _onPreloderOut);
			}

			_loadConfigXML();
			
		}//end function init
		protected function _loadConfigXML():void{
			_cl = new URLLoader();
			var configURL:String = _m.getBaseUrl() + Constants.CONFIG_XML_PATH + "config.xml";
			var urlRequest:URLRequest = new URLRequest(configURL);
			_cl.addEventListener(Event.COMPLETE, _onConfigXMLLoaded);
			_cl.load(urlRequest);
		}//end function
		protected function _onConfigXMLLoaded($evt):void{
			Out.status(this, "config xml loaded");
			_m.configXml = new XML($evt.target.data);
			_cl.removeEventListener(Event.COMPLETE, _onConfigXMLLoaded);
			_cl = null;
			
			_loadState = __LOAD_STATE_COMPONENTS_BEGIN;
			_bl = BigLoader("ComponentsID");
			_bl.addEventListener(Event.COMPLETE,  _onComponentsLoaded);
			_onComponentsLoaded();
			//_createScreens();
		}//end functoin
		protected function _onPreloderOut($evt:Event):void{
			showFirstState();
			
		}
		private function _onComponentsLoaded($evt=null):void{
			Out.status(this, "on comp load complete");
			if (isInBrowser) _pl.setComplete();
			else 				showFirstState();
		}//end function
		
		protected function createScreens():void{
		
		}//end create screens
		

		protected function showFirstState():void{
			Out.status(this, "showFirstState():");

			var mc:MovieClip = new Fpo();
			addChild(mc);
			mc.gotoAndPlay("IN_START");
		}//end show first state

	
	}//end class
}//end package

