Shader "Unlit/Shader1"
{
    Properties
    {
        _ColorA("Color A", Color) = (1,1,1,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _Scale("UV Scale" , Float) = 1
        _Offset("UV Offset" , Float) = 0
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            //float _Scale;
            //float _Offset;

            struct Meshdata //meshdata per vertex
            {
                float4 vertex : POSITION; //vertex position
                float3 normals : NORMAL;
                float4 uv0 : TEXCOORD0;    // uv0 diffuse/normal map textures
                //float4 uv1 : TEXCOORD1;   // uv1 coordniates lightmap coordinates
                // float4 tangent : TANGENT;
                //float4 color : COLOR; 
                
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (Meshdata v)  //vertex
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex); //converts local space to clip space
                o.normal = UnityObjectToWorldNormal(v.normals);
                o.uv = v.uv0;      //(v.uv0 + _Offset) * _Scale;
                return o;
            }

            float4 frag(Interpolators i) : SV_Target  //pixel
            {
                //Blend between two colors based on the x uv coordinate
                float4 outColor = lerp(_ColorA,_ColorB,i.uv.x);


                return outColor;
            }
            ENDCG
        }
    }
}


//float (32 bit float)
//half (16 bit float)
//fixed (lower precision) -1 to 1
//float4-> half4-> fixed4
//use float unitl you need to optimize

//float4 myValue;
//float4 otherValue = myValue.xxxx //swizzling