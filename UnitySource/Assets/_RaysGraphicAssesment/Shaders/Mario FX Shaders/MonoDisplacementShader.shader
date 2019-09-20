Shader "Rays Custom/Mario FX/MonoDisplacementShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DispTex ("Displacement Texture", 2D) = "white" {}
		_DispIntensity ("Displacement Intensity", Float) = 0.1
		_ScrollSpeedX ("UV Scroll Speed X", Float) = 0.5
		_ScrollSpeedY ("UV Scroll Speed Y", Float) = 0.5
	
	}
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

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
            sampler2D _DispTex;
			float4 _DispTex_ST;
            float4 _MainTex_ST;
			float _DispIntensity;
			float _ScrollSpeedX;
			float _ScrollSpeedY;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _DispTex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				//magenta default color
				float4 col = {1,0,1,1};

				//get  color of the displacement texture
				float4 dispCol = tex2D(_DispTex, float2(i.uv.x + _Time.y * _ScrollSpeedX, i.uv.y + _Time.y * _ScrollSpeedY));

				////the 32 bit value of the dispCol;
				//int bitVal = 0;

				////Gross checks to convert the dispCol to bitVal
				//if (dispCol.r >= 1.0f)
				//{
				//	bitVal = 255;
				//}
				//else
				//{
				//	if (dispCol.r <= 0.0f)
				//	{
				//		bitVal = 255;
				//	}
				//	else
				//	{
				//		//This is the statement that should be running
				//		bitVal = (int)floor(dispCol.r * 255.0f);
				//	}
				//}
				//
				////float displacementVal = (((bitVal - 128) / 255.0f) * _DispIntensity);
				float displacementVal = (dispCol - 0.5f) * 2 * _DispIntensity;

				col = tex2D(_MainTex, float2(i.uv.x + displacementVal, i.uv.y + displacementVal));

				return col;
            }
            ENDCG
        }
    }
}
