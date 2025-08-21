Shader "Custom/UnityKorea/base03_4"
{
    /*
    ����ũ �ؽ�ó�� ����� �ؽ�ó ����
    :: �� ���� �ؽ�ó�� ����ũ �ؽ�ó�� ���� add�� ���ϴ� ���..
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

            /*@�߿�:: �翬������ sampler_�ؽ�ó���� �ؽ�ó�� �ĺ��ڰ� �����ؾ��� hlsl�� �ν��Ѵ�.*/
            SamplerState sampler_MainTex01;
        
         	struct VertexInput
         	{
            	float4 vertex : POSITION;
                float2 uv : TEXCOORD0; //�ϳ��� uv ���������� �����¸� �ٸ��� ����� ���̴� input�� uv�� �� ���̴�.
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
