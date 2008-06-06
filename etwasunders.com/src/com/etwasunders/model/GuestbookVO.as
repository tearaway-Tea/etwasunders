package com.etwasunders.model {
	
	[RemoteClass(alias="com.etwasunders.model.GuestbookVO")]
	public class GuestbookVO	{
		
		public var id : uint;
		
		public var timestamp : uint;

		[Bindable]
		public function set user(value  : String) : void {
			_user = value;
		}
		
		public function get user() : String {
			return _user;
		}
		
		[Bindable]
		public function set email(value  : String) : void {
			_email = value;
		}
		
		public function get email() : String {
			return _email;
		}
		
		[Bindable]
		public function set text(value  : String) : void {
			_text = value;
		}
		
		public function get text() : String {
			return _text;
		}
		
		[Bindable]
		public function set date(value  : String) : void {
			_date = value;
		}
		
		public function get date() : String {
			return _date;
		}
		
		private var _user : String;
		
		private var _email : String;
		
		private var _text : String;
		
		private var _date : String;
		
	}
	
}