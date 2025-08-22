Shader "Custom/UnityKorea/base04_1"
{
    /*
    Lambert Lighting
    �ܼ��ϰ� ���� ����� ���� ������ �����ؼ� ������ ǥ��
    Normal :: ���� ����
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
                //���� normal(����)�� ���� ������ ������ �߿��ϴ�. saturate�� �׳� ����
                col.rgb *= saturate(dot(i.normal, light)) * lightColor;
                return col;
        	}

        	ENDHLSL  
    	}
     }
}
