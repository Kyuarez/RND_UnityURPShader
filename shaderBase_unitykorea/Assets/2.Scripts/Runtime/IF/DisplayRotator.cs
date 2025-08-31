using UnityEngine;

namespace IF
{
    /// <summary>
    /// 오브젝트 전시 :: Y축 회전
    /// </summary>
    public class DisplayRotator : MonoBehaviour
    {
        [SerializeField] float m_RotateAmount = 1f;

        private void Update()
        {
            transform.Rotate(transform.up, m_RotateAmount * Time.deltaTime, Space.Self);
        }
    }

}   
