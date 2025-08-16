Shader "Custom/UnityKorea/base01_2"
{
    /*
    Coupled textures and Sampling
    Base Shader with Main Texture by DX9 
    */

    Properties
    {  
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
    }  

    //�޽� ������ ��, Unity�� GPU�� ȣȯ�Ǵ� SubShader ����� ����(Tags ����)
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

            //�����Ϸ� ������. (�����Ϸ� ó��)
        	#pragma prefer_hlslcc gles
        	#pragma exclude_renderers d3d11_9x
        	#pragma vertex vert
        	#pragma fragment frag

       	    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
  
            float _Intensity;
            float4 _TintColor;

            sampler2D _MainTex;
            float4 _MainTex_ST;

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

      	    VertexOutput vert(VertexInput v) //vertex buffer���� ����� ����
        	{
          	    VertexOutput o;      
          	    o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = v.uv.xy;
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
                //scale�� �����ְ�, offset�� �����ش�.
          	    float2 uv = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                //tex2D :: ���ø� ����
                float4 color = tex2D(_MainTex, uv) * _TintColor * _Intensity;
                return color;
            }
                    
        	ENDHLSL  
    	}
     }
}
