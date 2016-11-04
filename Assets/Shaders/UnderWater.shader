/*
/ ***CUSTOM 'UNITY' SHADER***
/ (UNDER WATER)
/
/ This shader is meant to project the illusion that the player is under water.
/ Once applied to the sprite, the screen gets a 'wavy' feeling.
/ The strength of the shader can be determined by our '_StrengthOfWaves' slider.
/ These values will later on get adjusted in a C# script.
*/


Shader "Custom/UnderWater" // Creates our directory for our shader.
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Color("Color", color) = (1,1,1,1) 
		_WaveTex("Wave Texture", 2D) = "white" {}
		_StrengthOfWaves("Strength of Waves", Range(0,0.1)) = 1
	}

	/*
	/ Properties: Simply act as (serialized) variables.
	/ Declaring a property means that it will be available
	/ To be used/adjusted in the Unity Editor.
	*/


	SubShader

	/*
	/ This is where the shader gets to work.
	/ A .shader can contain multiple SubShaders. If it does, the computer will then
	/ check which SubShader is most suitable for it's running hardware.
	*/
	{

		Tags
		{
			"Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True"
		}

		// This makes our sprite render after the opaque geometry.

		
		Cull Off ZWrite Off ZTest Always
			// No culling or depth.

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha // This takes care of the alpha surrounding the sprite/texture.

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc" // We will be needing this to 'animate' our shader.

			struct appdata
			{
				float4 vertex : POSITION; // Position resembles a Vector3.
				float2 uv : TEXCOORD0;
			};
			
			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o; // 1
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex); // 2
				o.uv = v.uv; // 3
				return o; // 4
			}

			/*
			/ 1:  Initialize a 'v2f' called o.
			/
			/ 2: 
			/ o.vertex: mul (Multiply) multiplies the built-in 
			/ UNITY_MATRIX_MVP to the appdata's vertex.
			/ This brings the appdata's vertex to a position that is relevant
			/ To Unity's screen.
			/
			/ 3: Assign o.uv to v.uv (appdata's uv).
			/ 4: Returns o.
			*/
			
			sampler2D _MainTex; 
			sampler2D _WaveTex;
			float _StrengthOfWaves;
			float4 _Color;

			/*
			/ We need to define our variables.
			/ We need one for each property we've set at the start of our shader.
			*/

			float4 frag (v2f i) : SV_Target
			{
				float2 disp = tex2D(_WaveTex, i.uv).xy;

				disp = ((disp * 2) - 1) * _StrengthOfWaves;

				float4 col = tex2D(_MainTex, i.uv + disp) * _Color;
				return col;
			}

				/*
				/ The 'frag' method takes care of displaying everything that's been
				/ Programmed up til now, whether that would be a simple color,
				/ uv's, or any effects the user is willing to achieve.
				*/

			ENDCG
		}
	}
}