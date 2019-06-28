static class Weapon
{
  
  Game game;
  
  PWeapon p;
  Ex owner;
  
  float tLastShot;
  
  float tCD;
  
  Weapon( Game game, PWeapon p, Ex owner )
  {
    this.game = game;
    
    this.p = p;
    this.owner = owner;
    
    this.tCD = 1 / p.ats;
    this.tLastShot = game.gameTime() - tCD / toSecond;
  }
  
  boolean ready()
  {
    return ( game.gameTime() - this.tLastShot ) * toSecond >= this.tCD;
  }
  
  Bullet bullet()
  { 
    this.tCD = 1 / p.ats;
    this.tLastShot = game.gameTime();
    
    final float dist = owner.shape().wh().sca( .35 ).x;
    
    return new Bullet( game, owner, owner.shape().center().add( C.rot( owner.rot ).sca( dist ) ), owner.rot(), this );
  }
}



enum PWeapon
{
  Bursting( 25, 3, 5, 20, 7 )
  {
    ScaImage<Image> overlay()
    {
      return GameOverlayBursting;
    }
  }
  ,
  Ice( 11, 5, 5, 17, 8 )
  {
    ScaImage<Image> overlay()
    {
      return GameOverlayIce;
    }
  }
  ,
  Magical( 20, 1f / .3f, 7, 17, 7 )
  {
    ScaImage<Image> overlay()
    {
      return GameOverlayMagical;
    }
  }
  ,
  Purifier( 6, 10, 6, 21, 5 )
  {
    ScaImage<Image> overlay()
    {
      return GameOverlayPurifier;
    }
  }
  ,
  Stun( 20, 1f / .3, 6, 18, 8 )
  {
    ScaImage<Image> overlay()
    {
      return GameOverlayStun;
    }
  }
  ,
  Weeb( 5, .3, 15, 3, 7 )
  {
    ScaImage<Image> overlay()
    {
      return null;
    }
  }
  ,
  ;
  
  final float dmg, ats, rge, bls, bsz;
  final float[] param;
  
  Weapon weapon( Ex customer )
  {
    return new Weapon( customer.game, this, customer );
  }
  
  abstract ScaImage<Image> overlay();
  
  static final private float sBls = .69f;
  
  private PWeapon( float dmg, float ats, float rge, float bls, float bsz, float... param )
  {
    this.dmg = dmg;
    this.ats = ats;
    this.rge = rge;
    this.bls = bls * sBls;
    this.bsz = bsz;
    this.param = param;
  }
}
