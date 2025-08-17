Shader "Custom/UnityKorea/base02_3"
{
    /*
    [Transparent]
    해당 픽셀의 값을 알파값에 따라 덧 그려 반투명으로 그려지게 된다. 
    자동으로 정렬되는 2500까지의 shader와 달리 여기서부터는 사용자가 렌더큐를 직접 관리해야 한다
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
            //@TK : Transparent 방식을 위해 렌더타입과 Queue 변경 (그리는 순서 변경)
            "RenderType"="Transparent"
            "Queue"="Transparent"
        }
        //@TK: BlendOperation 선언해야한다. (투명될 때, 겹쳐지는 부분의 우선순위 결정)
    	Pass 
    	{  	
            Blend [_SrcBlend] [_DstBlend]
            /*
            [Cull]
            컬링은 화면에 그려지는 삼각형의 앞,뒷면을 그릴지를 결정하는 방법이다.
            기본값은 면이 보여지는 기본 방향을 그릴수 있으나 이를 사용자가 앞면, 뒷면 혹은 앞뒷면을 모두 다 그릴수 있다.
            */
            Cull [_Cull]
            //Cull Back | Front | off 

            /*
            [ZWrite] 
            오브젝트의 픽셀이 depth buffer에 작성되는지 여부를 제어(기본값은 On).
            불투명한 오브젝트를 그릴 경우 On 상태로 유지하면 되지만 반투명한 효과를 그릴경우 ZWrite Off로 전환한다.
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
