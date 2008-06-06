package com.etwasunders.business {
	
	import org.goverla.remoting.BaseAMFPHPDelegate;

	public class News extends BaseAMFPHPDelegate {
		
		public function News(resultHandler : Function) {
			super(resultHandler, faultHandler);
		}
		
		public function getEntries(position : int, itemsCount : int) : void {
			doCall("getEntries", [position, itemsCount, 0]);
		}
		
		private function faultHandler(info : Object) : void {
			throw new Error(info.description, info.code);
		}
		
	}
	
}