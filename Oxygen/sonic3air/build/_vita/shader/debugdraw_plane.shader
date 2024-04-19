
## ----- Shared -------------------------------------------------------------------

//#version 140		// Needed for isamplerBuffer

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

uniform sampler2D IndexTexture;
uniform sampler2D PatternCacheTexture;
uniform sampler2D PaletteTexture;
uniform int4 PlayfieldSize;
uniform int HighlightPrio;		// 0 or 1

float4 main(
	float2 uv0 : TEXCOORD0
) {
	int ix = int(uv0.x * float(PlayfieldSize.x));
	int iy = int(uv0.y * float(PlayfieldSize.y));

	int patternX = int(ix / 8);
	int patternY = int(iy / 8);
	int localX = ix - patternX * 8;
	int localY = iy - patternY * 8;

	float2 texel = tex2D(IndexTexture, float2((float(patternX + patternY * PlayfieldSize.z) + 0.5) / float(PlayfieldSize.z * PlayfieldSize.w), 0.5)).ra;
	int patternIndexH = int(texel.y * 255.5);
	int patternIndexL = int(texel.x * 255.5);
#ifndef GL_ES
	int patternIndex = patternIndexL + patternIndexH * 256;
#endif

#ifdef GL_ES
	int atex = int((patternIndexH - int(patternIndexH / 0x80) * 0x80) / 0x20) * 0x10;
	localX = ((patternIndexH - int(patternIndexH / 0x10) * 0x10) < 0x08) ? localX : (7 - localX);
	localY = ((patternIndexH - int(patternIndexH / 0x20) * 0x20) < 0x10) ? localY : (7 - localY);
#else
	int atex = (patternIndex >> 9) & 0x30;
	localX = ((patternIndex & 0x0800) == 0) ? localX : (7 - localX);
	localY = ((patternIndex & 0x1000) == 0) ? localY : (7 - localY);
#endif

	int patternCacheLookupIndexX = localX + localY * 8;
#ifdef GL_ES
	int patternCacheLookupIndexY = patternIndexL + (patternIndexH - int(patternIndexH / 8) * 8) * 0x100;
#else
	int patternCacheLookupIndexY = patternIndex & 0x07ff;
#endif
	int paletteIndex = int(tex2D(PatternCacheTexture, float2((float(patternCacheLookupIndexX) + 0.5) / 64.0, (float(patternCacheLookupIndexY) + 0.5) / 2048.0)).x * 256.0);
	paletteIndex += atex;

	float4 color = tex2D(PaletteTexture, vec2(float(paletteIndex + 0.5) / 512, 0.0));
	if ((patternIndex >> 15) < HighlightPrio)
		color.rgb *= 0.3;

	// Only for debugging
/*
	vec3 bgcolor = vec3(1.0, 1.0, 1.0) * ((((localX + localY) & 0x02) == 0) ? 0.2 : 0.1);
	color.rgb = color.rgb * color.a + bgcolor * (1.0 - color.a);
*/
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
