package com.etwasunders.skins {
	
	import com.etwasunders.constants.Images;
	
	import mx.containers.Canvas;
	import mx.controls.Image;

	public class DelimiterSkin extends Canvas {
		
		public var image : Image;
		
		protected override function createChildren() : void {
			super.createChildren();
			
			image = new Image();
			image.source = Images.DELIMITER;
			image.setStyle("top", 1);
			image.alpha = 0.2;
			
			addChild(image);
		}
		
	}
	
}