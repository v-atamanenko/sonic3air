
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
uniform float2 TexelOffset;
uniform float4 Kernel;

float4 main(
	float2 uv0 : TEXCOORD0
) {
	float3 color00 = tex2D(tex, uv0 + float2(-TexelOffset.x, -TexelOffset.y)).rgb;
	float3 color01 = tex2D(tex, uv0 + float2(0.0, -TexelOffset.y)).rgb;
	float3 color02 = tex2D(tex, uv0 + float2(TexelOffset.x, -TexelOffset.y)).rgb;
	float3 color10 = tex2D(tex, uv0 + float2(-TexelOffset.x, 0.0)).rgb;
	float3 color11 = tex2D(tex, uv0).rgb;
	float3 color12 = tex2D(tex, uv0 + float2(TexelOffset.x, 0.0)).rgb;
	float3 color20 = tex2D(tex, uv0 + float2(-TexelOffset.x, TexelOffset.y)).rgb;
	float3 color21 = tex2D(tex, uv0 + float2(0.0, TexelOffset.y)).rgb;
	float3 color22 = tex2D(tex, uv0 + float2(TexelOffset.x, TexelOffset.y)).rgb;

	float3 color = color00 * Kernel.w + color01 * Kernel.z + color02 * Kernel.w
			   + color10 * Kernel.y + color11 * Kernel.x + color12 * Kernel.y
			   + color20 * Kernel.w + color21 * Kernel.z + color22 * Kernel.w;
	return float4(color, 1.0);
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = opaque;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
