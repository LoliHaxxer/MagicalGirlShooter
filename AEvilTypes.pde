static enum ET
{
  Weeb( 3, 50, 4 )
  {
    final C s = new C( 14, 20 ).sca( 3.69 );
    
    ScaImage<AnimuD> animu()
    {
      return GameEvilWeeb;
    }
    
    Ex enemy( Game game, C loc )
    {
      return
      new ExE( game, Ex.ai, size, spd, loc, s, health, PWeapon.Weeb, this )
      {
        public void draw( PGraphics g, Cam c, float elapsed )
        {
          super.draw( g, c, elapsed );
          
          List<Ex> players = game.players();
          if( ! players.isEmpty() )
          {
            final Shape sMe = this.shape();
            final C cMe = sMe.center();
            
            Ex closest = null;
            float closestDist = Float.POSITIVE_INFINITY;
            C cPlayer = null;
            float closestRot = 0;
            for( Ex player : players )
            {
              final Shape sP = player.shape();
              final C cP = sP.center();
              
              final C strecke = cP.sub( cMe );
              
              closestRot = strecke.rot();
              
              final float dist = strecke.len();
              if( dist < closestDist )
              {
                closest = player;
                closestDist = dist;
                cPlayer = cP;
              }
            }
            
            attack( closestRot );
            
            schTar( schReplace, cPlayer );
          }
          
        }
      };
    }
  }
  ,
  ;
  
  
  abstract Ex enemy( Game game, C loc );
  
  ScaImage<AnimuD> animu()
  {
    throw new RuntimeException();
  }
  
  float size, health, spd;
  
  private ET( float size, float health, float spd )
  {
    this.size = size;
    this.health = health;
    this.spd = spd;
  }
  
}


static class ExE extends Ex
{
  
  ET et;
  
  ExE( Game game, int control, float size, float spd, C loc, C hitbox, float health, PWeapon p, ET et )
  {
    super( game, control, size, spd, loc, hitbox, health, p );
    
    this.et = et;
    
    
  }
  
  int atWalk = - 1;
  float tsWalk = game.gameTime();
  static final float walkPause = .22;
  
  void drawMe( PGraphics g, C lt, C ar, float zoom )
  {
    
    final AnimuD an = et.animu().get( zoom );
    
    final A a = as.peek();
    
    final boolean moving = a != null && a.t == A.tMove;
    
    final float fixrot = fixrot( this.rot );
    
    final int dir;
    
    
    if( fixrot >= TAU - QUARTER_PI || fixrot < QUARTER_PI )
    {
      dir = DOWN;
    }
    else if ( fixrot >= QUARTER_PI && fixrot < HALF_PI + QUARTER_PI )
    {
      dir = RIGHT;
    }
    else if ( fixrot >= HALF_PI + QUARTER_PI && fixrot < PI + QUARTER_PI )
    {
      dir = UP;
    }
    else
    {
      dir = LEFT;
    }
    
    final float now = game.gameTime();
    if( moving && ( now - tsWalk ) * toSecond > walkPause )
    {
     atWalk = atWalk == 1 ? 0 : atWalk + 1;
     tsWalk = now;
    }
    
    final int[] image = an.get( dir, moving, atWalk );
    
    image( g, an, lt.x, lt.y, ar.x, ar.y, image );
    
  }
  
}
