
## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;

uniform int2 Size;



## ----- Vertex -------------------------------------------------------------------

uniform int3 Position;		// With z = priority flag (0 or 1)
uniform int2 PivotOffset;
uniform float4 Transformation;
uniform int2 GameResolution;

void main(
	float2 position,
	float2 out uv0 : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	// Calculate local offset
	float2 LocalOffset;
	LocalOffset.x = position.x * float(Size.x);
	LocalOffset.y = position.y * float(Size.y);

	// Transform
	float2 v = LocalOffset.xy + float2(PivotOffset.xy);
	float2 transformedVertex;
	transformedVertex.x = v.x * Transformation.x + v.y * Transformation.y;
	transformedVertex.y = v.x * Transformation.z + v.y * Transformation.w;

	// Transform local -> screen space
	transformedVertex.x = float(Position.x) + transformedVertex.x;
	transformedVertex.y = float(Position.y) + transformedVertex.y;

	// Transform screen space -> view space
	gl_Position.x = transformedVertex.x / float(GameResolution.x) * 2.0 - 1.0;
	gl_Position.y = transformedVertex.y / float(GameResolution.y) * 2.0 - 1.0;
	gl_Position.z = float(Position.z) * 0.5;
	gl_Position.w = 1.0;

	uv0 = position.xy;
}



## ----- Fragment -----------------------------------------------------------------

uniform sampler2D SpriteTexture;
uniform float4 TintColor;
uniform float4 AddedColor;

float4 main(
	float2 uv0 : TEXCOORD0
) {
	float4 color = tex2D(SpriteTexture, uv0.xy);
	color = color * TintColor + AddedColor;
#ifdef ALPHA_TEST
	if (color.a < 0.01)
		discard;
#endif

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

technique Standard_AlphaTest : Standard
{
	blendfunc = alpha;
	define = ALPHA_TEST;
}
