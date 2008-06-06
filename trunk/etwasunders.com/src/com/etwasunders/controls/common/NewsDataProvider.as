package com.etwasunders.controls.common {
	
	import com.etwasunders.business.News;
	
	import org.goverla.collections.ListDataProvider;

	public class NewsDataProvider extends ListDataProvider {
		
		public function NewsDataProvider(itemsPerPage : Number) {
			super(itemsPerPage == 0 ? 10 : itemsPerPage);
			
			refresh();
		}
		
		protected override function refreshItems() : void {
			super.refreshItems();
			new News(onRefreshItems).getEntries(currentPage * itemsPerPage, itemsPerPage);
		}
		
	}
	
}