


abstract static class Shape //implements DU
{
  
  static class Circle extends Shape{
    
    C center;
    float radius;
    
    Circle(C center, float radius){
      this.center = center;
      this.radius = radius;
    }
    
    boolean collides( Shape other )
    {
      if(other instanceof Circle){
        
        return collides( (Circle)other, this );
        
      }
      else if( other instanceof Rectangle )
      {
        return collides( this, (Rectangle)other );
      }
      else{
        throw new RuntimeException();
      }
    }
    
    void draw( PGraphics g )
    {
      draw( g, new Cam() );
    }
    
    void draw( PGraphics g, Cam c )
    {
      C ce = c.px( center );
      
      g.circle( ce.x, ce.y, radius * c.zoom );
    }
    
    C wh()
    {
      return new C( radius * 2 );
    }
    
    C center()
    {
      return center;
    }
    
    String toString(){
      return "center "+center+", radius "+radius;
    }
    
  }
  
  static class Line extends Shape 
  {
    
    C a, b;
    
    Line( C a, C b )
    {
      this.a = a;
      this.b = b;
    }
    
    boolean collides( Shape other )
    {
      if( other instanceof Line )
      {
        
        return collides( (Line)other, this );
        
      }
      else if( other instanceof Circle )
      {
        
        return collides( (Circle)other, this );
        
      }
      else
      {
        throw new RuntimeException();
      }
    }
    
    void draw( PGraphics g )
    {
      draw( g, new Cam() );
    }
    
    void draw( PGraphics g, Cam c )
    {
      final float s = .5 * ( 1 - c.zoom );
      
      final C ab = b.sub( a ), aa = a.add( ab.sca( s ) ), bb = aa.add( ab.sca( c.zoom ) );
      
      g.line( - c.loc.x + aa.x, - c.loc.y + aa.y, bb.x, bb.y );
    }
    
    float len()
    {
      C ab = b.sub( a );
      
      return ab.len();
    }
    
    float rot()
    {
      C ab = b.sub( a );
      
      return ab.rot();
    }
    
    String toString()
    {
      return "P1( "+a+" ), P2( "+b+" )";
    }
    
  }
    
  static class Rectangle extends Shape
  {
    
    C[] point = new C[ 4 ];
    
    Rectangle( C lt, C ar )
    {
      point[ 0 ] = lt;
      point[ 1 ] = new C( lt.x, lt.y + ar.y );
      point[ 2 ] = new C( lt.x + ar.x, lt.y + ar.y );
      point[ 3 ] = new C( lt.x + ar.x, lt.y );
    }
    
    
    boolean collides( Shape other )
    {
      if( other instanceof Circle )
      {
        
        return collides( (Circle)other, this );
        
      }
      else if( other instanceof Rectangle )
      {
        return collides( this, (Rectangle)other );
      }
      else
      {
        throw new RuntimeException();
      }
    }
    
    void draw( PGraphics g )
    {
      draw( g, new Cam() );
    }
    
    void draw( PGraphics g, Cam c )
    {
      final C loc = c.px( point[ 0 ] );
      
      final C whs = this.wh().sca( c.zoom );
      
      g.rect( loc.x, loc.y, whs.x, whs.y );
    }
    
    C[] ltar( final Cam c )
    {
      final C loc = c.px( point[ 0 ] );
      
      final C whs = this.wh().sca( c.zoom );
      
      return new C[]{ loc, whs };
    }
    
    C wh()
    {
      return new C( point[ 3 ].sub( point[ 0 ] ).len(), point[ 1 ].sub( point[ 0 ] ).len() );
    }
    
    C center()
    {
      return point[ 0 ].add( wh().sca( .5 ) );
    }
    
    Line[] edges()
    {
      return new Line[]
      {
        new Line( point[ 0 ], point[ 1 ] ),
        new Line( point[ 1 ], point[ 2 ] ),
        new Line( point[ 2 ], point[ 3 ] ),
        new Line( point[ 3 ], point[ 0 ] ),
      };
    }
    
    String toString()
    {
      return Arrays.toString( point );
    }
  }
  
  
  abstract boolean collides( Shape other );
  
  void draw( PGraphics g )
  {}
  
  void draw( PGraphics g, Cam cam )
  {}
  
  Filter<C> pixels()
  {
    throw new RuntimeException();
  }
  
  C wh()
  {
    throw new RuntimeException();
  }
  C center()
  {
    throw new RuntimeException();
  }
  
  
  static boolean collides( C point, Circle circle )
  {
    float distance = point.sub( circle.center ).len();
    
    return distance <= circle.radius;
  }
  
  static boolean collides( C point, Line line )
  {
    float lenLine = line.len();
    float lenAPoint = line.a.sub( point ).len();
    float lenBPoint = line.b.sub( point ).len();
    float total = lenAPoint + lenBPoint;
    float buffer = .0001 * lenLine;
    
    if( total - buffer <= lenLine && total + buffer >= lenLine )
    {
      return true;
    }
    
    return false;
  }
  
  static boolean collides( C point, Rectangle rectangle )
  {
    C p1 = rectangle.point[ rectangle.point.length - 1 ];
    
    for( C p2 : rectangle.point )
    {
      float d = ( p2.x - p1.x ) * ( point.y - p1.y ) - ( point.x  - p1.x ) * ( p2.y - p1.y );
      
      if( d > 0 )
      {
        return false;
      }
      
      p1 = p2;
    }
    
    return true;
  }
  
  static boolean collides( Circle circle, Circle circle2 )
  {
    float distance = circle2.center.sub(circle.center).len();
        
    boolean colliding = distance <= circle2.radius + circle.radius;
    
    return colliding;
  }
  
  static boolean collides( Circle circle, Line line )
  {
    if( collides( line.a, circle ) || collides( line.b, circle ) )
    {
      return true;
    }
    
    final C c = circle.center;
    final C p1 = line.a, p2 = line.b;
    
    float lenLine = line.len();
    
    float dot = ( ( c.x - p1.x ) * ( p2.x - p1.x ) + ( c.y - p1.y ) * ( p2.y - p1.y )  ) / ( lenLine * lenLine );
    
    C pointOnLineClosest = new C( p1.x + dot * ( p2.x - p1.x ), p1.y + dot * ( p2.y - p1.y ) );
    
    if( ! collides( pointOnLineClosest, line ) )
    {
      return false;
    }
    
    return pointOnLineClosest.sub( c ).len() <= circle.radius;
  }
  
  static boolean collides( Circle circle, Rectangle rectangle )
  { 
    if( collides( circle.center, rectangle ) )
    {
      return true;
    }
    
    for( Line edge : rectangle.edges() )
    {
      if( collides( circle, edge ) )
      {
        return true;
      }
    }
    
    return false;
  }
  
  static boolean collides( Line line, Line line2 )
  {
    
    float denominator = ( ( line2.b.x - line2.a.x ) * ( line.b.y - line.a.y ) ) - ( ( line2.b.y - line2.a.y ) * ( line.b.x - line.a.x ) );
    float numerator1 = ((line2.a.y - line.a.y) * (line.b.x - line.a.x)) - ((line2.a.x - line.a.x) * (line.b.y - line.a.y));
    float numerator2 = ((line2.a.y - line.a.y) * (line2.b.x - line2.a.x)) - ((line2.a.x - line.a.x) * (line2.b.y - line2.a.y));
    
    
    if( denominator == 0 )
    {
      return numerator1 == 0 && numerator2 == 0;
    }
    
    float r1 = numerator1 / denominator;
    float r2 = numerator2 / denominator;
    
    //println(this,line);
    
    return r1 >= 0 && r1 <= 1 && r2 >= 0 && r2 <= 1;
  }
  
  static boolean collides( Rectangle a, Rectangle b )
  {
    return
      a.point[ 2 ].x > b.point[ 0 ].x &&
      b.point[ 2 ].x > a.point[ 0 ].x &&
      a.point[ 2 ].y > b.point[ 0 ].y &&
      b.point[ 2 ].y > a.point[ 0 ].y;
  }
  
}


static class C extends Shape {
  
  static final C ZERO = new C( 0, 0 );
  static final C YP = new C( 0, 1 );
  static final C YN = new C( 0, - 1 );
  static final C XP = new C( 1, 0 );
  static final C XN = new C( - 1, 0 );
  
  float x,y;
  int x(){ return (int)x; }int y(){ return (int)y; }
  
  C( float s )
  {
    this( s, s );
  }
  C(float x,float y){
    this.x=x;
    this.y=y;
  }
  
  C add(C c){return new C(x+c.x,y+c.y);}
  C add( C a, C c ){ a.x = x + c.x; a.y = y + c.y; return a; }
  C sub(C c){return new C(x-c.x,y-c.y);}
  C sub( C a, C c ){ a.x = x - c.x; a.y = y - c.y; return a; }
  C mul(C c){return new C(x*c.x,y*c.y);}
  C mul( C a, C c ){ a.x = x * c.x; a.y = y * c.y; return a; }
  C div(C c){return new C(x/c.x,y/c.y);}
  C div( C a, C c ){ a.x = x / c.x; a.y = y / c.y; return a; }
  C add( float xx, float yy ){return new C(x+xx,y+yy);}
  C add( C a, float xx, float yy ){ a.x = x + xx; a.y = y + yy; return a; }
  C sub( float xx, float yy ){return new C(x-xx,y-yy);}
  C sub( C a, float xx, float yy ){ a.x = x - xx; a.y = y - yy; return a; }
  C mul( float xx, float yy ){return new C(x+xx,y+yy);}
  C mul( C a, float xx, float yy ){ a.x = x * xx; a.y = y * yy; return a; }
  C div( float xx, float yy ){return new C(x+xx,y+yy);}
  C div( C a, float xx, float yy ){ a.x = x / xx; a.y = y / yy; return a; }
  C sca(float f){return new C(x*f,y*f);}
  C sca( C a, float f ){ a.x = x * f; a.y = y * f; return a; }
  float len(){return sqrt(x*x+y*y);}
  float rot(){ return atan( x / y ) + ( y < 0 ? PI : 0 ); }
  float rrot(){ return atan( y / x ) + ( x < 0 ? PI : 0 ); }
  static C rot( float rot )
  {
    return new C( sin( rot ), cos( rot ) );
  }
  C unit(){ return sca( 1 / len() ); }
  C unit( C a ){ return sca( a, 1 / len() ); }
  static float dot(C a, C c){ return a.x*c.x+a.y*c.y; }
  static float dotunit(C a, C c){ return dot( a.unit(), c.unit() ); }
  
  static C rand(C lower, C upper){
    return new C(lower.x+(float)Math.random()*(upper.x-lower.x),lower.y+(float)Math.random()*(upper.y-lower.y));
  }
  
  Iterable<C> iter(){
    return iter(C.ZERO, this, 1);
  }
  boolean iterbounds(C lower, C upper){
    return x>=lower.x && y>=lower.y && x<upper.x && y<upper.y;
  }
  
  static Iterable<C> iter(final C lower, final C upper, final float step){
    return new Iterable<C>(){
      public Iterator<C>iterator(){
        return new Iterator<C>(){
          C at = lower;
          public boolean hasNext(){
            return at.iterbounds(lower, upper);
          }
          public C next(){
            C r = at;
            if(at.x + step >= upper.x) at = new C(lower.x, at.y + step);
            else at = new C(at.x + step, at.y);
            return r;
          }
        };
      }
    };
  }
  
  String toString(){
    return "x "+x+" | y "+y;
  }
  
  boolean collides( Shape other )
  {
    if( other instanceof Circle)
    {
      return collides( this, (Circle)other );
    }
    else if ( other instanceof Line )
    {
      return collides( this, (Line)other );
    }
    else if ( other instanceof Rectangle )
    {
      return collides( this, (Rectangle)other );
    }
    else if ( other instanceof C )
    {
      return this.equals( (C)other );
    }
    else
    {
      throw new RuntimeException();
    }
  }
  
  boolean equals( Object other )
  {
    if( ! ( other instanceof C ) )
    {
      return false;
    }
    
    C c = (C)other;
    
    return c.x == this.x && c.y == this.y;
  }
  
  C copy( C a )
  {
    a.x = x;
    a.y = y;
    return a;
  }
  C copy()
  {
    return new C( x, y );
  }
}
