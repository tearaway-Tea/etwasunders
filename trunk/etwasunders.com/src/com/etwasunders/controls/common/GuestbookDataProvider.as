package com.etwasunders.controls.common {
	
	import com.etwasunders.business.Guestbook;
	import com.etwasunders.model.GuestbookVO;
	
	import org.goverla.collections.ListDataProvider;
	import org.goverla.interfaces.IConverter;
	import org.goverla.utils.converting.ObjectToEntryConverter;

	public class GuestbookDataProvider extends ListDataProvider	{
		
		public function GuestbookDataProvider(itemsPerPage : Number) {
			super(itemsPerPage == 0 ? 10 : itemsPerPage);
			
			refresh();
		}
		
		public override function addItem(item : Object) : void {
			super.addItem(item);
			new Guestbook(onAddItem).addComment(GuestbookVO(item));
		}
		
		protected override function refreshItems() : void {
			super.refreshItems();
			new Guestbook(onRefreshItems).getEntries(currentPage * itemsPerPage, itemsPerPage);
		}
		
	}
	
}