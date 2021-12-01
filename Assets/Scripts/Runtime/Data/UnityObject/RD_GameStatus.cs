using Runtime.Enums;
using UnityEngine;

namespace Runtime.Data.UnityObject
{
    [CreateAssetMenu(menuName = "Runtime Data/Game Status", order = 10)]
    public class RD_GameStatus : ScriptableObject
    {
        public GameStatus Value;
    }
}