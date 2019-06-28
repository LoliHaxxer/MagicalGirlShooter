static interface Information<INFO>
{
  INFO get();
}


static interface Filter<A>
{
  boolean f( A a );
}


static class S
{
  float l, c, h;

  S( float h )
  {
    this( h, h );
  }
  S( float c, float h )
  {
    this( 0, c, h );
  }
  S( float l, float c, float h )
  {
    this.l = l;
    this.c = c;
    this.h = h;
  }

  void toFull()
  {
    c = h;
  }
  void toVoid()
  {
    c = l;
  }
}



static float fixrot( float rot )
{
  return rot >= 0 ? rot % TAU : ( rot % TAU + TAU ) % TAU;
}

static <A, B> List<A> g( Map<B, A> map, B... p )
{
  List r = new ArrayList();

  for ( B pp : p )
  {
    r.add( map.get( pp ) );
  }

  return r;
}


static C wh( PImage i )
{
  return new C( i.width, i.height );
}


<A> List<A> filter( List<A> to, Filter<A> filter )
{
  List r = new ArrayList();
  for ( A a : to )
  {
    if ( filter.f( a ) )
    {
      r.add( a );
    }
  }
  return r;
}


static boolean bounds( int v, int upper )
{
  return v >= 0 && v < upper;
}
