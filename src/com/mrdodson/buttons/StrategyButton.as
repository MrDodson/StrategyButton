package com.mrdodson.buttons
{
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.mrdodson.core.IDestroyable;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class StrategyButton implements IDestroyable
	{
		
		//—---------------------------------------------------------------
		// CLASS MEMBERS
		public var clicked						:Signal;
		
		private var _button						:MovieClip;
		private var _mouseEnabled				:Boolean;
		private var _mouseChildren				:Boolean;
		private var _isDestroyed				:Boolean;
		public var behaviors					:Array;
		public var vars							:Object;
		
		//----------------------------------------------------------------
		
		public function StrategyButton(targetButton:MovieClip, buttonBehavior:Array)
		{
			clicked = new Signal();
			vars = {};
			
			_button = targetButton;
			behaviors = buttonBehavior;
			
			addListeners();
		}
		
		// TODO: Allow timeline or code states
		
		public function selected(disableListeners:Boolean = true):void
		{
			if(disableListeners) removeListeners();

			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOver(_button) );
			}
		}
		
		public function reset(enableListeners:Boolean = true):void
		{
			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOut(_button) );
			}

			if(enableListeners) addListeners();
			
		}

		public function enable(enableListeners:Boolean = true):void
		{
			var tl:TimelineLite = new TimelineLite();
			
			tl.insert( TweenLite.to(_button, 0, {alpha: 1, removeTint: true}));
			
			if(enableListeners) addListeners();
		}
		
		public function disable(disableListeners:Boolean = true):void
		{
			if(disableListeners) removeListeners();
			
			var tl:TimelineLite = new TimelineLite();
			
			tl.insert( TweenLite.to(_button, 0, {alpha: .7, colorTransform:{ 
				tint: 0xCCCCCC,
				tintAmount: 0.5
			}}));
		}
		
		public function addListeners():void
		{
			_button.buttonMode = true;
			_button.addEventListener(MouseEvent.ROLL_OVER, _onRollOver, false, 0, true);
			_button.addEventListener(MouseEvent.ROLL_OUT, _onRollOut, false, 0, true);
			_button.addEventListener(MouseEvent.CLICK, _onClick, false, 0, true);
		}
		
		public function removeListeners():void
		{
			_button.buttonMode = false;
			_button.removeEventListener(MouseEvent.ROLL_OVER, _onRollOver);
			_button.removeEventListener(MouseEvent.ROLL_OUT, _onRollOut);
			_button.removeEventListener(MouseEvent.CLICK, _onClick);
		}
		
		protected function _onRollOver(e:MouseEvent):void
		{
			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOver(_button));
			}
		}
		
		protected function _onRollOut(e:MouseEvent):void
		{
			var tl:TimelineLite = new TimelineLite();
			
			var len:int = behaviors.length;
			for(var i:int = 0; i < len; ++i)
			{
				tl.insert( behaviors[i].animateOut(_button));
			}
		}

		private function _onClick(e:MouseEvent):void
		{
			clicked.dispatch({dispatcher: this, button: _button, vars: vars});
		}
		
		public function destroy():void
		{
			if(_button)
			{
				removeListeners();
			}
			
			clicked.removeAll();
			
			_isDestroyed = true;
		}
		
		public function get button():MovieClip
		{
			return _button;
		}

		public function get mouseEnabled():Boolean
		{
			return _mouseEnabled;
		}

		public function set mouseEnabled(value:Boolean):void
		{
			_mouseEnabled = value;
			_button.mouseEnabled = _mouseEnabled;
		}

		public function get mouseChildren():Boolean
		{
			return _mouseChildren;
		}

		public function set mouseChildren(value:Boolean):void
		{
			_mouseChildren = value;
			_button.mouseChildren = _mouseChildren;
		}
		
		public function get isDestroyed():Boolean
		{
			return this._isDestroyed;
		}
	}
}