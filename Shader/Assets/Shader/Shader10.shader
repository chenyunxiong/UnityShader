Shader "Custom/Shader10"
{
    Properties
    {
        _MainTex("Main Tex", 2D) = "white"{}
        _Color ("Main Tint", Color) = (1, 1, 1, 1)
        _InvwaveLength("InvwaveLength", Range(0, 5)) = 0.5
        _Frequency("Frequency", Range(0, 5)) = 0.5
        _Magnitude("Magnitude", Range(0, 4)) = 0.5
        _Speed("Speed", Range(0, 4)) = 1
    }

    SubShader
    {
        Tags{"Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "DisableBatching" = "True"}
        Pass
        {
            Tags{"LightNode" = "ForwardBase"}
            Zwrite off
            Blend SrcAlpha OneMinusSrcAlpha
            Cull off

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
                float2 uv : TEXCOORD0;
            };

            float4 _MainTex_ST;
            sampler2D _MainTex;
            float _InvwaveLength;
            float _Frequency;
            float _Magnitude;
            float _Speed;
            float4 _Color;


            v2f vert(a2v v)
            {
                v2f o;
                
                float4 offset;
                offset.yzw = float3(0.0, 0.0, 0.0);
                offset.x = sin(_Frequency * _Time.y + v.vertex.x * _InvwaveLength);// + v.vertex.y * _InvwaveLength + v.vertex.z * _InvwaveLength) * _Magnitude;
                o.pos = UnityObjectToClipPos(v.vertex + offset);

                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.uv += float2(0.0, _Time.y * _Speed);

                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 c = tex2D(_MainTex, i.uv);
                c.rgb *= _Color.rgb;
                return c;
            }

            ENDCG
        }
    }
}