Shader "Custom/UnityKorea/base03"
{
/*
uv 출력
*/
    Properties
    {   
    
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
  
         	struct VertexInput
         	{
            	float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
          	};

        	struct VertexOutput
          	{
           	    float4 vertex  	: SV_POSITION;
                float2 uv : TEXCOORD0;
      	    };

      	    VertexOutput vert(VertexInput v)
        	{

          	    VertexOutput o;      
          	    o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv;
         	    return o;
        	}

        	float4 frag(VertexOutput i) : SV_Target
        	{ 
                //uv 정보값 출력
          	    return float4(i.uv.x, i.uv.y, 0, 1);  
            }

        	ENDHLSL  
    	}
     }
}
