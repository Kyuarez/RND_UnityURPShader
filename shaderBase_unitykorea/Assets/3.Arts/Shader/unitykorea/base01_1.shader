Shader "Custom/UnityKorea/base01_1"
{
    Properties
    {  
        //@ _�� ������ �� �� �밳 ���̴� �����̴�. ::������(�ν����� �����, Ű����) = ��
        _TintColor("Color", color) = (1,1,1,1) 
        _Intensity("Range", Range(0, 1)) = 0.5
    }  

    //�޽� ������ ��, Unity�� GPU�� ȣȯ�Ǵ� SubShader ����� ����(Tags ����)
	SubShader
	{  

	    Tags
        {
	        "RenderPipeline"="UniversalPipeline"
            /* RenderType
            ���̴��� �̸� ������ ���� �׷����� �и�. ������ ���̴��� ���� �׽�Ʈ �� ���̴��� �ش�
            */
            "RenderType"="Opaque"
            /* QueueTag
            ����Ƽ�� ť �±׸� ���ؼ� �׸��� ������ �����Ѵ�.
            -background 1000 : �ٸ� �͵麸�� ���� ������
            -geometry 2000(Default) : ��κ��� ������ ������Ʈ
            -Alpha Test 2450 : ���� �׽�Ʈ�� ��ģ ������Ʈ��(�⺻������ ��� �������� �׸��� ���� ó���ϴ� ���� ���ɻ� ���Ƽ�)
            -Transparent 3000 : ���� ���� �� ��� �͵� (����, ��ƼŬ ����Ʈ ���)
            -Overlay 4000 : �������� ȿ���� ���� ���������� ������ �� ��
            */
            "Queue"="Geometry"
        }
    	Pass //���̴��� ����� �� ���� �н� ����
    	{  		
     	    Name "Universal Forward"
            Tags 
            { 
                "LightMode" = "UniversalForward" 
            }

            /*HLSL Snippet :: Unity SRP�� ��ü�� HLSL�� �ۼ���
            ����� ���� :: CG(Nvidia), GLSL(OpenGL), HLSL(DX�ø���)
            */
       	    HLSLPROGRAM

            //�����Ϸ� ������. (�����Ϸ� ó��)
        	#pragma prefer_hlslcc gles
        	#pragma exclude_renderers d3d11_9x
        	#pragma vertex vert
        	#pragma fragment frag

       	    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"        	
  
            /*
            struct �ĺ���
            {
                name(���氡��) : semantic(����)
            };
            POSITION :: ���� ������ ���� ��ġ
            NORMAL :: ���ؽ��� ���
            TEXCOORD :: ���ؽ��� UV��ǥ
            TANGENT :: �޽ÿ��� ���� �Ǵ� import�� źþƮ ��
            COLOR :: ���ؽ��� �÷���
            */
         	struct VertexInput //���ؽ� ���ۿ��� �ʿ��� ���� ��������(�޽��� ����)
         	{
            	float4 vertex : POSITION; //���� ������ ���� ��ġ
          	};

            half4 _TintColor;

            /* ������(vertex ���� ���� pixes(frag)�� �̵�)
            SV_POSITION :: ���� �������� ��ȯ �� ���� ���ؽ� ������
            NORMAL :: �� �������� ������ �� ���ؽ��� ���
            TEXCOORD :: ù��° UVä�� ��ǥ ��
            TANGENT :: źþƮ ��
            COLOR :: ���ؽ��� �÷���
            **�������� ���ڴ� shader model �� ������ �޴´�. (����ȭ�� ���� �̽�)
            */
        	struct VertexOutput
          	{
           	    float4 vertex  	: SV_POSITION;
      	    };

            /*
            VertexInput�� �޾Ƽ� ��� VertexOutput�� ����� ������ ó��
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
