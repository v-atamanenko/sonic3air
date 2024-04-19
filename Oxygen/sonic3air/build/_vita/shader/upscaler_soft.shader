
## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;



## ----- Vertex -------------------------------------------------------------------

void main(
	float2 position,
	float2 out uv0 : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	uv0.xy = position.xy;
	gl_Position.x = position.x * 2.0 - 1.0;
	gl_Position.y = 1.0 - position.y * 2.0;
	gl_Position.z = 0.0;
	gl_Position.w = 1.0;
}



## ----- Fragment -----------------------------------------------------------------

uniform sampler2D tex;
uniform float2 GameResolution;
uniform float PixelFactor;
#ifdef USE_SCANLINES
	uniform float ScanlinesIntensity;
#endif

float4 main(
	float2 uv0 : TEXCOORD0
) {
	float2 uv;

	float x = uv0.x * GameResolution.x;
	float ix = floor(x + 0.5);
	float fx = x - ix;
	fx = clamp(fx * PixelFactor, -0.5, 0.5);
	uv.x = (ix + fx) / GameResolution.x;

	float y = uv0.y * GameResolution.y;
	float iy = floor(y + 0.5);
	float fy = y - iy;
#ifdef USE_SCANLINES
	float colorMultiplier = 1.0 - (0.5 - abs(fy)) * ScanlinesIntensity;
#endif

	fy = clamp(fy * PixelFactor, -0.5, 0.5);
	uv.y = (iy + fy) / GameResolution.y;

	float4 color = tex2D(tex, uv);
#ifdef USE_SCANLINES
	color.rgb *= colorMultiplier;
#endif
	color.a = 1.0;
	return color;
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = opaque;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}

technique Scanlines : Standard
{
	define = USE_SCANLINES;
}
