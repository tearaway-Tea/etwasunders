package com.etwasunders.controls {
	
	import com.etwasunders.constants.Images;
	import com.etwasunders.model.MP3VO;
	
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import mx.collections.ArrayCollection;
	import mx.containers.VBox;
	import mx.controls.Label;
	import mx.managers.CursorManager;
	
	import nl.fxc.controls.MP3Player;
	import nl.fxc.controls.MusicModelLocator;
	
	import org.goverla.managers.ApplicationManager;

	public class MP3PlayerControlBase extends VBox {
		
        protected static const PLAYER_NEXT_TRACK : Class = Images.PLAYER_NEXT_TRACK;
        
        protected static const PLAYER_PAUSE : Class = Images.PLAYER_PAUSE;
        
        protected static const PLAYER_PLAY : Class = Images.PLAYER_PLAY;
        
        protected static const PLAYER_PREV_TRACK : Class = Images.PLAYER_PREV_TRACK;
        
        protected static const PLAYER_STOP : Class = Images.PLAYER_STOP;
        
        public var statusLabel : Label;
		
		[Bindable]
		public var mp3Player : MP3Player = MP3Player.getInstance();
		
		protected function get loader() : URLLoader {
			if (_loader == null) {
				_loader = new URLLoader();
				_loader.addEventListener(Event.COMPLETE, onLoadComplete);				
			}
			return _loader;
		}
		
		[Bindable("playPauseClick")]
		protected function get playPauseIcon() : Class {
			if (mp3Player.isPlaying) {
				return PLAYER_PAUSE;
			} else {
				return PLAYER_PLAY;
			}
		}
		
		protected function onCreationComplete() : void {
			Security.loadPolicyFile(ApplicationManager.instance.url + "crossdomain.xml");
			mp3Player.addEventListener(Event.CHANGE, onChange);
			CursorManager.setBusyCursor();
			var request : URLRequest = new URLRequest(ApplicationManager.instance.url + "pages/mp3.xml");
			loader.load(request);
			mp3Player.lblMsg = statusLabel;
		}
		
		protected function onPrevClick() : void {
			mp3Player.getPreviousTrack();
			dispatchEvent(new Event("playPauseClick"));
		}
		
		protected function onPlayPauseClick() : void {
			if (mp3Player.isPlaying) {
				mp3Player.pause();
			} else {
				mp3Player.play();
			}
			dispatchEvent(new Event("playPauseClick"));
		}
		
		protected function onStopClick() : void {
			mp3Player.stop();
			dispatchEvent(new Event("playPauseClick"));
		}
		
		protected function onNextClick() : void {
			mp3Player.getNextTrack();
			dispatchEvent(new Event("playPauseClick"));
		}
		
		private function onLoadComplete(event : Event) : void {
			CursorManager.removeBusyCursor();
			MusicModelLocator.getInstance().nowPlayingList = new ArrayCollection()
			var xml : XML = new XML(loader.data);
			fillPlayingList(xml.list.(@caption=="Album").track, MP3VO.ALBUM);
			fillPlayingList(xml.list.(@caption=="Demo").track, MP3VO.DEMO);
		}
		
		private function onChange(event : Event) : void {
			dispatchEvent(new Event("playPauseClick"));
		}
		
		private function fillPlayingList(list : XMLList, type : String) : void {
			for each (var track : XML in list) {
				var mp3Entry : MP3VO = new MP3VO();
				mp3Entry.type = type;
				mp3Entry.filename = ApplicationManager.instance.url + String(track.@filename);
				mp3Entry.title = String(track.@title);
				mp3Entry.info = String(track.@info);
				MusicModelLocator.getInstance().nowPlayingList.addItem(mp3Entry);
			}
		}
		
		private var _loader : URLLoader;
		
	}
	
}