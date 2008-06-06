package com.etwasunders.controls {
	
	import com.etwasunders.constants.Images;
	import com.etwasunders.model.MP3VO;
	
	import mx.containers.VBox;
	
	import nl.fxc.controls.MP3Player;

	public class MusicEntryViewBase extends VBox {
		
		protected static const PLAYER_PLAY : Class = Images.PLAYER_PLAY;
		
		[Bindable]
		public var mp3Player : MP3Player = MP3Player.getInstance();
	
		[Bindable]
		public function get entry() : MP3VO {
			return _entry;
		}
		
		public function set entry(value : MP3VO) : void {
			_entry = value;
		}
		
		[Bindable]
		public function get entryIndex() : uint {
			return _entryIndex;
		}
		
		public function set entryIndex(value : uint) : void {
			_entryIndex = value;
		}		
		
		[Bindable]
		public function get showDelimiter() : Boolean {
			return _showDelimiter;
		}
		
		public function set showDelimiter(value : Boolean) : void {
			_showDelimiter = value;
		}
		
		protected function onPlayClick() : void {
			mp3Player.getTrackAt(entryIndex);
		}
		
		private var _entry : MP3VO;
		
		private var _entryIndex : uint;
		
		private var _showDelimiter : Boolean;
		
	}
	
}