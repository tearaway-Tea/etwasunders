package com.etwasunders.business {
	
	import mx.managers.CursorManager;
	
	import org.goverla.remoting.BaseAMFPHPDelegate;

	public class News extends BaseAMFPHPDelegate {
		
		public function News(resultHandler : Function) {
			_resultHandler = resultHandler;
			super(this.resultHandler, faultHandler);
		}
		
		public function getEntries(position : int, itemsCount : int) : void {
			CursorManager.setBusyCursor();
			doCall("getEntries", [position, itemsCount, 0]);
		}
		
		private function resultHandler(result : Object) : void {
			CursorManager.removeBusyCursor();
			_resultHandler(result);
		}
		
		private function faultHandler(info : Object) : void {
			CursorManager.removeBusyCursor();
			throw new Error(info.description, info.code);
		}
		
		private var _resultHandler : Function;
		
	}
	
}