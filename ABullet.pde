interface BulletExe
{
  void e( Bullet bullet, Ex source, Ex hit );
}
static class Bullet implements Obj
{
  
  static final int bulletScale = 13;
  static final int bulletSpdScale = 3;
  static final int bulletRgeScale = 36;
  
  Game game;
  
  Ex source;
  C loc;
  float rot;
  
  int tAlive;
  float moved;
  
  Weapon weapon;
  
  Bullet( Game game, Ex source, C loc, float rot, Weapon weapon )
  {
    this.game = game;
    
    this.source = source;
    this.loc = loc;
    this.rot = rot;
    
    this.tAlive = 0;
    this.moved = .0;
    
    this.weapon = weapon;
  }
  
  
  int atAnimu = - 1;
  
  void draw( PGraphics g, Cam c, float elapsed )
  {
    final Animu a = GameFlameProjectile.get( c.zoom );
    
    atAnimu = atAnimu == a.frames - 1 ? 0 : atAnimu + 1;
    
    this.tAlive += 1;
   
    final C move = C.rot( this.rot ).sca( this.weapon.p.bls * bulletSpdScale );
    
    this.loc = loc.add( move );
    
    this.moved += move.len();
    
    if( moved > weapon.p.rge * source.size * bulletRgeScale )
    {
      game.dies().add( this );
    }
    
    final Shape s = shape();
    final C pxWh = s.wh().sca( c.zoom );;
    final C center = s.center();
    final C pxCenter = c.px( center );
    
    g.pushMatrix();
    
    g.translate( pxCenter.x, pxCenter.y );
    g.rotate( C.rot( rot ).rrot() );
    g.imageMode( CENTER );
    
    image( g, a, 0, 0, pxWh.x, pxWh.y, a.get( atAnimu ) );
    
    g.popMatrix();
    g.imageMode( CORNER );
    
  }
  C loc()
  {
    return loc;
  }
  float rot()
  {
    return rot;
  }
  
  void col( Obj other )
  {
    if( other instanceof Ex )
    {
      Ex ex = (Ex)other;
      
      if( ex.team != source.team )
      {
        hit( ex );
      }
    }
  }
  
  void hit( Ex enemy )
  {
    enemy.damageR( source, weapon.p.dmg );
    game.dies().add( this );
  }
  
  boolean colRel( Obj other )
  {
    return other instanceof Ex;
  }
  
  int t()
  {
    return Bullet;
  }
  
  Shape shape()
  {
    return new Shape.Circle( loc, weapon.p.bsz * bulletScale );
  }
}
