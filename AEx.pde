//hitbox of ex, size 1
static final C ExHitbox = new C( 40, 40 );


static class Ex implements Obj
{
  static final int player = 0, ai = 1;
  
  class A
  {
    static final int tMove = 0;
    int t;
    C loc;
    A( int t, C loc )
    {
      this.t = t;
      this.loc = loc;
    }
  }
  
  Game game;
  
  int team;
  
  int control;
  
  float size;
  
  C loc;
  C hitbox;
  float rot;
  
  Weapon weapon;
  S spd;
  S hep;
  
  Queue<A> as;
  
  Ex( Game game, int control, float size, float spd, C loc, C hitbox, float health, PWeapon p )
  {
    this.game = game;
    
    this.team = control;
    this.control = control;
    
    this.weapon = p.weapon( this );
    
    this.size = size;
    
    this.hitbox = hitbox.sca( size );
    this.loc = loc.sub( hitbox.sca( .5 ) );
    this.rot = 0;
    
    this.spd = new S( spd );
    this.hep = new S( health );
    
    this.as = new LinkedList();
  }
  
  void drawMe( PGraphics g, C lt, C ar, float zoom )
  {
    if( control == player )
    {
      final PImage me = GameMain.get( zoom );
      final PImage we = this.weapon.p.overlay().get( zoom );
      
      final float sca = 1.4;
      final C arsca = ar.sca( sca ), ltsca = lt.sub( ar.sca( sca * .5 - .5 ) );
      final float xDivY = ar.x / ar.y;
      
      final float fixrot = fixrot( rot );
      final boolean flip = fixrot < PI;
      
      if( flip )
      {
        imageVFlip( g, me, ltsca.x, ltsca.y, arsca.x, arsca.y, corners( me, xDivY ) );
      }
      else
      {
        image( g, me, ltsca.x, ltsca.y, arsca.x, arsca.y, corners( me, xDivY ) );
      }
      
      if( this.weapon != null )
      {
        if( flip )
        {
          imageVFlip( g, we, lt.x, lt.y, ar.x, ar.y, corners( we, xDivY ) );
        }
        else
        {
          image( g, we, lt.x, lt.y, ar.x, ar.y, corners( we, xDivY ) );
        }
      }
    }
  }
  
  void draw( PGraphics g, Cam c, float elapsed )
  {
    
    if( hep.c <= hep.l )
    {
      game.dies().add( this );
    }
    
    this.spd.toFull();
    
    
    A a = as.peek();
    
    if( a != null )
    {
      switch( a.t )
      {
        case A.tMove:
          
          move( a.loc.sub( shape().center() ) );
          
          final C center = shape().center();
          if( a.loc.sub( center ).len() < 1 )
          {
            as.poll();
          }
          
          if( control == player )
          {
            final C pxCenter = c.px( center );
            final float indicatorScale = 15f;
            
            final C size = new C( indicatorScale * this.size );
            
            final PImage i = GameIndicatorMove.get( c.zoom );
            final C whi = wh( i );
            final C anchor = GameIndicatorMoveAnchor;
            final C anchorToWhi = anchor.div( whi );
            
            final Shape.Rectangle display = new Shape.Rectangle( a.loc.sub( size.mul( anchorToWhi ) ), size );
            final C[] ltar = display.ltar( c );
            final C lt = ltar[ 0 ], ar = ltar[ 1 ];
            
            game.adds().add
            (
              new Obj()
              {
                public void draw( PGraphics g, Cam cam, float elapsed )
                {
                  g.image( i, lt.x, lt.y, ar.x, ar.y );
                  game.dies().add( this );
                }
                public C loc(){ return lt; }
                public float rot(){ return 0; }
                
                public void col( Obj other ){}
                public boolean colRel( Obj other ){ return false; }
                
                public int t(){ return Null; }
                
                public Shape shape(){ return display; }
              }
            );
          }
          
        break;
      }
    }
    
    final Shape shape = shape();
    
    
    final C[] ltar = ( (Shape.Rectangle)shape ).ltar( c );
    final C lt = ltar[ 0 ], ar = ltar[ 1 ];
    
    //draw what the ex looks like
    this.drawMe( g, lt, ar, c.zoom );
    
    if( debug )
    {
      g.noFill();
      stroke( g, RGBBLACK );
      g.strokeWeight( 1 );
      shape.draw( g, c );
    }
    
    final PImage hepF = GameHealthBarFull.get( c. zoom ), hepV = GameHealthBarVoid.get( c. zoom );
    
    float hH = ltar[ 1 ].x / hepF.width * hepF.height;
    C ltH = new C( ltar[ 0 ].x, ltar[ 0 ].y - hH );
    g.image( hepF, ltH.x, ltH.y, ltar[ 1 ].x, hH );
    
    final float sH = ltar[ 1 ].x / hepF.width;
    final float pH = 1 - hep.c / hep.h;

    final int lNotBarPixels = round( 77 * c.zoom ), rNotBarPixels = round( 22 * c.zoom ), notBarPixels = lNotBarPixels + rNotBarPixels;
    
    final C ltD = new C( ltH.x + lNotBarPixels * sH, ltH.y );
    final C arD = new C( ( ltar[ 1 ].x - notBarPixels * sH ) * pH , hH );
    final C ltS = new C( lNotBarPixels, 0 );
    final C arS = new C( (int)( ( hepV.width - notBarPixels ) * pH ), hepV.height );
    
    g.image( hepV, ltD.x, ltD.y, arD.x, arD.y, ltS.x(), ltS.y(), ltS.x() + arS.x(), ltS.y()+ arS.y() );
    
    fill( g, RGBBLACK );
    
    g.textSize( hH * .88 );
    
    g.text( (int)hep.c + "/" + (int)hep.h, ltH.x, ltH.y );
    
  }
  
  void sizeS( float v )
  {
    final float old = size;
    
    this.hitbox = hitbox.sca( v / old );
    this.spd = new S( v );
    
    this.size = v;
  }
  
  void attack( final float r )
  {
    
    if( weapon.ready() )
    {
      game.schs().add
      (
        new Runnable()
        {
          public void run()
          {
            rot = r;
            game.objs().add
            (
              weapon.bullet()
            );
          }
        }
      );
    }
  }
  void damageR( final Ex source, final float v )
  {
    this.hep.c -= v;
    
    final float dist = shape().wh().sca( .35 ).x;
    
    game.schs().add
    (
      new Runnable()
      {
        public void run()
        {
          game.nobjs().add( new DamagePopup( game, Ex.this, v, shape().center().add( C.rot( rot ).sca( dist ) ) ) );
        }
      }
    );
    
    if( this.hep.c <= this.hep.l )
    {
      game.dies().add( this );
    }
  }
  void move( C move )
  {
    float len = move.len();
    
    if( len > 0 )
    {
      this.rot = move.rot();
    }
    
    if( len > spd.c )
    {
      move = move.unit().sca( spd.c );
      len = spd.c;
    }
    
    loc = loc.add( move );
    spd.c -= len;
  }
  
  
  void schTar( int type, C tar )
  {
    if( type == schReplace )
    {
      as.clear();
    }
    as.add( new A( A.tMove, tar ) );
  }
  C loc()
  {
    return loc;
  }
  float rot()
  {
    return rot;
  }
  Shape shape()
  {
    return new Shape.Rectangle( new C( loc.x, loc.y ), hitbox );
  }
  void col( Obj other )
  {
     
  }
  boolean colRel( Obj other )
  {
    return false;
  }
  int t()
  {
    return Obj.Ex;
  }
  Game Game()
  {
    return game;
  }
}

static class DamagePopup implements NObj
{
  Game game;
  
  Ex source;
  Weapon weapon;
  float dmg;
  
  C loc;
  
  float tAlive;
  
  DamagePopup( Game game, Ex source, float dmg, C loc )
  {
    this.game = game;
    
    this.source = source;
    this.weapon = weapon;
    this.dmg = dmg;
    
    this.loc = loc;
  }
  void draw( PGraphics g, Cam c, float elapsed )
  {
    tAlive += elapsed;
    if( tAlive * toSecond > .4 )
    {
      game.schs().add( new Runnable(){ public void run(){ game.nobjs().remove( DamagePopup.this ); } } );
    }
    
    C[] ltar = ( (Shape.Rectangle)shape() ).ltar( c );
    
    final C lt = ltar[ 0 ], ar = ltar[ 1 ];
    
    g.image( GameDamagePopup.get( c. zoom ), lt.x, lt.y, ar.x, ar.y );
    
    g.textSize( ar.y * .3 );
    
    fill( g, RGBBLACK );
    
    g.text( (int)dmg, lt.x + ar.x * .5 - g.textWidth( (int)dmg + "" ) * .5, lt.y + ar.y * .5 + g.textSize * .5 );
  }
  C loc()
  {
    return loc;
  }
  float rot()
  {
    return .0;
  }
  
  Shape shape()
  {
    C ar = new C( 150 );
    return new Shape.Rectangle( loc.sub( ar.sca( .5 ) ), ar );
  }
}
