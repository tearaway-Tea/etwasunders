package com.etwasunders.controls {
	
	import com.etwasunders.constants.Images;
	import com.etwasunders.model.MP3VO;
	
	import mx.collections.ArrayCollection;
	import mx.containers.Box;
	import mx.containers.BoxDirection;
	import mx.containers.VBox;
	import mx.core.Repeater;
	
	import nl.fxc.controls.MusicModelLocator;

	public class MusicControlBase extends Box {
		
		protected static const ENTRIES_DELIMITER : Class = Images.ENTRIES_DELIMITER;
	
		[Bindable]
		public var musicModelLocator : MusicModelLocator = MusicModelLocator.getInstance();
		
		public var albumVBox : VBox;
		
		public var demoVBox : VBox;
		
		[Bindable]
		public var albumRepeater : Repeater;
		
		[Bindable]
		public var demoRepeater : Repeater;
		
		protected function onCreationComplete() : void {
			albumRepeater.dataProvider = new ArrayCollection();
			demoRepeater.dataProvider = new ArrayCollection();
			for each (var mp3 : MP3VO in musicModelLocator.nowPlayingList) {
				mp3.index = musicModelLocator.nowPlayingList.getItemIndex(mp3);
				if (mp3.type == MP3VO.ALBUM) {
					ArrayCollection(albumRepeater.dataProvider).addItem(mp3);
				} else {
					ArrayCollection(demoRepeater.dataProvider).addItem(mp3);
				}
			}
		}
		
		protected function onResize() : void {
			if (width < albumVBox.width + demoVBox.width + 10) {
				direction = BoxDirection.VERTICAL;
			} else {
				direction = BoxDirection.HORIZONTAL;
			}
		}
		
	}
	
}