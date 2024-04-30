Shader "Custom/ExampleShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex ("Second Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"
            #pragma multi_compile_instancing

           

            sampler2D _MainTex;
            sampler2D _SecondTex;


            fixed4 frag(v2f_img i) : SV_Target
            {
                float2 u = i.uv / _ScreenParams.xy;
                float2 n = tex2D(_SecondTex, u * 0.1).rg;

                fixed4 texColor = tex2Dlod(_MainTex, float4(i.uv, 0.0, 2.5));

                for (float r = 2.0; r > 0.0; r--)
                {
                    float2 x = _ScreenParams.xy * r * 0.015;
                    float2 p = 6.28 * i.uv * x + (n - 0.5) * 2.0;
                    float2 s = sin(p);
                    fixed4 d = tex2D(_SecondTex, round(i.uv * x - 0.25) / x);
                    float t = (s.x + s.y) * max(0.0, 1.0 - frac(_Time * (d.b + 0.1) + d.g) * 2.0);
                    
                    if (d.r < (5.0 - r) * 0.08 && t > 0.5)
                    {

                        float3 v = normalize(-float3(cos(p), lerp(0.2, 2.0, t - 0.5)));
                        texColor = tex2D(_MainTex, i.uv - v.xy * 0.3);
                    }
                }

                return texColor;
            }
            ENDCG
        }
    }
}
