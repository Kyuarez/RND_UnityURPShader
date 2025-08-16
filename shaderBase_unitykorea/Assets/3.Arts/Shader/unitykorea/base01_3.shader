Shader "Custom/UnityKorea/base01_3"
{
    /*
    [Texture Sampling]
    Base Shader with Main Texture + Sampler
    */

    Properties
    {  
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
    }  

    //메시 렌더링 시, Unity는 GPU와 호환되는 SubShader 블록을 선택(Tags 포함)
	SubShader
	{  

	    Tags
        {
	        "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }
    	Pass 
    	{  		
     	    Name "Universal Forward"
            Tags 
            { 
                "LightMode" = "UniversalForward" 
            }

       	    HLSLPROGRAM

        	#pragma prefer_hlslcc gles
        	#pragma exclude_renderers d3d11_9x
        	#pragma vertex vert
        	#pragma fragment frag

       	    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
  
            float _Intensity;
            float4 _TintColor;

            Texture2D _MainTex;
            float4 _MainTex_ST;
            SamplerState sampler_MainTex;

         	struct VertexInput 
         	{
            	float4 vertex : POSITION; //로컬 공간의 정점 위치
          	    float2 uv : TEXCOORD0;
            };


        	struct VertexOutput
          	{
           	    float4 vertex  	: SV_POSITION;
                float2 uv : TEXCOORD0;
      	    };

      	    VertexOutput vert(VertexInput v) //vertex buffer에서 계산한 정보
        	{
          	    VertexOutput o;      
          	    o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
                float uv = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                float4 color = _MainTex.Sample(sampler_MainTex, uv) * _TintColor * _Intensity;
                //float4 color = tex2D(_MainTex, i.uv) * _TintColor * _Intensity;
                return color;
            }
                    
        	ENDHLSL  
    	}
     }
}
