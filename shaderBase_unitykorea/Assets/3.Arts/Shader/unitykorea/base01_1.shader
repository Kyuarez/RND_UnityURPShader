Shader "Custom/UnityKorea/base01_1"
{
    Properties
    {  
        //@ _는 변수명 할 때 대개 쓰이는 문법이다. ::변수명(인스펙터 노출명, 키워드) = 값
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
    }  

    //메시 렌더링 시, Unity는 GPU와 호환되는 SubShader 블록을 선택(Tags 포함)
	SubShader
	{  

	    Tags
        {
	        "RenderPipeline"="UniversalPipeline"
            /* RenderType
            셰이더를 미리 정의한 여러 그룹으로 분리. 불투명 셰이더나 알파 테스트 된 셰이더들 해당
            */
            "RenderType"="Opaque"
            /* QueueTag
            유니티는 큐 태그를 통해서 그리는 순서를 결정한다.
            -background 1000 : 다른 것들보다 먼저 렌더링
            -geometry 2000(Default) : 대부분의 불투명 오브젝트
            -Alpha Test 2450 : 알파 테스트를 거친 지오메트리(기본적으로 모든 불투명을 그리고 알파 처리하는 것이 성능상 좋아서)
            -Transparent 3000 : 알파 블렌딩 된 모든 것들 (유리, 파티클 이펙트 등등)
            -Overlay 4000 : 오버레이 효과를 위해 마지막으로 렌더링 된 것
            */
            "Queue"="Geometry"
        }
    	Pass //셰이더에 사용할 각 렌더 패스 결정
    	{  		
     	    Name "Universal Forward"
            Tags 
            { 
                "LightMode" = "UniversalForward" 
            }

            /*HLSL Snippet :: Unity SRP는 대체로 HLSL로 작성됨
            비슷한 종류 :: CG(Nvidia), GLSL(OpenGL), HLSL(DX시리즈)
            */
       	    HLSLPROGRAM

            //컴파일러 지시자. (컴파일러 처리)
        	#pragma prefer_hlslcc gles
        	#pragma exclude_renderers d3d11_9x
        	#pragma vertex vert
        	#pragma fragment frag

       	    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
  
            /*
            struct 식별자
            {
                name(변경가능) : semantic(문법)
            };
            POSITION :: 로컬 공간의 정점 위치
            NORMAL :: 버텍스의 노멀
            TEXCOORD :: 버텍스의 UV좌표
            TANGENT :: 메시에서 계산된 또는 import된 탄첸트 값
            COLOR :: 버텍스의 컬러값
            */
         	struct VertexInput //버텍스 버퍼에서 필요한 정보 가져오기(메쉬의 정보)
         	{
            	float4 vertex : POSITION; //로컬 공간의 정점 위치
          	};

            half4 _TintColor;

            /* 보간기(vertex 계산된 값을 pixes(frag)로 이동)
            SV_POSITION :: 투영 공간으로 변환 된 후의 버텍스 포지션
            NORMAL :: 뷰 공간으로 변형된 후 버텍스의 노멀
            TEXCOORD :: 첫번째 UV채널 좌표 값
            TANGENT :: 탄첸트 값
            COLOR :: 버텍스의 컬러값
            **보간기의 숫자는 shader model 의 영향을 받는다. (최적화와 관련 이슈)
            */
        	struct VertexOutput
          	{
           	    float4 vertex  	: SV_POSITION;
      	    };

            /*
            VertexInput을 받아서 어떻게 VertexOutput을 출력할 것인지 처리
            */
      	    VertexOutput vert(VertexInput v)
        	{

          	    VertexOutput o;      
          	    o.vertex = TransformObjectToHClip(v.vertex.xyz);

         	    return o;
        	}

        	half4 frag(VertexOutput i) : SV_Target
        	{ 
          	    return half4(_TintColor);  
        	}
                    
        	ENDHLSL  
    	}
     }
}
