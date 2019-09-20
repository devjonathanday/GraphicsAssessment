Shader "Rays Custom/Mario FX/ScrollingWaterShader"
{
    Properties
    {
        _MainTex("NoiseTexture", 2D) = "white" {}
		_ScrollSpeed("Scroll Speed" , Float) = 0.5
		_ScrollOffset("Scroll offset", Float) = 0.5
		_IntesityTresh("Intensity Threshold", Range(0.0,1.0)) = 1
		_BaseAlpha("Base Alpha", Range(0.0,1.0)) = 1
		_PeakIntensityTresh("Peak Thresh", Range(0.0,1.0)) = 1
		_ScrollScale("Second texture scale", Float) = 1
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

			float _ScrollSpeed;
			float _ScrollOffset;
			float _IntesityTresh;
			float _BaseAlpha;
			float _PeakIntensityTresh;
			float _ScrollScale;


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 col;
                fixed4 col1 = tex2D(_MainTex, float2(i.uv.x + _Time.y * _ScrollSpeed, i.uv.y - _Time.y * _ScrollSpeed));
                fixed4 col2 = tex2D(_MainTex, float2( ((i.uv.x * _ScrollScale) - (_Time.y + _ScrollOffset) * _ScrollSpeed), ((i.uv.y * _ScrollScale) - (_Time.y + _ScrollOffset) * _ScrollSpeed)  ));
                
				col = col1 + col2;

				col.a = _BaseAlpha;

				if (col.r > _IntesityTresh)
				{
					if (col.r > _PeakIntensityTresh)
					{
						col.r = 1;
						col.g = 1;
						col.b = 1;
					}
					else
					{
						col.a = 0.0f;
					}
				}



				return col;
            }
            ENDCG
        }
    }
}
