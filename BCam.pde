static class Cam
{
  //outside world loc, d.h. does not scale with zoom and does not represent the same unit as values inside the camworld
  C loc;
  float zoom;
  
  Cam(  )
  {
    this( C.ZERO, 1 );
  }
  
  Cam( C loc, float zoom )
  {
    this.loc = loc;
    this.zoom = zoom;
  }
  
  C px( C cloc )
  {
    return cloc.sca( zoom ).sub( this.loc );
  }
  
  C cl( C px )
  {
    return px.add( this.loc ).sca( 1 / zoom );
  }
  
  void center( C loc, C screen )
  {
    
    this.loc = loc.sca( zoom ).sub( screen.sca( .5 ) );
    
  }
  
}
