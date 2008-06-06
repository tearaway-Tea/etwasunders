package com.etwasunders.controls {
	
	import com.etwasunders.constants.Images;
	
	import mx.containers.VBox;
	
	import nl.fxc.controls.MusicModelLocator;

	public class MusicControlBase extends VBox {
		
		protected static const ENTRIES_DELIMITER : Class = Images.ENTRIES_DELIMITER;
	
		[Bindable]
		public var musicModelLocator : MusicModelLocator = MusicModelLocator.getInstance();
		
	}
	
}