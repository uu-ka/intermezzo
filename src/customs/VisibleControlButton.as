package customs
{
    import flash.events.MouseEvent;
    
    import mx.controls.Button;
    import mx.core.UIComponent;
    import mx.effects.Resize;
    import mx.events.FlexEvent;
    
    public class VisibleControlButton extends Button
    {
        private var _source:UIComponent;
        private var _sourceHeight:Number;
        private var _sourceWidth:Number;
        
        private var _label:String;
        private var _hideLabel:String;
        private var effect:Resize = new Resize();
        private var _sourceVisible:Boolean;
        
        private var _resizeVector:String;
        
        public function VisibleControlButton()
        {
            super();
            this.addEventListener(MouseEvent.CLICK, thisClickHandler);
            _resizeVector = "height";
        }
        
        public function set source(obj:UIComponent):void
        {
            this._source = obj;
            _source.addEventListener(FlexEvent.UPDATE_COMPLETE, sourceCreationComplete);
        }
        
        private function sourceCreationComplete(flexEvent:FlexEvent):void
        {

            if (!this._sourceHeight || _source.height > this._sourceHeight)
            {
                this._sourceHeight = _source.height;
                
                if (_source.height > 0)
                {
                    this.label = this._hideLabel;
                }
            }
        }
        
        public function get source():UIComponent
        {
            return this._source;
        }

        public function set hideLabel(label:String):void
        {
            this._hideLabel = label;
        }
        
        public function get hideLabel():String
        {
            return this._hideLabel;
        }
        
        public function set resizeVector(vector:String):void
        {
            this._resizeVector = vector;
        }
        
        public function get resizeVector():String
        {
            return this._resizeVector;
        }
        
        public function set sourceHeight(sourceHeight:Number):void {
            this._sourceHeight = sourceHeight;
        }

        public function get sourceHeight():Number{
            return this._sourceHeight;
        }
        
        override protected function commitProperties():void
        {
            super.commitProperties();
            _label = this.label;
            
            if (!_hideLabel)
            {
                _hideLabel = _label;
            }
        }

        public function thisClickHandler(event:MouseEvent):void
        {
            resize();
        }
        
        public function resize():void
        {
            if (_source == null)
            {
                return;
            }
            
            if (_source.height != 0)
            {
                effect.heightTo = 0;
                effect.duration = 500;
                effect.play([_source]);
                
                this.label = this._label;
            }
            else
            {
                effect.heightTo = this._sourceHeight;
                effect.duration = 500;
                effect.play([_source]);
                
                this.label = this.hideLabel;
            }
        }
    }
}
