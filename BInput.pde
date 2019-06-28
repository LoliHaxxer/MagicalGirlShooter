
//keyDownies
static final Set<Integer> kD = new HashSet();

void keyPressed()
{
  
  kD.add( keyCode );
  
  focussed().keyPressed( key, keyCode, mouse );
  
  if(key == 27)
  {
    key = 0;
  }
}

void keyReleased()
{
  kD.remove( keyCode );
}



static C mouse;
{
  mouse = new C( mouseX, mouseY );
}

void mouseClicked()
{
  
  mouse = new C( mouseX, mouseY );
  
  focus( mouse );
  
  for( UIE uie : UIEs )
  {
    
    if( mouse.collides( uie.shape() ) )
    {
      uie.mouseClicked( mouse, mouseButton );
      return;
    }
    
  }
}


void mouseMoved()
{
  mouse = new C( mouseX, mouseY );
}

static C last;
static boolean checkStart;
static UIE dragged;
void mouseDragged()
{
  mouse = new C( mouseX, mouseY );
  
  
  if( last == null )
  {
    last = mouse;
    checkStart = true;
  }
  else
  {
    if( checkStart )
    {
      dragged = focus( mouse );
      checkStart = false;
    }
    if( dragged == null )
    {
      for( UIE uie : UIEs )
      {
        dragged.mouseDragged( last.sub( mouse ), last, last, mouseButton );
      }
    }
    else
    {
      dragged.mouseDragged( mouse.sub( last ), last, last, mouseButton );
    }
    last = mouse;
  }
}
void mouseReleased()
{
  last = null;
}


void mouseWheel( final MouseEvent e )
{
  mouse = new C( mouseX, mouseY );
  
  final float count = e.getCount();
  
  for( UIE uie : UIEs )
  {
    if( mouse.collides( uie.shape() ) )
    {
      uie.mouseWheel( count, mouse );
      return;
    }
  }
}
