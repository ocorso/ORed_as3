/**
 * StandardInOut by Big Spaceship. 2009
 *
 * To contact Big Spaceship, email info@bigspaceship.com or write to us at 45 Main Street #716, Brooklyn, NY, 11201.
 * Visit http://labs.bigspaceship.com for documentation, updates and more free code.
 *
 *
 * Copyright (c) 2009 Big Spaceship, LLC
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/
 
package com.bigspaceship.display
{
	import com.bigspaceship.events.AnimationEvent;
	
	import flash.display.MovieClip;
	
	/**
	 * Dispatched when IN animation starts (IN_START label reached)
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="animateInStart", type="com.bigspaceship.events.AnimationEvent")]
	
	/**
	 * Dispatched when In animation is complete (IN label reached)
	 * 
	 * @eventType flash.events.Event
	 **/
	[Event(name="animateIn", type="com.bigspaceship.events.AnimationEvent")]
	
	/**
	 * Dispatched Out animation starts (OUT_START label reached)
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="animateOutStart", type="com.bigspaceship.events.AnimationEvent")]
	
	/**
	 * Dispatched Out animation is complete (OUT label reached)
	 *
	 * @eventType flash.events.Event
	 **/
	[Event(name="animateOut", type="com.bigspaceship.events.AnimationEvent")]
	
	
	/**
	 * The <code>StandardInOut</code> Class
	 * 
	 * @copyright 		2009 Big Spaceship, LLC
	 * @author			Jamie Kosoy, Daniel Scheibel
	 * @version			1.0 
	 * @langversion		ActionScript 3.0 			
	 * @playerversion 	Flash 9.0.0
	 *
	 */
	public class StandardInOut extends Standard
	{
		
		protected var _dispatchCompleteOnUnchangedState:Boolean = true;
		
		public function set dispatchCompleteOnUnchangedState($val:Boolean):void{
			_dispatchCompleteOnUnchangedState = $val;
		}
		public function get dispatchCompleteOnUnchangedState():Boolean{
			return _dispatchCompleteOnUnchangedState;
		}
		
		public function get isAnimating():Boolean{
			return (_curState == AnimationState.IN_START || _curState == AnimationState.OUT_START) ? true : false;
		}
		
		
		public function StandardInOut($mc:MovieClip, $useWeakReference:Boolean = false){
			super($mc, $useWeakReference);
			
			//ds: on INIT-Frame : ScreenState.OUT
			_curState = AnimationState.OUT;
			
			_mc.addEventListener(AnimationEvent.INIT, _onAnimateInit_handler, false, 0, _useWeakReference);
			_mc.addEventListener(AnimationEvent.IN_START, _onAnimateInStart_handler, false, 0, _useWeakReference);
			_mc.addEventListener(AnimationEvent.IN, _onAnimateIn_handler, false, 0, _useWeakReference);
			_mc.addEventListener(AnimationEvent.OUT_START, _onAnimateOutStart_handler, false, 0, _useWeakReference);
			_mc.addEventListener(AnimationEvent.OUT, _onAnimateOut_handler, false, 0, _useWeakReference);
			_mc.addEventListener(AnimationEvent.UPDATE, _onAnimateUpdate_handler, false, 0, _useWeakReference);
			
			//_mc.visible = false;
		};
		
		/**
		 *  
		 * @param $forceAnim Forces the MovieClip to animate in no matter what the current Screenstate is.
		 * 
		 */		
		public function animateIn($forceAnim:Boolean=false):void{
			_mc.visible = true;
			if((_curState != AnimationState.IN_START && _curState != AnimationState.IN) || $forceAnim ){
				//trace("animateIn");
				_buildIn();
				_curState = AnimationState.IN_START;
			}else if(_curState == AnimationState.IN && _dispatchCompleteOnUnchangedState){
				dispatchEvent(new AnimationEvent(AnimationEvent.IN));
			}		
		}
		
		/**
		 * 
		 * @param $forceAnim Forces the MovieClip to animate Out no matter what the current Screenstate is.
		 * 
		 */		
		public function animateOut($forceAnim:Boolean=false):void{
			//trace("animate out called");
			if((_curState == AnimationState.IN && _curState != AnimationState.OUT_START && _curState != AnimationState.OUT) || $forceAnim){
				_curState = AnimationState.OUT_START;
				_buildOut();
			}else if(_curState == AnimationState.OUT && _dispatchCompleteOnUnchangedState){
				dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
			}
		}
		
		
		// in, extend these
		protected function _buildIn():void { _mc.gotoAndPlay("IN_START"); }
		
		protected function _onAnimateIn():void{};
		protected function _onAnimateInStart():void{};

		// out, extend these
		protected function _buildOut():void { _mc.gotoAndPlay("OUT_START"); }
		
		protected function _onAnimateOutStart():void{};
		protected function _onAnimateOut():void{};	
		
		protected function _onAnimateUpdate():void{};
		
		private function _onAnimateInit_handler($evt:AnimationEvent = null):void{ 
			_curState = AnimationState.INIT;
			_mc.stop();
			dispatchEvent(new AnimationEvent(AnimationEvent.INIT)); 
		}
		private function _onAnimateInStart_handler($evt:AnimationEvent = null):void{ 
			_curState = AnimationState.IN_START;
			_onAnimateInStart();
			dispatchEvent(new AnimationEvent(AnimationEvent.IN_START)); 
		}
	
		protected function _onAnimateIn_handler($evt:AnimationEvent = null):void{
//			trace("_onAnimateIn_handler");
			_mc.stop();
			_curState = AnimationState.IN;
			_onAnimateIn();
			dispatchEvent(new AnimationEvent(AnimationEvent.IN));
		}
	
		private function _onAnimateOutStart_handler($evt:AnimationEvent = null):void{ 
			_curState = AnimationState.OUT;
			_onAnimateOutStart();
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT_START)); 
		}
		
		protected function _onAnimateOut_handler($evt:AnimationEvent = null):void{ 
			_mc.stop();
			_mc.visible = false;
			_curState = AnimationState.OUT;
			_onAnimateOut();
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
		}
		
		private function _onAnimateUpdate_handler($evt:AnimationEvent = null):void{ 
			_curState = AnimationState.UPDATE;
			_onAnimateUpdate();
			dispatchEvent(new AnimationEvent(AnimationEvent.UPDATE));
		}
	}
}