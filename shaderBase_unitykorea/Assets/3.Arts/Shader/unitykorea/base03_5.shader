Shader "Custom/UnityKorea/base03_5"
{
    /*
    UV_Scroll
    텍스처에 움직임 주기
    */
    Properties
    {   
        _TintColor("Color", color) = (1,1,1,1)
        _Intensity("Intensity", Range(0, 1)) = 0.5
        _MainTex("Main Texture", 2D) = "white" {}
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
                Q. 왜 x > y > z > w 순으로 속도가 배수로 빨라지나? :: 애초에 그렇게 짬.
                */
                o.uv.x += _Time.x; //@uv scroll
         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
                float4 col = _MainTex.Sample(sampler_MainTex, i.uv);
                col.rgb *= _TintColor * _Intensity;
          	    return col;  
            }

        	ENDHLSL  
    	}
     }
}
