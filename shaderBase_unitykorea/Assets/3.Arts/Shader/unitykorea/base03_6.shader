Shader "Custom/UnityKorea/base03_6"
{
    /*
    UV_Scroll + flowmap 
    �ٸ� �ؽ�ó�� ����ؼ� uv �����ӿ� ���ǿ� ���� �߰��ؼ� ��ȭ�ϴ� ���
    */
    Properties
    {   
        _TintColor("Color", color) = (1,1,1,1)
        _Intensity("Intensity", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white" {}
        //[NoScaleOffset] :: ������Ƽ���� tile�� offset â�� ����� �Ӽ�
        [NoScaleOffset] _FlowMap("Flow Map", 2D) = "white"{}
        _FlowTime("Flow Time", Range(0, 10)) = 1
        _FlowIntensity("Flow Intensity", Range(0, 10)) = 1
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

            float4 _MainTex_ST;
            Texture2D _MainTex;
            SamplerState sampler_MainTex;

            Texture2D _FlowMap;
            float _FlowIntensity;
            float _FlowTime;

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
                o.uv = v.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                /*
                _Time, _SinTime, _CosTime :: float4
                Q. �� x > y > z > w ������ �ӵ��� ����� ��������? :: ���ʿ� �׷��� ����.
                */
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
                float4 flow = _FlowMap.Sample(sampler_MainTex, i.uv);
                //frac... max �� �� 0���� back (elapsedTime)
                i.uv += frac(_Time.x * _FlowTime) + flow.rg * _FlowIntensity;

                float4 col = _MainTex.Sample(sampler_MainTex, i.uv);
                col.rgb *= _TintColor * _Intensity;
          	    return col;  
            }

        	ENDHLSL  
    	}
     }
}
