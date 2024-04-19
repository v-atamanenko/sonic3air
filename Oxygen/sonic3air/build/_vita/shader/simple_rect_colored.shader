
## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;



## ----- Vertex -------------------------------------------------------------------

uniform float4 Transform;

void main(
	float2 position,
	float4 out gl_Position : POSITION
) {
	float2 pos = float2(Transform.x + position.x * Transform.z, Transform.y + position.y * Transform.w);

	// Intentionally using a z-value of 0.5
	gl_Position = float4(pos, 0.5, 1.0);
}



## ----- Fragment -----------------------------------------------------------------

uniform float4 Color;

float4 main()
{
	return Color;
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = alpha;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
