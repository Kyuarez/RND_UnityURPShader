Shader "Custom/UnityKorea/base02_1"
{
    /*
    [AlphaTest(Cutout)]
    불투명(opaque) 오브젝트를 그린후 알파 테스트를 거쳐 픽셀값을 제거한 오브젝트가 그려지게 된다. 
    모든 불투명 오브젝트를 그린후에 알파테스트된 오브젝트를 렌더링 하는것이 효율적이기 때문에 
    이를 별개의 큐로 구분해서(TransparentCutout, 2450) 사용하게 된다. 
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
            //@TK : Cutout 방식을 위해 렌더타입과 Queue 변경 (그리는 순서 변경)
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
                //clip(x) : x의 한 원소가 0보다 작으면 현재 픽셀을 버린다. 이 함수는 픽셀셰이더에서만 사용할 수 있다
                clip(color.a - _AlphaCut); //계산하고 0보다 작은 픽셀에 대해서 날리기
                return color;
            }
                    
        	ENDHLSL  
    	}
     }
}
