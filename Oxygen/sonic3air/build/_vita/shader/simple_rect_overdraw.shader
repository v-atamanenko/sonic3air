
## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;



## ----- Vertex -------------------------------------------------------------------

uniform float4 Rect;

void main(
	float2 position,
	float2 out uv0 : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	float2 pos = float2(Rect.x + position.x * Rect.z, Rect.y + position.y * Rect.w);
	uv0.xy = pos.xy;
	gl_Position.x = pos.x * 2.0 - 1.0;
	gl_Position.y = pos.y * 2.0 - 1.0;
	gl_Position.z = 0.0;
	gl_Position.w = 1.0;
}



## ----- Fragment -----------------------------------------------------------------

uniform sampler2D tex;

float4 main(
	float2 uv0 : TEXCOORD0
) {
	float4 color = tex2D(tex, uv0);
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
