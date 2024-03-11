
## ----- Shared -------------------------------------------------------------------

#version 130

precision mediump float;
precision mediump int;



## ----- Vertex -------------------------------------------------------------------

attribute vec2 position;
varying vec2 uv0;

void main()
{
	uv0.xy = position.xy;
	gl_Position.x = position.x * 2.0 - 1.0;
	gl_Position.y = position.y * 2.0 - 1.0;
	gl_Position.z = 0.0;
	gl_Position.w = 1.0;
}



## ----- Fragment -----------------------------------------------------------------

varying vec2 uv0;

uniform sampler2D Texture;
uniform vec2 TexelOffset;
uniform vec4 Kernel;

void main()
{
	vec3 color00 = texture2D(Texture, uv0 + vec2(-TexelOffset.x, -TexelOffset.y)).rgb;
	vec3 color01 = texture2D(Texture, uv0 + vec2(0.0, -TexelOffset.y)).rgb;
	vec3 color02 = texture2D(Texture, uv0 + vec2(TexelOffset.x, -TexelOffset.y)).rgb;
	vec3 color10 = texture2D(Texture, uv0 + vec2(-TexelOffset.x, 0.0)).rgb;
	vec3 color11 = texture2D(Texture, uv0).rgb;
	vec3 color12 = texture2D(Texture, uv0 + vec2(TexelOffset.x, 0.0)).rgb;
	vec3 color20 = texture2D(Texture, uv0 + vec2(-TexelOffset.x, TexelOffset.y)).rgb;
	vec3 color21 = texture2D(Texture, uv0 + vec2(0.0, TexelOffset.y)).rgb;
	vec3 color22 = texture2D(Texture, uv0 + vec2(TexelOffset.x, TexelOffset.y)).rgb;

	vec3 color = color00 * Kernel.w + color01 * Kernel.z + color02 * Kernel.w
			   + color10 * Kernel.y + color11 * Kernel.x + color12 * Kernel.y
			   + color20 * Kernel.w + color21 * Kernel.z + color22 * Kernel.w;
	gl_FragColor = vec4(color, 1.0);
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = opaque;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
