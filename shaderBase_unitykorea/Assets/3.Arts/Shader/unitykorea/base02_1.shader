Shader "Custom/UnityKorea/base02_1"
{
    /*
    [AlphaTest(Cutout)]
    ������(opaque) ������Ʈ�� �׸��� ���� �׽�Ʈ�� ���� �ȼ����� ������ ������Ʈ�� �׷����� �ȴ�. 
    ��� ������ ������Ʈ�� �׸��Ŀ� �����׽�Ʈ�� ������Ʈ�� ������ �ϴ°��� ȿ�����̱� ������ 
    �̸� ������ ť�� �����ؼ�(TransparentCutout, 2450) ����ϰ� �ȴ�. 
    */

    Properties
    {  
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
        _AlphaCut("AlphaCut", Range(0, 1)) = 0.5
    }  

	SubShader
	{  

	    Tags
        {
	        "RenderPipeline"="UniversalPipeline"
            //@TK : Cutout ����� ���� ����Ÿ�԰� Queue ���� (�׸��� ���� ����)
            "RenderType"="TransparentCutout"
            "Queue"="AlphaTest"
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
            float4 _MainTex_ST;
            SamplerState sampler_MainTex;

            float _AlphaCut;

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
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
                float4 color = _MainTex.Sample(sampler_MainTex, i.uv) * _TintColor * _Intensity;
                //clip(x) : x�� �� ���Ұ� 0���� ������ ���� �ȼ��� ������. �� �Լ��� �ȼ����̴������� ����� �� �ִ�
                clip(color.a - _AlphaCut); //����ϰ� 0���� ���� �ȼ��� ���ؼ� ������
                return color;
            }
                    
        	ENDHLSL  
    	}
     }
}
