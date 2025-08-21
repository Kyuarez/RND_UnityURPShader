Shader "Custom/UnityKorea/base03_4"
{
    /*
    마스크 텍스처를 사용한 텍스처 블랜딩
    :: 두 장의 텍스처를 마스크 텍스처를 통해 add로 더하는 방식..
    */
    Properties
    {   
        _MainTex01("Texture01", 2D) = "white"{}
        _MainTex02("Texture02", 2D) = "white"{}
        _MaskTex("MaskTexure", 2D) = "white"{}
    }  

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
  
            float4 _MainTex01_ST;
            Texture2D _MainTex01;

            float4 _MainTex02_ST;
            Texture2D _MainTex02;

            Texture2D _MaskTex;

            /*@중요:: 당연하지만 sampler_텍스처에서 텍스처의 식별자가 동일해야지 hlsl이 인식한다.*/
            SamplerState sampler_MainTex01;
        
         	struct VertexInput
         	{
            	float4 vertex : POSITION;
                float2 uv : TEXCOORD0; //하나의 uv 정보값에서 오프셋만 다르게 사용할 것이니 input은 uv가 한 개이다.
          	};

        	struct VertexOutput
          	{
           	    float4 vertex  	: SV_POSITION;
                float2 uv : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
      	    };

      	    VertexOutput vert(VertexInput v)
        	{

          	    VertexOutput o;      
          	    o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv.xy * _MainTex01_ST.xy + _MainTex01_ST.zw;
                o.uv2 = v.uv.xy * _MainTex02_ST.xy + _MainTex02_ST.zw;
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
                float4 tex01 = _MainTex01.Sample(sampler_MainTex01, i.uv);
                float4 tex02 = _MainTex02.Sample(sampler_MainTex01, i.uv2);
                float4 mask = _MaskTex.Sample(sampler_MainTex01, i.uv);
                float4 col = lerp(tex01, tex02, mask.r);
                //float4 col = tex01.mask.r + tex02.mask.g;
          	    return col;  
            }

        	ENDHLSL  
    	}
     }
}
