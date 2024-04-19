
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
	gl_Position.y = position.y * 2.0 - 1.0;
	gl_Position.z = 0.0;
	gl_Position.w = 1.0;
}



## ----- Fragment -----------------------------------------------------------------

uniform sampler2D tex;

float4 main(
	float2 uv0 : TEXCOORD0
) {
	return tex2D(tex, uv0);
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = opaque;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
