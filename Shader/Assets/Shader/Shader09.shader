Shader "Custom/Shader09"
{
    Properties
    {
        _MainTex ("1st Layer (RBG)", 2D) = "white"{}
        _DetailTex("2nd Layer (RGB)", 2D) = "white"{}
        _ScrollX ("1st Layer Speed", Float) = 1.0
        _Scroll2X ("2st Layer Speed", Float) = 1.0
        _MultipLier ("Layer Multiplier", Float) = 1
    }

    SubShader
    {
        Pass{
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Lighting.cginc"

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 texcoord : TEXCOORD0;
            };

            struct v2f 
            {
                float4 pos : SV_POSITION;
                // float3 worldNormal : TEXCOORD0;
                // float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            float4 _MainTex_ST;
            float4 _DetailTex_ST;
            sampler2D _MainTex;
            sampler2D _DetailTex;
            float _ScrollX;
            float _Scroll2X;
            float _MultipLier;

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex) + frac(float2(_ScrollX, 0.0) * _Time.y);
                // o.uv.zw = TRANSFORM_TEX(v.texcoord, _DetailTex) + frac(float2(_Scroll2X, 0.0) * _Time.y);
                // v2f o;
                // o.pos = UnityObjectToClipPos(v.vertex);
                // o.worldNormal = UnityOBjectToWorldNormal(v.texcoord);
                // o.worldPos = mul(unity_ObjectToWorld, o.vertex).xyz;
                // o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 firstLayer = tex2D(_MainTex, i.uv);
                // fixed4 secondLayer = tex2D(_DetailTex, i.uv.zw);

                // fixed4 c = lerp(firstLayer, secondLayer, secondLayer.a);
                // c.rgb *= _MultipLier;
                return firstLayer;
            }


            ENDCG
        }
    }
}