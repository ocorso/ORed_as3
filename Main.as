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
		
		protected var cl:URLLoader;
		protected var l:BigLoader;
		
		private const configId:String
		public function Main()
		{
			if(!stage) addEventListener(Event.ADDED_TO_STAGE,_init,false,0,true);
			else _init();
			
			_init();
		}//end constructor
		
		protected function _init():void{
			Out.status(this, "init()::");
			removeEventListener(Event.ADDED_TO_STAGE,_init);
			
			_m = Model.getInstance();
			_m.initialize();
			
			if(!Environment.IS_IN_BROWSER){
				Out.enableAllLevels();
				Out.registerDebugger(new ArthropodAdapter(true));
				Out.registerDebugger(new FirebugAdapter());
				isInBrowser = false;
			}
			_loadConfigXML();
			createTimer();
			if(isInBrowser){
				_pl = SiteLoader.getInstance().preloader_mc;
				_pl.addEventListener(Event.COMPLETE, _onPreloderOut);
			}else 
				showFirstState();
			
		}//end function init
		protected function _loadConfigXML():void{
			cl = new URLLoader();
			var configURL:String = _m.getBaseUrl() + Constants.CONFIG_XML_PATH + "config.xml";
			var urlRequest:URLRequest = new URLRequest(configURL);
			cl.addEventListener(Event.COMPLETE, _onConfigXMLLoaded);
			cl.load(urlRequest);
		}//end function
		protected function _onConfigXMLLoaded($evt):void{
			Out.status(this, "config xml loaded");
			_m.configXml = new XML($evt.target.data);
			cl.removeEventListener(Event.COMPLETE, _onConfigXMLLoaded);
			cl = null;
			
			_loadState = __LOAD_STATE_COMPONENTS_BEGIN;
			//l = BigLoader("ComponentsID");
			//l.addEventListener(Event.COMPLETE,  _onComponentsLoaded);
			_onComponentsLoaded();
			//_createScreens();
		}//end functoin
		protected function _onPreloderOut($evt:Event):void{
			showFirstState();
			
		}
		private function _onComponentsLoaded($evt=null):void{
			Out.status(this, "on comp load complete");
			_pl.setComplete();
		}//end function
		
		protected function createScreens():void{
			slide = new Sprite();
			var fakeSprite:Shape = new Shape();
			slide.addChild(fakeSprite);
			addChild(slide);
			
			for each (var name:String in stateNames){
				trace(name);
				var locState:Homepage = new Homepage(name);
				//locState.clicked.add(slideClicked);
				stateArray.push(locState);
			}//end for
			
		}//end create states
		protected function createIndicator():void{
			indicator = new Indicator();
			indicator.x = 608;
			indicator.y = 344;
			indicator.introSignal.add(indicatorClicked);
			//indicator.partySignal.add(indicatorClicked);
			//indicator.springSignal.add(indicatorClicked);
			//indicator.diySignal.add(indicatorClicked);
			//indicator.antiSignal.add(indicatorClicked);
			addChild(indicator);
			
		}//end create Indicator function
		protected function createTimer():void{
			timer = new Timer(timerDelay);
			run = new NativeSignal(timer, TimerEvent.TIMER, TimerEvent);
			run.add(switchState);
		}//end createTimer
		
		protected function showFirstState():void{
			Out.status(this, "showFirstState():");
			//nextState = stateArray[0];
			//switchState();			
			//timer.start();
			var mc:MovieClip = new Fpo();
			addChild(mc);
			mc.gotoAndPlay("IN_START");
		}//end show first state
		protected function switchState(e:TimerEvent=null):void{
			indicator.mc.gotoAndStop(counter+1);
			slide.addChildAt(nextState, 0);
			var toFadeOut:DisplayObject = slide.getChildAt(1);
			TweenLite.to(toFadeOut, .5, {alpha:0, onComplete:updateCurrent});
			
		}//end switch State
		
		protected function updateCurrent():void{
			
			if(counter == 4) counter=  0 
			else counter++;
			nextState = stateArray[counter];
			slide.removeChildAt(slide.numChildren-1);
			
			//reset alpha
			for each (var state:Homepage in stateArray){
				state.alpha = 1;
			}//end for each
			
		}//end fucntion update current
		
		
		
		protected function indicatorClicked(e:MouseEvent):void{
			var desiredSlide:String = e.target.name;
			if (desiredSlide == Homepage(slide.getChildAt(0)).stateName){
				trace("do nothing");
			}else{
				trace("we want to fade to: "+desiredSlide);
				timer.reset();
				switch (desiredSlide){
					case "sweeps": counter = 0;
						break;
					case "party" : counter = 1;
						break;
					case "spring" : counter = 2;
						break;
					case "diy" : counter = 3;
						break;
					case "anti" : counter = 4;
					default : counter = 0;		
				}//end switch
				timer.start();
				nextState = stateArray[counter];
				switchState();
			}//end else
		}//end indicator clicked
	
	}//end class
}//end package

