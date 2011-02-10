package com.thebrighterprotocol.Snakes
{        

import flash.geom.Rectangle;
import flash.geom.Point;
import org.flixel.*;

public class FoodSprite extends FlxSprite
{
    protected static const BOUNDING_BOX_DEC:int = 4;

    private var _nextPoint:Point;
    private var _player:SnakeSprite;

    function FoodSprite(x:int, y:int, art:Class, player:SnakeSprite)
    {
        super(x, y);
        //Key = "SnakeSprite"
        createGraphic(16, 16);
        pixels.copyPixels(FlxG.addBitmap(art), new Rectangle(16*1, 0, 16, 16), new Point(0, 0));
        resetHelpers();
        
        //fixed = true;
        drag.x = 0;
        drag.y = 0;
        maxVelocity.x = 0;
        maxVelocity.y = 0;
        acceleration.x = 0;
        acceleration.y = 0;

        _player = player;
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