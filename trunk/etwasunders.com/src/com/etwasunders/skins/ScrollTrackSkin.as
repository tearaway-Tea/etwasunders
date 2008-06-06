package com.etwasunders.skins {

	import flash.display.GradientType;
	
	import mx.skins.ProgrammaticSkin;
	
	public class ScrollTrackSkin extends ProgrammaticSkin {
		
	    public override function get measuredWidth() : Number {
	        return 16;
	    }
	          
	    public override function get measuredHeight() : Number {
	        return 1;
	    }
	    
		protected override function updateDisplayList(w : Number, h : Number) : void {
			super.updateDisplayList(w, h);

			graphics.clear();
				
			drawRoundRect(0, 0, measuredWidth, h, 0, 0, 0, 
				verticalGradientMatrix(0, 0, w, h), GradientType.LINEAR);

		}
		
	}
	
}