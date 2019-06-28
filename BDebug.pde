
float lastFc = millis();
int cFrame = 0;


void debug()
{
  
  final float now = millis;
  
  cFrame += 1;
  
  if( ( now - lastFc ) * .001 >= 1 )
  {
    println( "fps: ", cFrame );
    cFrame = 0;
    lastFc = now;
  }
}
