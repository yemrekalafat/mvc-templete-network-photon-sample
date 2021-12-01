using Runtime.Data.UnityObject;

namespace Runtime.Model
{
    /// <summary>
    /// game related datas
    /// </summary>
    public interface IGameModel
    {
        RD_GameStatus Status { get; }
        RD_PoolHelper PoolHelper { get; }
        void Clear();
    }
}