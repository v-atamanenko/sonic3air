
## ----- Shared -------------------------------------------------------------------

//#version 140		// Needed for isamplerBuffer

//precision highp float;
//precision highp int;

uniform int2 Size;
uniform int FirstPattern;



## ----- Vertex -------------------------------------------------------------------

uniform int3 Position;		// With z = priority flag (0 or 1)
uniform int2 GameResolution;
uniform int WaterLevel;

void main(
	float2 position,
	float3 out LocalOffset : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	// Calculate local offset
	LocalOffset.x = position.x * float(Size.x * 8);
	LocalOffset.y = position.y * float(Size.y * 8);

	// Flip if necessary
	float2 transformedVertex = position.xy;
#ifdef GL_ES
	if ((FirstPattern - int(FirstPattern / 0x1000) * 0x1000) >= 0x0800)
		transformedVertex.x = (1.0 - transformedVertex.x);
	if ((FirstPattern - int(FirstPattern / 0x2000) * 0x2000) >= 0x1000)
		transformedVertex.y = (1.0 - transformedVertex.y);
#else
	if ((FirstPattern & 0x0800) != 0)
		transformedVertex.x = (1.0 - transformedVertex.x);
	if ((FirstPattern & 0x1000) != 0)
		transformedVertex.y = (1.0 - transformedVertex.y);
#endif

	// Transform local -> screen space
	transformedVertex.x = float(Position.x) + transformedVertex.x * float(Size.x * 8);
	transformedVertex.y = float(Position.y) + transformedVertex.y * float(Size.y * 8);

	// Transform screen space -> view space
	gl_Position.x = transformedVertex.x / float(GameResolution.x) * 2.0 - 1.0;
	gl_Position.y = transformedVertex.y / float(GameResolution.y) * 2.0 - 1.0;
	gl_Position.z = float(Position.z) * 0.5;
	gl_Position.w = 1.0;

	// Calculate water offset
	LocalOffset.z = (transformedVertex.y - float(WaterLevel)) / float(GameResolution.y);
}



## ----- Fragment -----------------------------------------------------------------

uniform sampler2D PatternCacheTexture;
uniform sampler2D PaletteTexture;
uniform float4 TintColor;
uniform float4 AddedColor;

float4 main(
	float3 LocalOffset : TEXCOORD0
) {
	int ix = int(LocalOffset.x);
	int iy = int(LocalOffset.y);
	int patternX = ix / 8;
	int patternY = iy / 8;
	int localX = ix - patternX * 8;
	int localY = iy - patternY * 8;

	int patternIndex = FirstPattern + patternX * Size.y + patternY;
#ifdef GL_ES
	int atex = ((patternIndex - int(patternIndex / 32768) * 32768) / 8192) * 16;
#else
	int atex = (patternIndex >> 9) & 0x30;
#endif

	int patternCacheLookupIndexX = localX + localY * 8;
#ifdef GL_ES
	int patternCacheLookupIndexY = (patternIndex - int(patternIndex / 2048) * 2048);
#else
	int patternCacheLookupIndexY = patternIndex & 0x07ff;
#endif
	int paletteIndex = int(tex2D(PatternCacheTexture, float2((float(patternCacheLookupIndexX) + 0.5) / 64.0, (float(patternCacheLookupIndexY) + 0.5) / 2048.0)).x * 256.0);
	paletteIndex += atex;

	float4 color = tex2D(PaletteTexture, float2((float(paletteIndex) + 0.5) / 512.0, LocalOffset.z + 0.5));
	color = float4(AddedColor.rgb, 0.0) + color * TintColor;
	if (color.a < 0.01)
		discard;

	return color;
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = alpha;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
