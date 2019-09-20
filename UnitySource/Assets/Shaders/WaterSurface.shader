Shader "Unlit/WaterSurface"
{
    Properties
    {
        _PrimaryTexture ("Primrary Texture", 2D) = "white" {}
        _SecondaryTexture ("Secondary Texture", 2D) = "white" {}
        _RotationSpeedA ("Rotation Speed A", Float) = 0 
        _RotationSpeedB ("Rotation Speed B", Float) = 0
        _BaseAlpha ("Base Alpha", Float) = 0 
        _AlphaClip ("Alpha Clip", Float) = 0 
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        LOD 100
        Blend SrcAlpha SrcAlpha

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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _PrimaryTexture;
            float4 _PrimaryTexture_ST;
            sampler2D _SecondaryTexture;
            float4 _SecondaryTexture_ST;

            float _RotationSpeedA;
            float _RotationSpeedB;

            float _BaseAlpha;
            float _AlphaClip;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _PrimaryTexture);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                //Rotation of primary texture
                float sinXA = sin ( _RotationSpeedA * _Time );
                float cosXA = cos ( _RotationSpeedA * _Time );
                float sinYA = sin ( _RotationSpeedA * _Time );
                float2x2 rotationMatrixA = float2x2( cosXA, -sinXA, sinYA, cosXA);

                //Rotation of secondary texture
                float sinXB = sin ( _RotationSpeedB * _Time );
                float cosXB = cos ( _RotationSpeedB * _Time );
                float sinYB = sin ( _RotationSpeedB * _Time );
                float2x2 rotationMatrixB = float2x2( cosXB, -sinXB, sinYB, cosXB);

                //sample the colors from both textures
                fixed4 colorA = tex2D(_PrimaryTexture, mul(i.uv, rotationMatrixA));
                fixed4 colorB = tex2D(_SecondaryTexture, mul(i.uv, rotationMatrixB));
                
                if (colorA.r + colorB.r > _AlphaClip)
				    return float4(1, 1, 1, _BaseAlpha);
				else
                    return float4(1, 1, 1, 0);
            }
            ENDCG
        }
    }
}
