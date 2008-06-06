package com.etwasunders.controls {

	import com.asual.swfaddress.SWFAddress;
	import com.etwasunders.controls.interfaces.IScrollable;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.HBox;
	import mx.containers.ViewStack;
	import mx.controls.Image;
	import mx.core.Container;
	import mx.events.FlexEvent;
	import mx.events.IndexChangedEvent;

	public class ContentBase extends HBox {
		
		protected static const NEWS : String = "/news/";
		
		public var scrollControl : ScrollControl;
		
		[Bindable]
		public var contentViewStack : ViewStack;
		
		[Bindable]
		public function get logoImage() : Image {
			return _logoImage;
		}
		
		public function set logoImage(value : Image) : void {
			_logoImage = value;
			_logoImage.addEventListener(MouseEvent.CLICK, onLogoClick);
		}
		
		protected function get scrollableComponent() : Container {
			return resolveScrollableComponent(contentViewStack.selectedChild);
		}
		
		protected function onCreationComplete() : void {
			SWFAddress.onChange = onSWFAddressChange;
		}
		
		protected function onViewStackChange(event : IndexChangedEvent) : void {
			if (event.oldIndex >= 0) {
				var prevChild : Container = Container(contentViewStack.getChildAt(event.oldIndex));
				removeEventListeners(resolveScrollableComponent(prevChild));
			}
			
			if (scrollableComponent == null) {
				contentViewStack.selectedChild.addEventListener(FlexEvent.CREATION_COMPLETE, 
					onChildCreationComplete);
			} else {
				addEventListeners();
			}
			
            var value : String = "/" + Container(contentViewStack.selectedChild).label.toLowerCase() + "/";
            if (value != SWFAddress.getValue()) {
                SWFAddress.setValue(value);
            }
            
           	logoImage.useHandCursor = (value != NEWS);
           	logoImage.buttonMode = (value != NEWS);
		}
		
		protected function onScrollBarScroll() : void {
			scrollableComponent.verticalScrollPosition = scrollControl.scrollBar.scrollPosition;
		}
		
		protected function onChildCreationComplete(event : FlexEvent) : void {
			DisplayObject(event.target).removeEventListener(FlexEvent.CREATION_COMPLETE, onChildCreationComplete);
			addEventListeners();
		}
		
		private function onChildUpdateComplete(event : FlexEvent) : void {
			setScrollPropertiesForChild();
		}
		
		private function onChildMouseWheel(event : MouseEvent) : void {
            var scrollDirection : int = event.delta <= 0 ? 1 : -1;
            var lineScrollSize : int = scrollControl.scrollBar ? scrollControl.scrollBar.lineScrollSize : 1;
            var scrollAmount : Number = Math.max(Math.abs(event.delta), lineScrollSize);
            scrollableComponent.verticalScrollPosition += 3 * scrollAmount * scrollDirection;
		}
		
		private function onSWFAddressChange() : void {
			var value : String = SWFAddress.getValue();
			value = value.replace(/\//g, "");
			for each(var container : Container in contentViewStack.getChildren()) {
				if (container.label.toLowerCase() == value) {
					contentViewStack.selectedChild = container;
					SWFAddress.setTitle("Etwas Unders - " + container.label);
					break;
				}
			}
		}
		
		private function onLogoClick(event : MouseEvent) : void {
			SWFAddress.setValue(NEWS);
		}
		
		private function addEventListeners() : void {
			scrollableComponent.addEventListener(FlexEvent.UPDATE_COMPLETE, onChildUpdateComplete);
			scrollableComponent.addEventListener(MouseEvent.MOUSE_WHEEL, onChildMouseWheel);
		}
		
		private function removeEventListeners(component : Container) : void {
			component.removeEventListener(FlexEvent.UPDATE_COMPLETE, onChildUpdateComplete);
			component.removeEventListener(MouseEvent.MOUSE_WHEEL, onChildMouseWheel);
		}
		
		private function setScrollPropertiesForChild() : void {
			scrollControl.scrollBar.setScrollProperties(20, 
				0, 
				scrollableComponent.maxVerticalScrollPosition,
				scrollableComponent.verticalPageScrollSize);
			scrollControl.scrollBar.scrollPosition = scrollableComponent.verticalScrollPosition;
		}
		
		private function resolveScrollableComponent(component : Container) : Container {
			if (component is IScrollable) {
				return IScrollable(component).scrollableContainer;
			} else {
				return component;
			}
		}
		
		private var _logoImage : Image;
		
	}
	
}