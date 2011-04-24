/**
 * Cover by Big Spaceship. 2009
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
	import flash.events.EventDispatcher;
	
	/**
	 *  The <code>Cover</code> Class covers the site. e.g while Navigation / transitions are in progress.
	 *
	 *  @param			$mc: a MovieClip that is the view and contains all the display objects to be controlled by this Class
	 *  @copyright 		2009 Big Spaceship, LLC
	 *  @author			Daniel Scheibel
	 *  @version		1.0
	 *  @langversion	ActionScript 3.0
	 *  @playerversion	Flash 9.0.41
	 *
	 */
	
	public class Cover extends EventDispatcher{
		
		private var _mc:MovieClip;
		private var _stageSize:Boolean;
		 
		public function get mc():MovieClip{ 
			return _mc; 
		}
		
		public function Cover($mc:MovieClip=null){
			
			if($mc){
				_mc = $mc;
			}else{
				_mc = new MovieClip();
				_mc.graphics.beginFill(0xff0000);
				_mc.graphics.drawRect(0,0,100,100);
				_mc.graphics.endFill();
			}
			
			_mc.alpha = 0;
			_mc.visible = false;
		}
				
		public function animateIn():void{
			if(_mc.stage){
				_mc.width = _mc.stage.stageWidth;
				_mc.height = _mc.stage.stageHeight;
			}
			_mc.visible = true;
			dispatchEvent(new AnimationEvent(AnimationEvent.IN));
		}
		
		public function animateOut():void{
			_mc.visible = false;
			dispatchEvent(new AnimationEvent(AnimationEvent.OUT));
		}
	}
}