package com.etwasunders.controls {
	
	import com.etwasunders.constants.Images;
	import com.etwasunders.model.NewsVO;
	
	import flash.events.Event;
	
	import mx.containers.VBox;
	
	import org.goverla.utils.TextFormatter;

	public class NewsEntryViewBase extends VBox {
		
		protected static const ENTRIES_DELIMITER : Class = Images.ENTRIES_DELIMITER;
		
		protected static const ENTRY_CHANGE : String = "entryChange";
		
		[Bindable(event="entryChange")]
		public function get entry() : NewsVO {
			return _entry;
		}
		
		public function set entry(value : NewsVO) : void {
			_entry = value;
			dispatchEvent(new Event(ENTRY_CHANGE));
		}
		
		[Bindable(event="entryChange")]
		protected function get entryText() : String {
			return TextFormatter.compressCRLF(entry.text);
		}
		
		private var _entry : NewsVO;		
		
	}
	
}