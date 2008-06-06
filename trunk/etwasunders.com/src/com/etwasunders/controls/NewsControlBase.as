package com.etwasunders.controls {
	
	import com.etwasunders.controls.common.NewsDataProvider;
	import com.etwasunders.controls.interfaces.IScrollable;
	
	import mx.containers.VBox;
	import mx.core.Container;
	import mx.events.CollectionEvent;

	public class NewsControlBase extends VBox implements IScrollable {
		
		protected static const ITEM_TOTAL_TEMPLATE : String = "{0}";
		
		public var entriesVBox : VBox;
		
		[Bindable]
		public function get dataProvider() : NewsDataProvider {
			return _dataProvider;
		}
		
		public function set dataProvider(value : NewsDataProvider) : void {
			_dataProvider = value;
			if (value != null) {
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
			}
		}
		
		public function get scrollableContainer() : Container {
			return entriesVBox;
		}
		
		protected function onCreationComplete() : void {
			dataProvider = new NewsDataProvider(10);
		}
		
		private function onDataProviderChange(event : CollectionEvent) : void {
			scrollableContainer.verticalScrollPosition = 0;
		}
		
		private var _dataProvider : NewsDataProvider;
		
	}
	
}