Shader "Custom/UnityKorea/base02_3"
{
    /*
    [Transparent]
    �ش� �ȼ��� ���� ���İ��� ���� �� �׷� ���������� �׷����� �ȴ�. 
    �ڵ����� ���ĵǴ� 2500������ shader�� �޸� ���⼭���ʹ� ����ڰ� ����ť�� ���� �����ؾ� �Ѵ�
    */

    Properties
    {  
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Intensity", Range(0, 10)) = 0.5
        _MainTex("Main Texture", 2D) = "white"{}
        _Alpha("Alpha", Range(0, 1)) = 0.5
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("Src Blend", Float) = 1
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("Dst Blend", Float) = 0
        
        [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", Float) = 1
        [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", Float) = 0 
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
            Blend [_SrcBlend] [_DstBlend]
            /*
            [Cull]
            �ø��� ȭ�鿡 �׷����� �ﰢ���� ��,�޸��� �׸����� �����ϴ� ����̴�.
            �⺻���� ���� �������� �⺻ ������ �׸��� ������ �̸� ����ڰ� �ո�, �޸� Ȥ�� �յ޸��� ��� �� �׸��� �ִ�.
            */
            Cull [_Cull]
            //Cull Back | Front | off 

            /*
            [ZWrite] 
            ������Ʈ�� �ȼ��� depth buffer�� �ۼ��Ǵ��� ���θ� ����(�⺻���� On).
            �������� ������Ʈ�� �׸� ��� On ���·� �����ϸ� ������ �������� ȿ���� �׸���� ZWrite Off�� ��ȯ�Ѵ�.
            */ 
            ZWrite [_ZWrite]
            //ZWrite off | on

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
