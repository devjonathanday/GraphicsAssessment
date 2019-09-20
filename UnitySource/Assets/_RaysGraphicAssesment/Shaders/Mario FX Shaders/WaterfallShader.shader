Shader "Rays Custom/Mario FX/WaterfallShader"
{
	Properties
	{
		_MainTex("Main Texture", 2D) = "white" {}
		_MainScrollSpeed("Main Texture Scroll Speed", Float) = 0.2
		_MainBaseAlpha("Main Texture Base Alpha", Range(0.0, 1.0)) = 0.2
		_MainCutoffThresh("Main Texture Color Threshold", Range(0.0,1.0)) = 0.05

		_DispTex("Displacement Texture", 2D) = "white"{}
		_DispScrollSpeed("Displacement Texture Scroll Speed", Float) = 0.2
		_DispIntensity("Displacement Intensity", Float) = 0.1
	}
		SubShader
		{
			Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
			LOD 100

			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				struct appdata
				{
					float4 vertex : POSITION;
					float2 uv : TEXCOORD0;
				};

				struct v2f
				{
					float2 uv : TEXCOORD0;
					float4 vertex : SV_POSITION;
				};

				sampler2D _MainTex;
				float4 _MainTex_ST;

				float _MainScrollSpeed;
				float _MainBaseAlpha;
				float _MainCutoffThresh;

				sampler2D _DispTex;
				sampler2D _DispTex_ST;
				float _DispScrollSpeed;
				float _DispIntensity;


				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					float4 dispCol = tex2D(_DispTex, float2(i.uv.x, i.uv.y + _Time.y * _DispScrollSpeed));
					float displacementVal = (dispCol - 0.5f) * 2 * _DispIntensity;

					fixed4 col = tex2D(_MainTex, float2(i.uv.x + displacementVal, i.uv.y + displacementVal + _Time.y * _MainScrollSpeed));

					if (col.r <= _MainCutoffThresh)
					{
						col.a = 0.0f;
					}
					else
					{
						col.a = _MainBaseAlpha;
					}

					return  col;
				}
				ENDCG
			}
		}
}
