package com.etwasunders.controls {
	
	import com.etwasunders.constants.Images;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.containers.VBox;
	import mx.core.Repeater;
	import mx.managers.CursorManager;
	
	import org.goverla.managers.ApplicationManager;

	public class LinksControlBase extends Box {
		
		protected static const ENTRIES_DELIMITER : Class = Images.ENTRIES_DELIMITER;
		
		public var bandsVBox : VBox;
		
		public var portalsVBox : VBox;
		
		[Bindable]
		public var bandsRepeater : Repeater;
		
		[Bindable]
		public var portalsRepeater : Repeater;
		
		protected function get loader() : URLLoader {
			if (_loader == null) {
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, onLoadComplete);				
			}
			return _loader;
		}
		
		protected function onCreationComplete() : void {
			CursorManager.setBusyCursor();
			var request : URLRequest = new URLRequest(ApplicationManager.instance.url + "pages/links.xml");
			loader.load(request);
		}
		
		protected function onResize() : void {
			if (width < bandsVBox.width + portalsVBox.width + 10) {
				direction = BoxDirection.VERTICAL;
			} else {
				direction = BoxDirection.HORIZONTAL;
			}
		}
		
		private function onLoadComplete(event : Event) : void {
			CursorManager.removeBusyCursor();
			var xml : XML = new XML(loader.data);
			var bands : XMLList = xml.list.(@caption=="Bands");
			var portals : XMLList = xml.list.(@caption=="Portals");
			
			bandsRepeater.dataProvider = bands.link;
			portalsRepeater.dataProvider = portals.link;
		}
		
		private var _loader : URLLoader;
		
	}
	
}