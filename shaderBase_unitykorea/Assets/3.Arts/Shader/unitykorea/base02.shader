Shader "Custom/UnityKorea/base02"
{
    /*
    [Texture Sampling]
    Base Shader with Main Texture + Sampler
    +)
    ������ �ؽ�ó ó��
    */

    Properties
    {  
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
        _MainTex02("Main Texture2", 2D) = "white"{}
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

        	#pragma prefer_hlslcc gles
        	#pragma exclude_renderers d3d11_9x
        	#pragma vertex vert
        	#pragma fragment frag

       	    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
  
            float _Intensity;
            float4 _TintColor;

            Texture2D _MainTex;
            Texture2D _MainTex02; //@TK :: ���÷��� �и��߱⿡, �ؽ�ó�� �߰��ϸ� ��.
            float4 _MainTex_ST;
            SamplerState sampler_MainTex;

         	struct VertexInput 
         	{
            	float4 vertex : POSITION; //���� ������ ���� ��ġ
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
