
## ----- Shared -------------------------------------------------------------------

//#version 140		// Needed for isamplerBuffer

//precision mediump float;
//precision mediump int;

uniform int2 Size;



## ----- Vertex -------------------------------------------------------------------

uniform int3 Position;		// With z = priority flag (0 or 1)
uniform int2 PivotOffset;
uniform float4 Transformation;
uniform int2 GameResolution;
uniform int WaterLevel;

void main(
	float2 position,
	float3 out LocalOffset : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	// Calculate local offset
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

	// Calculate water offset
	LocalOffset.z = (transformedVertex.y - float(WaterLevel)) / float(GameResolution.y);
}



## ----- Fragment -----------------------------------------------------------------;

uniform sampler2D SpriteTexture;
uniform sampler2D PaletteTexture;
uniform int Atex;
uniform float4 TintColor;
uniform float4 AddedColor;

float4 main(
	float3 LocalOffset : TEXCOORD0
) {
	int ix = int(LocalOffset.x);
	int iy = int(LocalOffset.y);
	int paletteIndex = Atex + int(tex2D(SpriteTexture, float2(((float(ix) + 0.5) / float(Size.x)), (float(iy) + 0.5) / float(Size.y))).x * 256.0);

	float4 color = tex2D(PaletteTexture, float2((float(paletteIndex) + 0.5) / 512.0, LocalOffset.z + 0.5));
	color = float4(AddedColor.rgb, 0.0) + color * TintColor;
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
