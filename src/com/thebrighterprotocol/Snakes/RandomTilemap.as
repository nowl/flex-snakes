package com.thebrighterprotocol.Snakes
{        

import org.flixel.*;

public class RandomTilemap extends FlxTilemap
{
    private var _tiles:Class;

    public function RandomTilemap(tiles:Class, width:uint, height:uint)
    {
        super();
        collideIndex = 1;
        startingIndex = 1;
        drawIndex = 1;
        _tiles = tiles;
        
        widthInTiles = width;
        heightInTiles = height;

        setupMap(16, 16);
    }

    private function setupMap(TileWidth:uint=0, TileHeight:uint=0):void
    {
        _data = new Array();
        for(var r:uint = 0; r < heightInTiles; r++)
            for(var c:uint = 0; c < widthInTiles; c++)
                _data.push(0);

        //Pre-process the map data if it's auto-tiled
        var i:uint;
        totalTiles = widthInTiles*heightInTiles;
        if(auto > OFF)
        {
            collideIndex = startingIndex = drawIndex = 1;
            for(i = 0; i < totalTiles; i++)
                autoTile(i);
        }

        //Figure out the size of the tiles
        _pixels = FlxG.addBitmap(_tiles);
        _tileWidth = TileWidth;
        if(_tileWidth == 0)
            _tileWidth = _pixels.height;
        _tileHeight = TileHeight;
        if(_tileHeight == 0)
            _tileHeight = _tileWidth;
        _block.width = _tileWidth;
        _block.height = _tileHeight;
			
        //Then go through and create the actual map
        width = widthInTiles*_tileWidth;
        height = heightInTiles*_tileHeight;
        _rects = new Array(totalTiles);
        for(i = 0; i < totalTiles; i++)
            updateTile(i);

        //Pre-set some helper variables for later
        _screenRows = Math.ceil(FlxG.height/_tileHeight)+1;
        if(_screenRows > heightInTiles)
            _screenRows = heightInTiles;
        _screenCols = Math.ceil(FlxG.width/_tileWidth)+1;
        if(_screenCols > widthInTiles)
            _screenCols = widthInTiles;
			
        _bbKey = String(_tiles);
        generateBoundingTiles();
        refreshHulls();
    }

    public function clear():void
    {
        for(var x:uint = 0; x<widthInTiles; x++)
            for(var y:uint = 0; y<widthInTiles; y++)
                setTile(x, y, 0);
    }

    public function loadRandomMap(numBarricades:int):void
    {
        for(var i:uint=0; i<numBarricades; i++)
        {
            var x:uint = Math.random() * widthInTiles;
            var y:uint = Math.random() * heightInTiles;
            setTile(x, y, 1);
        }
    }
}

}