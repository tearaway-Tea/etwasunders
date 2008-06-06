package com.etwasunders.controls {
	
	import com.etwasunders.controls.common.GuestbookDataProvider;
	import com.etwasunders.controls.interfaces.IScrollable;
	import com.etwasunders.model.GuestbookVO;
	
	import mx.containers.VBox;
	import mx.core.Container;
	import mx.events.CollectionEvent;
	
	import org.goverla.containers.OkCancelTitleWindow;
	import org.goverla.controls.ExtendedLinkButton;

	public class GuestbookControlBase extends VBox implements IScrollable {
		
		protected static const ITEM_TOTAL_TEMPLATE : String = "{0} IN GUESTBOOK";
		
		public var entriesVBox : VBox;
		
		public var addCommentButton : ExtendedLinkButton;
		
		[Bindable]
		public function get dataProvider() : GuestbookDataProvider {
			return _dataProvider;
		}
		
		public function set dataProvider(value : GuestbookDataProvider) : void {
			_dataProvider = value;
			if (value != null) {
				value.addEventListener(CollectionEvent.COLLECTION_CHANGE, onDataProviderChange);
			}
		}
		
		public function get scrollableContainer() : Container {
			return entriesVBox;
		}
		
		protected function onCreationComplete() : void {
			dataProvider = new GuestbookDataProvider(10);
		}
		
		protected function onAddCommentClick() : void {
			var addControl : GuestbookAddControl = GuestbookAddControl(
				OkCancelTitleWindow.showPopUp(GuestbookAddControl, this, false, onAddCommentOKClick));
		}
		
		private function onAddCommentOKClick(entry : GuestbookVO) : void {
			dataProvider.addItem(entry);
		}
		
		private function onDataProviderChange(event : CollectionEvent) : void {
			scrollableContainer.verticalScrollPosition = 0;
		}
		
		private var _dataProvider : GuestbookDataProvider;
		
		private var _addControl : GuestbookAddControl;
		
	}
	
}