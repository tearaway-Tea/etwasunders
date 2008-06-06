package com.etwasunders.controls {
	
	import com.etwasunders.model.GuestbookVO;
	
	import flash.events.Event;
	import flash.net.SharedObject;
	
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.events.ValidationResultEvent;
	import mx.validators.Validator;
	
	import org.goverla.containers.OkCancelTitleWindow;

	public class GuestbookAddControlBase extends OkCancelTitleWindow {
		
		protected static const GUESTBOOK : String = "guestbook";
		
		public var nameValidator : Validator;
		
		public var commentValidator : Validator;
		
		[Bindable]
		public var nameTextInput : TextInput;
		
		public var emailTextInput : TextInput;
		
		[Bindable]
		public var commentTextArea : TextArea;
		
		protected override function get valid() : Boolean {
			var result : Boolean = true;

			var validationResult : ValidationResultEvent = nameValidator.validate();
			result = result && (validationResult.results == null);
			validationResult = commentValidator.validate();
			result = result && (validationResult.results == null);
			
			return result;
		}
		
		protected override function show() : void {
			var so : SharedObject = SharedObject.getLocal(GUESTBOOK);
			if (so.data != null) {
				nameTextInput.text = so.data.userName as String;
				emailTextInput.text = so.data.userEmail as String;
				
			}
			
			if (nameTextInput.text != null && nameTextInput.text != "") {
				commentTextArea.setFocus();
			} else {
				nameTextInput.setFocus();
			}
			commentTextArea.text = null;
		}
		
		protected override function onOk(event : Event) : void {
			var so : SharedObject = SharedObject.getLocal(GUESTBOOK);
			so.data.userName = nameTextInput.text;
			so.data.userEmail = emailTextInput.text;
			so.flush();
			
			var entry : GuestbookVO = new GuestbookVO();
			entry.user = nameTextInput.text;
			entry.email = emailTextInput.text;
			entry.text = commentTextArea.text;
			okArguments = [entry];
			super.onOk(event);
		}
		
	}
	
}