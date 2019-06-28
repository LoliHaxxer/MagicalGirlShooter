import java.util.*;
import java.nio.file.FileSystems;




void setup()
{
  
  
  if( setupDoneOnce )
  {
    return;
  }


  fullScreen();
  
  wh();
  
  fsw = w; 
  fsh = h;
  
  UIL = new IN()
  {
    public C mouse()
    {
      return mouse;
    }
    public boolean mousePressed()
    {
      return mousePressed;
    }
    public int mouseButton()
    {
      return mouseButton;
    }
    public boolean kD( int keyCode )
    {
      return kD.contains( keyCode );
    }
  };
  
  //setup
  {
    GameEvilWeeb = new ScaImage( new AnimuD( "animu/EvilWeeb", 0, 1, 2, 3, 4, 5, 6 ) );
    GameFlameProjectile = new ScaImage( new Animu( "animu/FlameProjectile" ) );
    
    GameDamagePopup = new ScaImage( loadImage( "DamagePopup.png" ) );
    GameHealthBarFull = new ScaImage( loadImage( "HealthBarFull.png" ) );
    GameHealthBarVoid = new ScaImage( loadImage( "HealthBarVoid.png" ) );
    GameIconBursting = new ScaImage( loadImage( "IconBursting.png" ) );
    GameIconCornet = new ScaImage( loadImage( "IconCornet.png" ) );
    GameIconIce = new ScaImage( loadImage( "IconIce.png" ) );
    GameIconMagical = new ScaImage( loadImage( "IconMagical.png" ) );
    GameIconPurifier = new ScaImage( loadImage( "IconPurifier.png" ) );
    GameIconStun = new ScaImage( loadImage( "IconStun.png" ) );
    GameIndicatorMove = new ScaImage( loadImage( "IndicatorMove.png" ) );
    GameMain = new ScaImage( loadImage( "Main.png" ) );
    GameOverlayBursting = new ScaImage( loadImage( "OverlayBursting.png" ) );
    GameOverlayIce = new ScaImage( loadImage( "OverlayIce.png" ) );
    GameOverlayMagical = new ScaImage( loadImage( "OverlayMagical.png" ) );
    GameOverlayPurifier = new ScaImage( loadImage( "OverlayPurifier.png" ) );
    GameOverlayStun = new ScaImage( loadImage( "OverlayStun.png" ) );
    
    
    UIEState[ sMain ] = new MainMenu();
    UIEState[ sSGame ] = new SingleGame();
    
    
    stateS( sMain );
  }
  
  setupDoneOnce = true;
}


void draw()
{
  
  debug();
  
  millis = millis();
  
  g.noStroke();
  filla( g, 0xffffffff );
  
  g.rect( 0, 0, width, height );
  
  for( int i = UIEs.size() - 1 ; i >= 0 ; i -= 1 )
  {
    UIEs.get( i ).draw( g );
  }
  
  //g.rotate( PI / 100 );
}

/**
// add at end of draw
  for( float i = .0 ; i < 1.01 ; i += .1 )
  {
    drawHealthBars( i );
  }
  at = 1;

int at = 1;
void drawHealthBars( float percent )
{
  {
    C[] ltar = new Shape.Rectangle( new C( 0, at ++ * 88 ), new C( 500, 200 ) ).ltar( new Cam() );
    float hH = ltar[ 1 ].x / GameHealthBarFull.width * GameHealthBarFull.height;
    C ltH = new C( ltar[ 0 ].x, ltar[ 0 ].y - hH );
    g.image( GameHealthBarFull, ltH.x, ltH.y, ltar[ 1 ].x, hH );
    
    final float sH = ltar[ 1 ].x / GameHealthBarFull.width;
    final float pH = percent;
  
    final int lNotBarPixels = 81, rNotBarPixels = 22, notBarPixels = lNotBarPixels + rNotBarPixels;
    
    C ltd = new C( ltH.x + lNotBarPixels * sH, ltH.y );
    C ard = new C( ( ltar[ 1 ].x - notBarPixels * sH ) * pH , hH );
    C lts = new C( lNotBarPixels, 0 );
    C ars = new C( (int)( ( GameHealthBarVoid.width - notBarPixels ) * pH ), GameHealthBarVoid.height );
    
    g.image( GameHealthBarVoid, ltd.x, ltd.y, ard.x, ard.y, lts.x(), lts.y(), lts.x() + ars.x(), ars.y() );
    
    fill( g, RGBRED );
    g.circle( ltd.x, ltd.y, 10 );
    g.circle( ltd.x + ard.x, ltd.y, 10 );
  }
}
**/
