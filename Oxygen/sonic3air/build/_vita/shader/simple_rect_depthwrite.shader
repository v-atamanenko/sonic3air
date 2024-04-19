
## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;



## ----- Vertex -------------------------------------------------------------------

uniform int4 Rect;
uniform int2 GameResolution;
uniform float DepthValue;

void main(
	float2 position,
	float4 out gl_Position : POSITION
) {
	int2 screenPosition;
	screenPosition.x = Rect.x + int(position.x * float(Rect.z) + 0.5);
	screenPosition.y = Rect.y + int(position.y * float(Rect.w) + 0.5);

	gl_Position.x = float(screenPosition.x) / float(GameResolution.x) * 2.0 - 1.0;
	gl_Position.y = float(screenPosition.y) / float(GameResolution.y) * 2.0 - 1.0;
	gl_Position.z = DepthValue;
	gl_Position.w = 1.0;
}



## ----- Fragment -----------------------------------------------------------------

void main()
{
	return float4(0.0, 0.0, 0.0, 1.0);
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = add;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
