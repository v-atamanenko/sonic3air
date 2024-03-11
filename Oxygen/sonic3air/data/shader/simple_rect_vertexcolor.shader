
## ----- Shared -------------------------------------------------------------------

#version 130

precision mediump float;
precision mediump int;



## ----- Vertex -------------------------------------------------------------------

attribute vec2 position;
attribute vec4 color;
varying vec4 interpolatedColor;

uniform vec4 Transform;

void main()
{
	vec2 pos = vec2(Transform.x + position.x * Transform.z, Transform.y + position.y * Transform.w);

	// Intentionally using a z-value of 0.5
	gl_Position = vec4(pos, 0.5, 1.0);
	interpolatedColor = color;
}



## ----- Fragment -----------------------------------------------------------------

varying vec4 interpolatedColor;

void main()
{
	gl_FragColor = interpolatedColor;
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = alpha;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
