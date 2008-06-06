package com.etwasunders.controls {
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.containers.VBox;
	import mx.controls.Text;
	
	import org.goverla.managers.ApplicationManager;
	import org.goverla.utils.TextFormatter;

	public class AboutControlBase extends VBox {
		
		public var aboutText : Text;
		
		protected function get loader() : URLLoader {
			if (_loader == null) {
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, onLoadComplete);				
			}
			return _loader;
		}
		
		protected function onCreationComplete() : void {
			var request : URLRequest = new URLRequest(ApplicationManager.instance.url + "pages/about.xml");
			loader.load(request);
		}
		
		private function onLoadComplete(event : Event) : void {
			var xml : XML = new XML(loader.data);
			aboutText.htmlText = TextFormatter.compressCRLF(xml.text);
		}
		
		private var _loader : URLLoader;
		
	}
	
}