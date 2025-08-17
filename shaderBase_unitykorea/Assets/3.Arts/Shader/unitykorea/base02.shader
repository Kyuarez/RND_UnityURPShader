Shader "Custom/UnityKorea/base02"
{
    /*
    [Texture Sampling]
    Base Shader with Main Texture + Sampler
    +)
    복수의 텍스처 처리
    */

    Properties
    {  
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
        _MainTex02("Main Texture2", 2D) = "white"{}
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
            Texture2D _MainTex02; //@TK :: 샘플러를 분리했기에, 텍스처만 추가하면 됨.
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
                float4 col01 = _MainTex.Sample(sampler_MainTex, i.uv) * _TintColor * _Intensity;
                float4 col02 = _MainTex02.Sample(sampler_MainTex, i.uv) * _TintColor * _Intensity;
                float4 resultCol = col01 + col02;
                return resultCol;
            }
                    
        	ENDHLSL  
    	}
     }
}
