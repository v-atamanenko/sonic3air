
// Hq2x shader
//   - Adapted for use in Oxygen Engine
//  Copyright (C) 2018-2021 Eukaryot
//
// This shader is derived from original "hq2x.glsl" from https://github.com/Armada651/hqx-shader/blob/master/glsl
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


/*
* Copyright (C) 2003 Maxim Stepin ( maxst@hiend3d.com )
*
* Copyright (C) 2010 Cameron Zemek ( grom@zeminvaders.net )
*
* Copyright (C) 2014 Jules Blok ( jules@aerix.nl )
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU Lesser General Public
* License as published by the Free Software Foundation; either
* version 2.1 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public
* License along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*/





## ----- Shared -------------------------------------------------------------------

//#version 130

//precision mediump float;
//precision mediump int;

#ifdef HQ2X
	#define SCALE 2.0
#endif
#ifdef HQ3X
	#define SCALE 3.0
#endif
#ifdef HQ4X
	#define SCALE 4.0
#endif



## ----- Vertex -------------------------------------------------------------------

uniform float2 GameResolution;

void main(
	float2 position,
	float4 out vTexCoord[4] : TEXCOORD0,
	float4 out gl_Position : POSITION
) {
	gl_Position.x = position.x * 2.0 - 1.0;
	gl_Position.y = 1.0 - position.y * 2.0;
	gl_Position.z = 0.0;
	gl_Position.w = 1.0;

	float2 ps = 1.0 / GameResolution;
	float dx = ps.x;
	float dy = ps.y;

	//   +----+----+----+
	//   |    |    |    |
	//   | w1 | w2 | w3 |
	//   +----+----+----+
	//   |    |    |    |
	//   | w4 | w5 | w6 |
	//   +----+----+----+
	//   |    |    |    |
	//   | w7 | w8 | w9 |
	//   +----+----+----+

	vTexCoord[0].zw = ps;
	vTexCoord[0].xy = position.xy;
	vTexCoord[1] = position.xxxy + float4(-dx, 0, dx, -dy); //  w1 | w2 | w3
	vTexCoord[2] = position.xxxy + float4(-dx, 0, dx, 0);   //  w4 | w5 | w6
	vTexCoord[3] = position.xxxy + float4(-dx, 0, dx, dy);  //  w7 | w8 | w9
}



## ----- Fragment -----------------------------------------------------------------

uniform sampler2D tex;
uniform sampler2D LUT;
uniform float2 GameResolution;

static float3x3 yuv_matrix = float3x3(0.299, -0.169, 0.5, 0.587, -0.331, -0.419, 0.114, 0.5, -0.081);
static float3 yuv_threshold = float3(48.0 / 255.0, 7.0 / 255.0, 6.0 / 255.0);
static float3 yuv_offset = float3(0, 0.5, 0.5);

bool diff(float3 yuv1, float3 yuv2)
{
	float3 v1 = abs((yuv1 + yuv_offset) - (yuv2 + yuv_offset));
	
	bool3 res = bool3(v1.x > yuv_threshold.x, v1.y > yuv_threshold.y, v1.z > yuv_threshold.z);
	return res.x || res.y || res.z;
}

float4 main(
	float4 vTexCoord[4] : TEXCOORD0
) {
	float2 fp = frac(vTexCoord[0].xy * GameResolution);
	float2 quad = sign(-0.5 + fp);

	float dx = vTexCoord[0].z;
	float dy = vTexCoord[0].w;
	float3 p1 = tex2D(tex, vTexCoord[0].xy).rgb;
	float3 p2 = tex2D(tex, vTexCoord[0].xy + float2(dx, dy) * quad).rgb;
	float3 p3 = tex2D(tex, vTexCoord[0].xy + float2(dx, 0) * quad).rgb;
	float3 p4 = tex2D(tex, vTexCoord[0].xy + float2(0, dy) * quad).rgb;

	float3 w1 = mul(tex2D(tex, vTexCoord[1].xw).rgb, yuv_matrix);
	float3 w2 = mul(tex2D(tex, vTexCoord[1].yw).rgb, yuv_matrix);
	float3 w3 = mul(tex2D(tex, vTexCoord[1].zw).rgb, yuv_matrix);

	float3 w4 = mul(tex2D(tex, vTexCoord[2].xw).rgb, yuv_matrix);
	float3 w5 = mul(p1, yuv_matrix);
	float3 w6 = mul(tex2D(tex, vTexCoord[2].zw).rgb, yuv_matrix);

	float3 w7 = mul(tex2D(tex, vTexCoord[3].xw).rgb, yuv_matrix);
	float3 w8 = mul(tex2D(tex, vTexCoord[3].yw).rgb, yuv_matrix);
	float3 w9 = mul(tex2D(tex, vTexCoord[3].zw).rgb, yuv_matrix);

	bool3 pattern[3];
	pattern[0] = bool3(diff(w5, w1), diff(w5, w2), diff(w5, w3));
	pattern[1] = bool3(diff(w5, w4), false, diff(w5, w6));
	pattern[2] = bool3(diff(w5, w7), diff(w5, w8), diff(w5, w9));
	bool4 _cross = bool4(diff(w4, w2), diff(w2, w6), diff(w8, w4), diff(w6, w8));

	float2 index;
	index.x = dot(float3(pattern[0]), float3(1, 2, 4)) +
			  dot(float3(pattern[1]), float3(8, 0, 16)) +
			  dot(float3(pattern[2]), float3(32, 64, 128));
	index.y = dot(float4(_cross), float4(1, 2, 4, 8)) * (SCALE * SCALE) +
			  dot(floor(fp * SCALE), float2(1, SCALE));

	float2 _step = 1.0 / float2(256.0, 16.0 * (SCALE * SCALE));
	float2 offset = _step / 2.0;
	float4 weights = tex2D(LUT, index * _step + offset);
	float sum = dot(weights, float4(1));
	float3 res = (p1 * weights.x + p2 * weights.y + p3 * weights.z + p4 * weights.w) / sum;

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

technique Standard_2x : Standard
{
	define = HQ2X;
}

technique Standard_3x : Standard
{
	define = HQ3X;
}

technique Standard_4x : Standard
{
	define = HQ4X;
}
