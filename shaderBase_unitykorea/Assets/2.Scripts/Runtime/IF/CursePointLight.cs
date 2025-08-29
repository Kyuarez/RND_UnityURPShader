using UnityEngine;

namespace IF
{
    /// <summary>
    /// IF: 포인트 라이트의 위치 값을 쉐이더 변수에 업데이팅
    /// </summary>
    [RequireComponent(typeof(MeshRenderer))]
    public class CursePointLight : MonoBehaviour
    {
        [SerializeField] Transform m_PointLightTrs;
        
        Material m_CurseMaterial;

        private void Awake()
        {
            m_CurseMaterial = GetComponent<MeshRenderer>().material;
        }

        private void Update()
        {
            m_CurseMaterial.SetVector("_LightPos", m_PointLightTrs.position);
        }
    }

}

