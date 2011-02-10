package com.thebrighterprotocol.Snakes
{        

import flash.geom.Rectangle;
import flash.geom.Point;
import org.flixel.*;

public class SnakePath extends FlxSprite
{
    public var path:Array = new Array();

    private var _nextX:int;
    private var _nextY:int;
    private var _state:FlxState;

    function SnakePath(state:FlxState)
    {
        super();
        drag.x = 0;
        drag.y = 0;
        acceleration.x = 0;
        acceleration.y = 0;
        path = new Array();
        _state = state;
    }

    override public function render():void
    {
        _state.graphics.clear();

        var prev:Point = null;
        _state.graphics.lineStyle(1, 0x0000ff, 1.0);;
        for(var i:int = 0; i<path.length; i++)
        {
            var p:Point = path[i];
            
            if(prev == null)
                _state.graphics.moveTo(p.x, p.y);
            
            _state.graphics.lineTo(p.x, p.y);
            
            prev = p;

            _state.graphics.moveTo(prev.x, prev.y);
        }
    }
}

}