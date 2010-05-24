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
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import net.ored.model.Constants;
	import net.ored.model.Model;
	import net.ored.display.Homepage;
	import net.ored.display.Indicator;
	
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
		protected var _ll:XMLList;
		
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
			var configURL:String = _m.getBaseUrl() + Constants.WP_PATH + Constants.XML_PATH + "config.xml";
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
			_ll = _m.getNodeByType(Constants.CONFIG_LOADABLES, Constants.CONFIG_COMPONENTS).component;
			_startLoad();
		}//end function
		protected function _onPreloderOut($evt:Event):void{
			showFirstState();
		}
		
		private function _onComponentLoadComplete($evt=null):void{
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
		
		private function _loaderCleanUp():void {
			if(_bl) {
				_bl.addEventListener(ProgressEvent.PROGRESS,_onLoadProgress);
				_bl.addEventListener(Event.COMPLETE, _onComponentLoadComplete);
				_bl.destroy();
				_bl = null;
			}
		}
		private function _startLoad():void{
			Out.status(this, "startLoad()::");
			
			_loaderCleanUp();
			_bl = new BigLoader();
			_bl.addEventListener(ProgressEvent.PROGRESS, _onLoadProgress, false,0,true);
			_bl.addEventListener(Event.COMPLETE, _onComponentLoadComplete, false, 0, true);
			
			for (var n:uint = 0; n<_ll.length(); n++){
				var swfPath:String = _ll[n].@swf || "";
				var xmlPath:String = _ll[n].@xml || "";
				if(swfPath!="") _bl.add(_m.getFilePath(swfPath, "swf"), _ll[n].@id +"_"+Constants.TYPE_SWF);
				if(swfPath!="") _bl.add(_m.getFilePath(xmlPath, "xml"), _ll[n].@id +"_"+Constants.TYPE_XML);
			}//end for
			_bl.start();
			
		}//end function _startLoad

		private function _onLoadProgress($evt:ProgressEvent):void {
			var itemsLoaded:Number = 0;
			var itemsTotal:Number = 0;
			
			switch(_loadState)
			{
				case __LOAD_STATE_SCREEN_BEGIN:
					itemsLoaded = 0;
					itemsTotal = 2;
					break;
				
				case __LOAD_STATE_SCREEN_COMPLETE:
					itemsLoaded = 2;
					itemsTotal = 2;
					break;
				
				case __LOAD_STATE_SCREEN_SPECIFICS_BEGIN:
					itemsLoaded = 1;
					itemsTotal = 2;
					break;
				
				case __LOAD_STATE_INITIAL_SCREEN_BEGIN:
				case __LOAD_STATE_COMPONENTS_COMPLETE:
					itemsLoaded = 1;
					itemsTotal = 3;
					break;
				
				case __LOAD_STATE_INITIAL_SCREEN_BEGIN:
					itemsLoaded = 0;
					itemsTotal = 3;
					break;
			}
			
			if(_pl) _pl.updateProgress($evt.bytesLoaded,$evt.bytesTotal,itemsLoaded,itemsTotal);
		}
	}//end class
}//end package

