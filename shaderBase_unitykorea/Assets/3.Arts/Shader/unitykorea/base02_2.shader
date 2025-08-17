Shader "Custom/UnityKorea/base02_2"
{
    /*
    [Transparent]
    �ش� �ȼ��� ���� ���İ��� ���� �� �׷� ���������� �׷����� �ȴ�. 
    �ڵ����� ���ĵǴ� 2500������ shader�� �޸� ���⼭���ʹ� ����ڰ� ����ť�� ���� �����ؾ� �Ѵ�
    */

    Properties
    {  
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
        _Alpha("Alpha", Range(0, 1)) = 0.5
    }  

	SubShader
	{  

	    Tags
        {
	        "RenderPipeline"="UniversalPipeline"
            //@TK : Transparent ����� ���� ����Ÿ�԰� Queue ���� (�׸��� ���� ����)
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        //@TK: BlendOperation �����ؾ��Ѵ�. (����� ��, �������� �κ��� �켱���� ����)
    	Pass 
    	{  	
            Blend SrcAlpha OneMinusSrcAlpha

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

            float _Alpha;

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
                float4 col = _MainTex.Sample(sampler_MainTex, i.uv);
                col.rgb *= _TintColor * _Intensity;
                col.a *= _Alpha;
                return col;
            }
                    
        	ENDHLSL  
    	}
     }
}
