Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            float mod289(float x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
            float4 mod289(float4 x){return x - floor(x * (1.0 / 289.0)) * 289.0;}
            float4 perm(float4 x){return mod289(((x * 34.0) + 1.0) * x);}

            float noise(float3 p){
                float3 a = floor(p);
                float3 d = p - a;
                d = d * d * (3.0 - 2.0 * d);

                float4 b = a.xxyy + float4(0.0, 1.0, 0.0, 1.0);
                float4 k1 = perm(b.xyxy);
                float4 k2 = perm(k1.xyxy + b.zzww);

                float4 c = k2 + a.zzzz;
                float4 k3 = perm(c);
                float4 k4 = perm(c + 1.0);

                float4 o1 = frac(k3 * (1.0 / 41.0));
                float4 o2 = frac(k4 * (1.0 / 41.0));

                float4 o3 = o2 * d.z + o1 * (1.0 - d.z);
                float2 o4 = o3.yw * d.x + o3.xz * (1.0 - d.x);

                return o4.y * d.y + o4.x * (1.0 - d.y);
            }

            float rand(float2 seed) {
                return frac(sin(dot(seed, float2(12.9898,78.233))) * 43758.5453123);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                float time = _Time;
               // float randomValue = rand(float2(floor(i.uv.y * 4.0), time / 100.));
                float4 color;
                
                // glitch
                // if (randomValue < 0.0001) {
                //     color = tex2D(_MainTex, float2(i.uv.x + randomValue - 0.1f, i.uv.y));
                // } else {
                    color = tex2D(_MainTex, i.uv);
                    color *= noise(float3(i.uv, time) * 3.5) / 1.2;
                    
                // }
                
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, color);
                return color;
            }
            ENDCG
        }
    }
}
