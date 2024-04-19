
## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;



## ----- Vertex -------------------------------------------------------------------

uniform float4 Transform;

void main(
	float2 position,
	float2 texcoords0,
	float2 out uv0 : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	uv0.xy = texcoords0.xy;
	float2 pos = float2(Transform.x + position.x * Transform.z, Transform.y + position.y * Transform.w);
	gl_Position = float4(pos, 0.0, 1.0);
}



## ----- Fragment -----------------------------------------------------------------

uniform sampler2D tex;
#ifdef USE_TINT_COLOR
	uniform float4 TintColor;
#endif

float4 main(
	float2 uv0 : TEXCOORD0
) {
	float4 color = tex2D(tex, uv0);
#ifdef USE_TINT_COLOR
	color *= TintColor;
#endif
#ifdef ALPHA_TEST
	if (color.a < 0.01)
		discard;
#endif

	return color;
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
	vertexattrib[1] = texcoords0;
}

technique TintColor : Standard
{
	define = USE_TINT_COLOR;
}

technique Standard_AlphaTest : Standard
{
	define = ALPHA_TEST;
}

technique TintColor_AlphaTest : Standard
{
	define = ALPHA_TEST;
	define = USE_TINT_COLOR;
}
