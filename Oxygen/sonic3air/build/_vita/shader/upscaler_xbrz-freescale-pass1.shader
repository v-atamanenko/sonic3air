
// Hyllian's xBRZ freescale multipass shader
//   - Adapted for use in Oxygen Engine
//  Copyright (C) 2018-2021 Eukaryot
//
// This shader is derived from original "xbrz-freescale-pass1.glsl" from https://github.com/libretro/glsl-shaders/tree/master/xbrz/shaders/xbrz-freescale-multipass
// Used under GNU General Public License v2, see additional license info below.
//
// This file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with the this software.  If not, see <http://www.gnu.org/licenses/>.


// xBRZ freescale
// based on :

// 4xBRZ shader - Copyright (C) 2014-2016 DeSmuME team
//
// This file is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with the this software.  If not, see <http://www.gnu.org/licenses/>.


/*
   Hyllian's xBR-vertex code and texel mapping

   Copyright (C) 2011/2016 Hyllian - sergiogdb@gmail.com
   Permission is hereby granted, free of charge, to any person obtaining a copy
   of this software and associated documentation files (the "Software"), to deal
   in the Software without restriction, including without limitation the rights
   to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
   copies of the Software, and to permit persons to whom the Software is
   furnished to do so, subject to the following conditions:
   The above copyright notice and this permission notice shall be included in
   all copies or substantial portions of the Software.
   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
   THE SOFTWARE.
*/





## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;



## ----- Vertex -------------------------------------------------------------------

void main(
	float2 position,
	float2 out TEX0 : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	gl_Position.x = position.x * 2.0 - 1.0;
	gl_Position.y = 1.0 - position.y * 2.0;
	gl_Position.z = 0.0;
	gl_Position.w = 1.0;
	TEX0.xy = position.xy * 1.0001;
}



## ----- Fragment -----------------------------------------------------------------

uniform float2 GameResolution;
uniform float2 OutputSize;
uniform sampler2D tex;
uniform sampler2D OrigTexture;

#define SourceSize float4(GameResolution, 1.0 / GameResolution)
#define OriginalSize float4(GameResolution, 1.0 / GameResolution)
#define OutSize float4(OutputSize, 1.0 / OutputSize)

#define BLEND_NONE 0.
#define LUMINANCE_WEIGHT 1.0

float DistYCbCr(float3 pixA, float3 pixB)
{
	const float3 w = float3(0.2627, 0.6780, 0.0593);
	const float scaleB = 0.5 / (1.0 - w.b);
	const float scaleR = 0.5 / (1.0 - w.r);
	float3 diff = pixA - pixB;
	float Y = dot(diff.rgb, w);
	float Cb = scaleB * (diff.b - Y);
	float Cr = scaleR * (diff.r - Y);
	return sqrt(((LUMINANCE_WEIGHT * Y) * (LUMINANCE_WEIGHT * Y)) + (Cb * Cb) + (Cr * Cr));
}

float get_left_ratio(float2 center, float2 origin, float2 direction, float2 scale)
{
	float2 P0 = center - origin;
	float2 proj = direction * (dot(P0, direction) / dot(direction, direction));
	float2 distv = P0 - proj;
	float2 orth = float2(-direction.y, direction.x);
	float side = sign(dot(P0, orth));
	float v = side * length(distv * scale);
//	return step(0, v);
	return smoothstep(-sqrt(2.0)/2.0, sqrt(2.0)/2.0, v);
}

#define P(x,y) tex2D(OrigTexture, coord + OriginalSize.zw * float2(x, y)).rgb

float4 main(
	float2 TEX0 : TEXCOORD0
) {
	//---------------------------------------
	// Input Pixel Mapping: -|B|-
	//                      D|E|F
	//                      -|H|-

	float2 scale = OutputSize.xy * OriginalSize.zw;
	float2 pos = frac(TEX0.xy * OriginalSize.xy) - float2(0.5, 0.5);
	float2 coord = TEX0.xy - pos * OriginalSize.zw;

	float3 B = P( 0.,-1.);
	float3 D = P(-1., 0.);
	float3 E = P( 0., 0.);
	float3 F = P( 1., 0.);
	float3 H = P( 0., 1.);

	float4 info = floor(tex2D(tex, coord) * 255.0 + 0.5);

	// info Mapping: x|y|
	//               w|z|

	float4 blendResult = floor(fmod(info, 4.0));
	float4 doLineBlend = floor(fmod(info / 4.0, 4.0));
	float4 haveShallowLine = floor(fmod(info / 16.0, 4.0));
	float4 haveSteepLine = floor(fmod(info / 64.0, 4.0));

	float3 res = E;

	// Pixel Tap Mapping: -|-|-
	//                    -|E|F
	//                    -|H|-
	if (blendResult.z > BLEND_NONE)
	{
		float2 origin = float2(0.0, 1.0 / sqrt(2.0));
		float2 direction = float2(1.0, -1.0);
		if (doLineBlend.z > 0.0)
		{
			origin = haveShallowLine.z > 0.0? float2(0.0, 0.25) : float2(0.0, 0.5);
			direction.x += haveShallowLine.z;
			direction.y -= haveSteepLine.z;
		}

		float3 blendPix = lerp(H,F, step(DistYCbCr(E, F), DistYCbCr(E, H)));
		res = lerp(res, blendPix, get_left_ratio(pos, origin, direction, scale));
	}

	// Pixel Tap Mapping: -|-|-
	//                    D|E|-
	//                    -|H|-
	if (blendResult.w > BLEND_NONE)
	{
		float2 origin = float2(-1.0 / sqrt(2.0), 0.0);
		float2 direction = float2(1.0, 1.0);
		if (doLineBlend.w > 0.0)
		{
			origin = haveShallowLine.w > 0.0? float2(-0.25, 0.0) : float2(-0.5, 0.0);
			direction.y += haveShallowLine.w;
			direction.x += haveSteepLine.w;
		}

		float3 blendPix = lerp(H,D, step(DistYCbCr(E, D), DistYCbCr(E, H)));
		res = lerp(res, blendPix, get_left_ratio(pos, origin, direction, scale));
	}

	// Pixel Tap Mapping: -|B|-
	//                    -|E|F
	//                    -|-|-
	if (blendResult.y > BLEND_NONE)
	{
		float2 origin = float2(1.0 / sqrt(2.0), 0.0);
		float2 direction = float2(-1.0, -1.0);

		if (doLineBlend.y > 0.0)
		{
			origin = haveShallowLine.y > 0.0? float2(0.25, 0.0) : float2(0.5, 0.0);
			direction.y -= haveShallowLine.y;
			direction.x -= haveSteepLine.y;
		}

		float3 blendPix = lerp(F,B, step(DistYCbCr(E, B), DistYCbCr(E, F)));
		res = lerp(res, blendPix, get_left_ratio(pos, origin, direction, scale));
	}

	// Pixel Tap Mapping: -|B|-
	//                    D|E|-
	//                    -|-|-
	if (blendResult.x > BLEND_NONE)
	{
		float2 origin = float2(0.0, -1.0 / sqrt(2.0));
		float2 direction = float2(-1.0, 1.0);
		if (doLineBlend.x > 0.0)
		{
			origin = haveShallowLine.x > 0.0? float2(0.0, -0.25) : float2(0.0, -0.5);
			direction.x -= haveShallowLine.x;
			direction.y += haveSteepLine.x;
		}

		float3 blendPix = lerp(D,B, step(DistYCbCr(E, B), DistYCbCr(E, D)));
		res = lerp(res, blendPix, get_left_ratio(pos, origin, direction, scale));
	}

	return float4(res, 1.0);
}



## ----- TECH ---------------------------------------------------------------------

technique Standard
{
	blendfunc = opaque;
	vs = Shared + Vertex;
	fs = Shared + Fragment;
	vertexattrib[0] = position;
}
