package com.etwasunders.business {
	
	import com.etwasunders.model.GuestbookVO;
	
	import org.goverla.remoting.BaseAMFPHPDelegate;

	public class Guestbook extends BaseAMFPHPDelegate {
		
		public function Guestbook(resultHandler : Function) {
			super(resultHandler, faultHandler);
		}
		
		public function addComment(item : GuestbookVO) : void {
			doCall("addComment", [item]);
		}
		
		public function getEntries(position : int, itemsCount : int) : void {
			doCall("getEntries", [position, itemsCount, 0]);
		}
		
		private function faultHandler(info : Object) : void {
			throw new Error(info.description, info.code);
		}
		
	}
	
}