package com.thebrighterprotocol.Snakes
{        

import org.flixel.*;
import flash.display.BitmapData;
import flash.geom.Point;

public class PlayState extends FlxState
{
    [Embed(source = '../../../../art/snake-art.png')] public var Artwork:Class;
    [Embed(source = '../../../../art/cursor.png')] public var Cursor:Class;

    private var map:RandomTilemap;
    private var player:SnakeSprite = null;
    private var _scoreText:FlxText;
    private var _foodGroup:FlxGroup;
    private var _score:int;
    private var _scoreTimer:Number;
    private var _restartButton:FlxButton;
    private var _startTimer:Number;

    override public function create():void
    {
        FlxG.mouse.show(Cursor, 8,8);
        
        _startTimer = 3;

        _foodGroup = new FlxGroup();
        add(_foodGroup);

        map = new RandomTilemap(Artwork, 32, 24);
        map.loadRandomMap(100);
        addFoods(50);
        add(map);

        player = new SnakeSprite(findOpenSpot(), Artwork, this);
        add(player);
        add(player.snakePath);
        
        _scoreText = new FlxText(230, 160, 400, "Score");
        _scoreText.visible = false;
        _scoreText.solid = false;
        _scoreText.setFormat("system",20,0x0000ff);
        _scoreTimer = 0;
        add(_scoreText);

        _score = 0;

        _restartButton = new FlxButton(50, 10, restartFunc);
        _restartButton.visible = false;
        var resText:FlxText = new FlxText(15,0,200, "Restart");
        resText.setFormat("system",14,0xff0000);
        _restartButton.loadText(resText);
        add(_restartButton);        

        super.create();
    }

    private function restartFunc():void
    {
        _score = 0;
        _scoreText.text = "Score\n" + String(_score);
        _restartButton.visible = false;
        _scoreText.visible = false;
        _startTimer = 3;

        player.resetSnake();
    }

    private function addFoods(numFoods:uint):void
    {
        for(var i:int=0; i<numFoods; i++)
        {
            var x:int = Math.random() * map.widthInTiles;
            var y:int = Math.random() * map.heightInTiles;

            if(map.getTile(x, y) == 1)
            {
                // skip this one
                i--;
                continue;
            }

            x = x * 16;
            y = y * 16;

            var fs:FoodSprite = new FoodSprite(x, y, Artwork, player);
            _foodGroup.add(fs);
        }
    }

    public function findOpenSpot():Point
    {
        while(true)
        {
            var x:int = Math.random() * map.widthInTiles;
            var y:int = Math.random() * map.heightInTiles;
            
            if(map.getTile(x, y) == 1)
                continue;
        
            x = x * 16;
            y = y * 16;
        
            return new Point(x, y);
            break;
        }

        return null;
    }

    public function playerHit():void
    {
        _scoreText.text = "Final Score\n" + String(_score);
        _scoreText.visible = true;
        _restartButton.visible = true;
        player.active = false;
    }

    override public function update():void
    {
        super.update();

        if(_startTimer > 0)
        {
            player.active = false;

            _startTimer -= FlxG.elapsed;
            _scoreText.text = "Starting in\n      " + String(int(_startTimer+1));
            _scoreText.visible = true;
            if(_startTimer <= 0)
            {
                player.resetSnake();
                player.active = true;
                _scoreText.visible = false;
            }
        }        

        if(player.collide(map))
            playerHit();
        
        player.refreshHulls();
        
        for(var i:int=0; i<_foodGroup.members.length; i++)
            if(player.collide(_foodGroup.members[i]))
            {
                _score += 10;

                _scoreText.text = "Score\n" + String(_score);
                _scoreText.visible = true;
                _scoreTimer = 1; // seconds to display for

                player.addBodyPiece();
                _foodGroup.members[i].kill();
                _foodGroup.remove(_foodGroup.members[i], true);
            }

        if(_scoreTimer > 0 && player.active)
        {
            _scoreTimer -= FlxG.elapsed;
            if(_scoreTimer <= 0)
                _scoreText.visible = false;
        }

        if(_foodGroup.members.length < 25)
            addFoods(50);
    }
}

}