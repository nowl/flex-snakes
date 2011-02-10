package com.thebrighterprotocol.Snakes
{        

import flash.geom.Rectangle;
import flash.geom.Point;
import org.flixel.*;

public class SnakeSprite extends FlxSprite
{
    protected static const MOVE_SPEED:int = 50;
    protected static const BOUNDING_BOX_DEC:int = 2;

    public var snakePath:SnakePath;

    protected var bodies:Array;

    private var _nextX:int;
    private var _nextY:int;
    private var _elapsed:Number = 0;
    private var _state:PlayState;
    private var _art:Class;

    function SnakeSprite(p:Point, art:Class, state:PlayState)
    {
        super(p.x, p.y);
        createGraphic(16, 16);
        pixels.copyPixels(FlxG.addBitmap(art), new Rectangle(16*2, 0, 16, 16), new Point(0, 0));
        resetHelpers();

        drag.x = 0;
        drag.y = 0;
        maxVelocity.x = MOVE_SPEED;
        maxVelocity.y = MOVE_SPEED;
        acceleration.x = 0;
        acceleration.y = 0;
        bodies = new Array();
        snakePath = new SnakePath(state);
        _state = state;
        _art = art;
    }

    public function resetSnake():void
    {
        for(var i:int = 0; i<bodies.length; i++)
            bodies[i].kill();
        
        bodies.splice(0, bodies.length);
        snakePath.path.splice(0, snakePath.path.length);

        velocity.x = 0;
        velocity.y = 0;
        _nextX = x;
        _nextY = y;
    }

    protected function setVelocitiesToHitDest():void
    {
        if(_nextX < x)
            velocity.x = -MOVE_SPEED;
        else if(_nextX > x)
            velocity.x = MOVE_SPEED;
        if(_nextY < y)
            velocity.y = -MOVE_SPEED;
        else if(_nextY > y)
            velocity.y = MOVE_SPEED;
    }

    protected function correctPosition():void
    {
        if( (velocity.x > 0 && x >= _nextX) ||
            (velocity.x < 0 && x <= _nextX) )
        {
            x = _nextX;
            velocity.x = 0;
        }
        
        if( (velocity.y > 0 && y >= _nextY) ||
            (velocity.y < 0 && y <= _nextY) )
        {
            y = _nextY;
            velocity.y = 0;
        }

        if(x == _nextX && y == _nextY)
        {
            // set up next position    
            var point:Point = snakePath.path.shift();
            if(point != null)
            {
                _nextX = point.x - 8;
                _nextY = point.y - 8;
            }

            // set body followers            
            for(var i:int = bodies.length-1; i > 0; i--)
                bodies[i].nextPoint = bodies[i-1].nextPoint;            
            bodies[0].nextPoint = new Point(x, y);
        }
    }

    public function addBodyPiece():void
    {
        var parent:FlxSprite;

        var sb:SnakeBody = new SnakeBody(x, y, _art);
        sb.nextPoint = new Point(x, y);

        // does a push_front exist??
        bodies.reverse();
        bodies.push(sb);
        bodies.reverse();

        _state.add(sb);

        flicker();
    }

    override public function update():void
    {
        _elapsed += FlxG.elapsed;

        if(_elapsed > 0.01) // update every 10 ms
        {            
            _elapsed = 0;
            
            var newX:int = int(FlxG.mouse.x/16)*16 + 8;
            var newY:int = int(FlxG.mouse.y/16)*16 + 8;

            if(newX < 0)
                newX = 8;
            if(newY < 0)
                newY = 8
            if(newX >= 512)
                newX = 512 - 8;
            if(newY >= 384)
                newY = 384 - 8;

            var lastPoint:Point = snakePath.path[snakePath.path.length-1];
            if(lastPoint == null || 
               (lastPoint.x != newX || lastPoint.y != newY))               
                snakePath.path.push(new Point(newX, newY));
        }
    
        setVelocitiesToHitDest();
                
        super.update();

        correctPosition();

        // check for body collisions (be nice and don't collide with
        // first and last)
        if(!flickering())
            for(var i:int=1; i<bodies.length-1; i++)
                if(collide(bodies[i]))
                {
                    _state.playerHit();
                }
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