Shader "Custom/UnityKorea/base04_1"
{
    /*
    Lambert Lighting
    단순하게 빛의 방향과 면의 방향을 내적해서 라이팅 표현
    Normal :: 면의 수직
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
  
            float4 _TintColor;
            float _Intensity;

         	struct VertexInput
         	{
            	float4 vertex : POSITION;
                float3 normal : NORMAL;
          	};

        	struct VertexOutput
          	{
           	    float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
      	    };

      	    VertexOutput vert(VertexInput v)
        	{

          	    VertexOutput o;      
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.normal = TransformObjectToWorldNormal(v.normal);
                
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
                float3 light = _MainLightPosition.xyz;
                float3 lightColor = _MainLightColor.rgb;

          	    float4 col = float4(1,1,1,1);
                //면의 normal(수직)과 빛의 방향의 내적이 중요하다. saturate는 그냥 보간
                col.rgb *= saturate(dot(i.normal, light)) * lightColor;
                return col;
        	}

        	ENDHLSL  
    	}
     }
}
