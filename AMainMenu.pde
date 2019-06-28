static class MainMenu implements UIE
{
  
  Cam cam;
  
  List<UIE> uies;
  
  int ww, hh;

  MainMenu()
  {
    this.cam = new Cam();
    
    this.uies = new ArrayList();
    
    this.ww = fsw;
    this.hh = fsh;
    
    Box center = Box.BoxScaleLinesSeg( cam, C.ZERO, new C( this.ww, this.hh ), .59, 5, 17 );
    
    center.colorTextBack = RGBA( RGBRED );
    
    
    center.add(
      "No Friends",
      new Runnable()
      {
        public void run()
        {
          stateS( sSGame );
        }
      }
    );
    
    center.add(
      "No Friends Leader",
      new Runnable()
      {
        public void run()
        {
          stateS( sSLeader );
        }
      }
    );
    
    this.uies.add( center );
  }
  
  void draw( PGraphics g )
  {
    UIEdraw( g, uies );
  }
  
  void mouseClicked( C mouse, int mouseButton )
  {
    for( UIE uie : uies )
    {
      if( mouse.collides( uie.shape() ) )
      {
        uie.mouseClicked( mouse, mouseButton );
      }
    }
  }
  
  void mouseDragged( C drag, C last, C mouse, int mouseButton )
  {
    
  }
  
  void mouseWheel( float count, C mouse )
  {
    
  }
  
  void keyPressed( int key, int keyCode, C mouse )
  {
    
  }
  
  Cam cam()
  {
    return cam;
  }
  
  Shape shape()
  {
    return new Shape.Rectangle( C.ZERO, new C( ww, hh ) );
  }
}
