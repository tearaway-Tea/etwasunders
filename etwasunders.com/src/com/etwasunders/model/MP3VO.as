package com.etwasunders.model {
	
	[RemoteClass(alias="com.etwasunders.model.MP3VO")]
	public class MP3VO {
		
		[Bindable]
		public function set filename(value  : String) : void {
			_filename = value;
		}
		
		public function get filename() : String {
			return _filename;
		}
		
		[Bindable]
		public function set title(value  : String) : void {
			_title = value;
		}
		
		public function get title() : String {
			return _title;
		}
		
		[Bindable]
		public function set info(value  : String) : void {
			_info = value;
		}
		
		public function get info() : String {
			return _info;
		}						
		
		private var _filename : String;
		
		private var _title : String;
		
		private var _info : String;
				
	}
	
}