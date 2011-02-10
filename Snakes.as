package
{

import org.flixel.*; //Allows you to refer to flixel objects in your code
import com.thebrighterprotocol.Snakes.PlayState;
[SWF(width="1024", height="768", backgroundColor="#002f00")] //Set the size and color of the Flash file
[Frame(factoryClass="Preloader")]
public class Snakes extends FlxGame
{
    public function Snakes()
    {
        super(512,384,PlayState,2);
    }
}

}
