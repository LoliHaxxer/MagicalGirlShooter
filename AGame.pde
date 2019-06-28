

static final int sMain = 0, sSGame = 1, sSLeader = 2;

static int state;


static UIE[] UIEState = new UIE[ 20 ];


static void stateS( int v )
{
  state = v;
  
  UIEs.clear();
  
  UIEs.add( UIEState[ v ] );
}


static final int schReplace = 0 , schAdd = 1;



static ScaImage<AnimuD> GameEvilWeeb;
static ScaImage<Animu> GameFlameProjectile;

static ScaImage<Image> GameDamagePopup;
static ScaImage<Image> GameHealthBarFull;
static ScaImage<Image> GameHealthBarVoid;
static ScaImage<Image> GameIconBursting;
static ScaImage<Image> GameIconCornet;
static ScaImage<Image> GameIconIce;
static ScaImage<Image> GameIconIceS;
static ScaImage<Image> GameIconMagical;
static ScaImage<Image> GameIconPurifier;
static ScaImage<Image> GameIconStun;
static ScaImage<Image> GameIndicatorMove;
static final C GameIndicatorMoveAnchor = new C( 124, 210 );
static ScaImage<Image> GameMain;
static ScaImage<Image> GameOverlayBursting;
static ScaImage<Image> GameOverlayIce;
static ScaImage<Image> GameOverlayMagical;
static ScaImage<Image> GameOverlayPurifier;
static ScaImage<Image> GameOverlayStun;


interface Game
{
  
  float gameTime();
  
  List<Runnable> schs();
  
  List<Obj> objs();
  List<Obj> adds();
  List<Obj> dies();
  
  List<NObj> nobjs();
  
  List<Ex> players();
  
}

//not colliding objs
abstract interface NObj
{
  void draw( PGraphics g, Cam cam, float elapsed );
  C loc();
  float rot();
  
  Shape shape();
}
abstract interface Obj extends NObj 
{
  static int Null = - 1, Bullet = 0, Ex = 1;
  
  void col( Obj other );
  boolean colRel( Obj other );
  
  int t();
}


static class SingleGame implements UIE, Game
{
  
  Cam camout;
  
  int ww, hh;
  
  
  float last = millis;
  
  
  static final int wavePause = 10;
  float tsLastWave;
  
  static final int gamePlay = 0, gameInventory = 1;
  static int gameState = gamePlay;
  
  boolean camLocked;
  Cam playerCam;
  Ex playerControl;
  
  List<Runnable> schs = new ArrayList();
  
  List<Obj> objs = new ArrayList();
  List<Obj> adds = new ArrayList();
  List<Obj> dies = new ArrayList();
  
  List<NObj> nobjs = new ArrayList();

  SingleGame()
  {
    this.ww = fsw; this.hh = fsh;
    
    
    this.camLocked = true;
    
    this.playerControl = new Ex( this, Ex.player, 6, 10, C.ZERO, new C( 23, 40 ), 100, PWeapon.Magical );
    
    this.objs.add( playerControl );
    
    this.playerCam = new Cam();
    
    tsLastWave = millis - wavePause / toSecond;
    
    
  }
  
  void draw( PGraphics g )
  {
    final float now = millis;
    final float elapsed = now - last;
    
    if( ( millis - tsLastWave ) * toSecond > wavePause )
    {
      this.wave();
      tsLastWave = millis;
    }
    
    //C ad = playerCam.px( playerControl.shape().center() );
    //C move = UIL.mouse().sub( ad );
    
      
    C mouse = playerCam.cl( UIL.mouse() );
    
    C move = mouse.sub( playerControl.shape().center() );
    
    final float rot = move.rot();
    
    this.playerControl.rot = rot;
    
    if( UIL.mousePressed() )
    {
      if( UIL.mouseButton() == LEFT )
      {
        this.playerControl.attack( rot );
      }
      else
      {
    
        this.playerControl.schTar( schReplace, mouse );
      }
      
    }
    
    if( UIL.kD( 32 ) )
    {
      this.playerControl.attack( rot );
    }
    final boolean w = UIL.kD( 87 ), a = UIL.kD( 65 ), s = UIL.kD( 83 ), d = UIL.kD( 68 );
    
    move = new C( 0 );
    
    if( w )
    {
      move.add( move, 0, - 1 );
    }
    if( a )
    {
      move.add( move, - 1, 0 );
    }
    if( s )
    {
      move.add( move, 0, 1 );
    }
    if( d )
    {
      move.add( move, 1, 0 );
    }
    
    if( ! move.equals( C.ZERO ) )
    {
      playerControl.as.clear();
      move.sca( move.unit( move ), playerControl.spd.h );
      playerControl.move( move );
    }
    
    
    if( camLocked )
    {
      this.playerCam.center( playerControl.shape().center(), new C( ww, hh ) );
    }
    
    
    
    for( Obj obj : objs )
    {
      obj.draw( g, playerCam, elapsed );
    }
    
    List<Obj> comps = new ArrayList();
    for( Obj obj : objs )
    {
      for( Obj comp : comps )
      {
        final boolean co = comp.colRel( obj ), oc = obj.colRel( comp );
        if( co || oc )
        {
          if( comp.shape().collides( obj.shape() ) )
          {
            if( co )
            {
              comp.col( obj );
            }
            if( oc )
            {
              obj.col( comp );
            }
          }
        }
      }
      comps.add( obj );
    }
    
    for( NObj nobj : nobjs )
    {
      nobj.draw( g, playerCam, elapsed );
    }
    
    for( Runnable sch : schs )
    {
      sch.run();
    }
    schs.clear();
    
    for( Obj die : dies )
    {
      objs.remove( die );
    }
    dies.clear();
    
    for( Obj add : adds )
    {
      objs.add( add );
    }
    adds.clear();
    
    last = now;
  }
  
  void wave()
  {
    if( objs.size() > 100 )
    {
      return;
    }
    
    final C cP = playerControl.shape().center();
    
    final int count = 5;
    final int limit = count * 10;
    int tries = 0;
    a:
      for( int i = 0 ; i < count && tries < limit ; tries += 1 )
      {
        final float spawnRot = (float)Math.random() * TAU;
        final float size = 3;
        final float fac = 200;
        final float spawnDist = fac * size + (float)Math.random() * fac * size;
        
        final C loc = cP.add( C.rot( spawnRot ).sca( spawnDist ) );
        
        final Ex mob = ET.Weeb.enemy( this, loc );
        final Shape s = mob.shape();
        
        for( Obj obj : objs )
        {
          if( s.collides( obj.shape() ) )
          {
            continue a;
          }
        }
        
        this.objs.add( mob );
        
        i += 1;
      }
  }
  
  void mouseClicked( C mouse, int mouseButton )
  {
    
  }
  
  void mouseDragged( C drag, C last, C mouse, int mouseButton )
  {
    
  }
  
  void mouseWheel( float count, C mouse )
  {
    playerCam.zoom *= 1 - count * spdZoom;
    
    
  }
  
  void keyPressed( int key, int keyCode, C mouse )
  {
    switch( keyCode )
    {
      case 89:
      case 90:
        
        camLocked = ! camLocked;
        
      break;
    }
  }
  
  Cam cam()
  {
    return camout;
  }
  
  Shape shape()
  {
    return new Shape.Rectangle( C.ZERO, new C( ww, hh ) );
  }
  
  float gameTime()
  {
    return millis;
  }
  
  List<Runnable> schs()
  {
    return schs;
  }
  List<Obj> objs()
  {
    return objs;
  }
  List<Obj> adds()
  {
    return adds;
  }
  List<Obj> dies()
  {
    return dies;
  }
  List<NObj> nobjs()
  {
    return nobjs;
  }
  List<Ex> players()
  {
    return Arrays.asList( playerControl );
  }
  
}
