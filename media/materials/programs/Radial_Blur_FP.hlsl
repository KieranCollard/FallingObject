//------------------------------------------------------
//Radial_Blur_FP.cg
//  Implements radial blur to be used with the compositor
//  It's very dependant on screen resolution
//------------------------------------------------------

sampler2D tex: register(s0);

static const float samples[10] =
{
-0.08,
-0.05,
-0.03,
-0.02,
-0.01,
0.01,
0.02,
0.03,
0.05,
0.08
};
#define NSAMPLES 16
float4 main(float2 texCoord: TEXCOORD0,
            uniform float sampleDist,
            uniform float sampleStrength
           ) : COLOR
{
float BlurStart=0;
	float BlurWidth=1;
	float CX=0.5;
	float CY=0.5;
	float4 c = 0;
    float2 Center = float2(CX,CY);
    // this loop will be unrolled by compiler and the constants precalculated:
    for(int i=0; i<NSAMPLES; i++) {
    	float scale = BlurStart + BlurWidth*(i/(float) (NSAMPLES-1.0));
    	c += tex2D(tex, (2*texCoord-1)*scale/2 + Center );
    }
    c /= NSAMPLES;
    return lerp(c,tex2D(tex,texCoord),0);
//return float4(1,0,0,1);
#if 0
   //Vector from pixel to the center of the screen
   float2 dir = 0.5 - texCoord;

   //Distance from pixel to the center (distant pixels have stronger effect)
   //float dist = distance( float2( 0.5, 0.5 ), texCoord );
   float dist = sqrt( dir.x*dir.x + dir.y*dir.y );


   //Now that we have dist, we can normlize vector
   dir = normalize( dir );

   //Save the color to be used later
   float4 color = tex2D( tex, texCoord );
   //Average the pixels going along the vector
   float4 sum = color;
   for (int i = 0; i < 10; i++)
   {
      float4 res=tex2D( tex, texCoord + dir * samples[i] * sampleDist );
      sum += res;
   }
   sum /= 11;

   //Calculate amount of blur based on
   //distance and a strength parameter
   float t = dist * sampleStrength;
   t = saturate( t );//We need 0 <= t <= 1

   //Blend the original color with the averaged pixels
   return lerp( color, sum, t );
   #endif
}
