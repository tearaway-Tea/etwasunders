/*
    MP3Player version 0.1
    
    Simple mp3 player.
    
    use:
    - url, pathe to the mp3-file;
    - autoAutplay;
    
    properties you can read:
    - id3, info;
    - length, length in ms;
    - sLength, formatted length "0.00";
    - sPosition, formatted position "0.00";
    - position, position in ms;
    - pMinutes, position minutes;
    - pSeconds, position seconds;
    
    TODO:
    - set position, this is for example for slider-drag;
    - volume;
    - pan;
    - and other cool stuff
    - boring stuff like documentation
    
    Created by Maikel Sibbald
    info@flexcoders.nl
    http://labs.flexcoders.nl
    
    Free to use.... just give me some credit
*/

package nl.fxc.controls {
	
    import com.etwasunders.model.MP3VO;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.media.ID3Info;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Label;
    import mx.core.UIComponent;
    
    [Bindable]
    public class MP3Player extends UIComponent{
        
        public var id3:ID3Info;
        public var length:Number;
        public var sLength:String = "0:00";
        public var sPosition:String = "0:00";
        public var pMinutes:Number = 0;
        public var pSeconds:Number = 0;
        public var position:Number = 0;
        public var currentTrack:Number = -1;
        public var nowPlayingList:ArrayCollection;
        public var lblMsg:Label;

        private var _url:String;
        
        private var _autoPlay:Boolean;
        private var _isPlaying:Boolean;
        private var _volume:Number = 0;
        private var musicModel : MusicModelLocator = MusicModelLocator.getInstance();
        
        private var soundInstance:Sound;
        private var soundChannelInstance:SoundChannel;
        private var urlRequest:URLRequest;
        private var pausePosition:Number;
        private var soundBytes:ByteArray;
        
        private static var mp3Player:MP3Player;
        public static function getInstance():MP3Player{
            if(mp3Player == null){
                mp3Player = new MP3Player();
            }
            return mp3Player;
        }
        public function MP3Player():void{
            this.explicitHeight = 100;
            this.soundInstance = new Sound();
            this.setupListeners();
        }
        
        public function set url(value:String):void{
            this._url = value;
            this.urlRequest = new URLRequest(this._url);
            this.soundInstance.load(this.urlRequest);
            //trace('set url :' + _url);
        }
        
        public function get url():String{
            //trace('get url :' + _url);
            return _url;
        }
        
        public function setNowPlayingList(value:ArrayCollection):void{
            this.nowPlayingList = value;
            trace(this.nowPlayingList);
        }
            
        public function set autoPlay(value:Boolean):void{
            this._autoPlay = value;
        }
        public function get autoPlay():Boolean{
            return this._autoPlay;
        }
        public function set volume(value:Number):void{
            /* this._volume = value;
            if(this.soundChannelInstance != null){
                this.soundChannelInstance.soundTransform.volume = this._volume;
            } */
        }
        
        public function get isPlaying():Boolean{
            return this._isPlaying;
        }
        
        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
            if(this._autoPlay && !this._isPlaying){
                this.play();
            }
        }
        /******************************************CONTROLS***********************************************/
        private function setupListeners():void{
            this.soundInstance.addEventListener(Event.COMPLETE, completeHandler);
            this.soundInstance.addEventListener(Event.OPEN, openHandler);
            this.soundInstance.addEventListener(Event.ID3, id3Handler);
            this.soundInstance.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            this.soundInstance.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            this.addEventListener( Event.ENTER_FRAME, function():void {
              if(soundChannelInstance != null){
                  position = soundChannelInstance.position;
                  pMinutes = Math.floor(soundChannelInstance.position / 1000 / 60);
                  pSeconds = Math.floor(soundChannelInstance.position / 1000) % 60;
                  sPosition = pMinutes+":"+(pSeconds < 10?"0"+pSeconds:pSeconds);
              }
            }
            );
        }
        
        public function play():void{
            if(musicModel.nowPlayingList){
                if(!this._isPlaying){
                    if(this.currentTrack == -1){
                        getTrackAt(0);
                    }else{
                        this._isPlaying = true;
                        this.soundChannelInstance = this.soundInstance.play(this.pausePosition);
                        this.soundChannelInstance.soundTransform.volume = this._volume;
                        this.soundInstance.addEventListener(Event.ID3, id3Handler);
                        this.soundInstance.addEventListener(ProgressEvent.PROGRESS, progressHandler);
                        this.soundInstance.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
                        this.soundChannelInstance.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
                        this.pausePosition = 0;
                    }

                }
            }
        }
        
        public function pause():void{
            if(musicModel.nowPlayingList){
                if(this._isPlaying){
                    this.pausePosition = this.soundChannelInstance.position;
                    this.stop();
                }
            }
        }
        
        public function stop():void{
            if(musicModel.nowPlayingList){
                if(this._isPlaying){
                    this._isPlaying = false;
                    this.soundChannelInstance.stop();
                }        
            }
        }
    
        public function getFirstTrack():void{
            getTrackAt(0);
        }
        public function getNextTrack():void{
            var i:int;
            //if at end don't do
            if(musicModel.nowPlayingList){
                if(currentTrack < musicModel.nowPlayingList.length - 1){
                    i = currentTrack + 1;
                    getTrackAt(i);
                }else{
                    getFirstTrack();
                }
            }else{
                trace('please choose tracks first');
            }
        }
        public function getPreviousTrack():void{
            var i:int;
            //if at beggining don't do
            if(musicModel.nowPlayingList){
                if(currentTrack > 0){
                    i = currentTrack - 1;
                    getTrackAt(i);
                }else{
                    i = musicModel.nowPlayingList.length - 1;
                    getTrackAt(i);                    
                }
            }
        }
        public function getLastTrack():void{
            
            var i:int;
            if(musicModel.nowPlayingList){
                i = musicModel.nowPlayingList.length - 1;
                getTrackAt(i);
            }else{
                trace('please choose tracks first');
            }
        }
        public function getTrackAt(i:int):void{
			if (isPlaying && currentTrack == i) {
				return;
			}
            try{
                if(musicModel.nowPlayingList){
                    this.stop();
                    this.soundInstance = new Sound();
                    var _url:String = MP3VO(musicModel.nowPlayingList.getItemAt(i)).filename;
                    this.url = _url;
                    currentTrack = i;
                    this.play();
                    var tempDisplayTrack:int = currentTrack + 1;
                    
                    setMsg(MP3VO(musicModel.nowPlayingList.getItemAt(i)).title);
                    trace('currentTrack :' + currentTrack);
                }else{
                    trace('please choose tracks first');
                }
            } catch (err:Error) {
                trace(err);
                //work around for error
                this.stop();
                this.getNextTrack();
            } finally {
                
            }
        	dispatchEvent(new Event(Event.CHANGE));
        }
        public function setLabel(_Label:Label):void{
            lblMsg = _Label;
        }
        public function setMsg(msg:String):void{
            lblMsg.text = msg;
        }

        /******************************************HANDLERS***********************************************/
        private function completeHandler(event:Event):void {
            this.dispatchEvent(event);
        }
        
        private function openHandler(event:Event):void {
            this.dispatchEvent(event);
        }
        
        private function id3Handler(event:Event):void {
            this.id3 = this.soundInstance.id3;
        }

        public function soundCompleteHandler(event:Event):void {
            this.stop();
			this.getNextTrack();
        }
        
        private function ioErrorHandler(event:IOErrorEvent):void {
           this.dispatchEvent(event);
           trace('in error');
        }

        private function progressHandler(event:ProgressEvent):void {
            if(this.soundInstance != null){
                this.length = this.soundInstance.length;
                var tempMinutes:Number = Math.floor(this.length  / 1000 / 60);
                var tempSeconds:Number = Math.floor(this.length  / 1000) % 60;
                
                this.sLength = tempMinutes+":"+(tempSeconds < 10?"0"+tempSeconds:tempSeconds);
             }
             this.dispatchEvent(event);
        }

    }
}