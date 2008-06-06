package com.etwasunders.controls {
	
	import mx.containers.VBox;
	import mx.controls.LinkBar;
	import mx.controls.LinkButton;
	
	import org.goverla.constants.StyleNames;
	import org.goverla.controls.ExtendedLinkButton;

	public class ContentMenuBase extends VBox {
		
		public var menuLinkBar : LinkBar;
		
		[Bindable]
		public function get dataProvider() : Object {
			return _dataProvider;
		}
		
		public function set dataProvider(value : Object) : void {
			_dataProvider = value;
		}

		protected function onMenuUpdateComplete() : void {
			for (var i : int; i < menuLinkBar.numChildren; i++) {
				var button : LinkButton = LinkButton(menuLinkBar.getChildAt(i));
				button.percentWidth = 100;
				button.setStyle(StyleNames.OVER_SKIN, ExtendedLinkButton);
				button.setStyle(StyleNames.DOWN_SKIN, ExtendedLinkButton);
			}
		}
		
		private var _dataProvider : Object;
		
	}
	
}