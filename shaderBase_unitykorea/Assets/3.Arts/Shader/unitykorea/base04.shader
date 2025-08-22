Shader "Custom/UnityKorea/base04"
{
    /*
    보간기를 정의하고 World Positon값을 사용해서 오브젝트 컬러 표현
    */
    Properties
    {   
        _TintColor("Color", Color) = (1,1,1,1)
        _Intensity("Intensity", Range(0, 1)) = 0.1
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
          	};

        	struct VertexOutput
          	{
           	    float4 vertex : SV_POSITION;
                float3 color  : COLOR;
      	    };

      	    VertexOutput vert(VertexInput v)
        	{

          	    VertexOutput o;      
          	    float4 positionWS = TransformObjectToHClip(v.vertex.xyz);
                float3 color = TransformObjectToWorld(v.vertex.xyz);

                o.vertex = positionWS + float4(sin(color + _Time.y), 1);
                o.color = color;
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
          	    float4 col = float4(1,1,1,1);
                col.rgb *= _TintColor * _Intensity * i.color;
                return col;
        	}

        	ENDHLSL  
    	}
     }
}
