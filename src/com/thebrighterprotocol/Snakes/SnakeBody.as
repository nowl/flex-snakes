package com.thebrighterprotocol.Snakes
{        

import flash.geom.Rectangle;
import flash.geom.Point;
import org.flixel.*;

public class SnakeBody extends FlxSprite
{
    protected static const MOVE_SPEED:int = 50;
    protected static const BOUNDING_BOX_DEC:int = 2;

    private var _nextPoint:Point;
    private var _elapsed:Number;

    function SnakeBody(x:int, y:int, art:Class)
    {
        super(x, y);
        //Key = "SnakeSprite"
        createGraphic(16, 16);
        pixels.copyPixels(FlxG.addBitmap(art), new Rectangle(16*3, 0, 16, 16), new Point(0, 0));
        resetHelpers();

        drag.x = 0;
        drag.y = 0;
        maxVelocity.x = MOVE_SPEED;
        maxVelocity.y = MOVE_SPEED;
        acceleration.x = 0;
        acceleration.y = 0;
        solid = false;
        _elapsed = 0;
    }

    public function set nextPoint(np:Point):void
    {
        _nextPoint = np;
    }

    public function get nextPoint():Point
    {
        return _nextPoint;
    }
    
    protected function setVelocitiesToHitDest():void
    {
        if(_nextPoint.x < x)
            velocity.x = -MOVE_SPEED;
        else if(_nextPoint.x > x)
            velocity.x = MOVE_SPEED;
        if(_nextPoint.y < y)
            velocity.y = -MOVE_SPEED;
        else if(_nextPoint.y > y)
            velocity.y = MOVE_SPEED;
    }

    protected function correctPosition():void
    {
        if( (velocity.x > 0 && x >= _nextPoint.x) ||
            (velocity.x < 0 && x <= _nextPoint.x) )
        {
            x = _nextPoint.x;
            velocity.x = 0;
        }
        
        if( (velocity.y > 0 && y >= _nextPoint.y) ||
            (velocity.y < 0 && y <= _nextPoint.y) )
        {
            y = _nextPoint.y;
            velocity.y = 0;
        }
    }
    
    override public function update():void
    {
        if(! solid)
        {
            _elapsed += FlxG.elapsed;
            if(_elapsed > 1.0)
                solid = true;
        }

        setVelocitiesToHitDest();
                
        super.update();

        correctPosition();
    }

    public override function preCollide(Object:FlxObject):void
    {
        colHullX.x += BOUNDING_BOX_DEC;
        colHullX.y += BOUNDING_BOX_DEC;
        colHullX.width -= 2*BOUNDING_BOX_DEC;
        colHullX.height -= 2*BOUNDING_BOX_DEC;
        colHullY.x += BOUNDING_BOX_DEC;
        colHullY.y += BOUNDING_BOX_DEC;
        colHullY.width -= 2*BOUNDING_BOX_DEC;
        colHullY.height -= 2*BOUNDING_BOX_DEC;
    }    
}

}