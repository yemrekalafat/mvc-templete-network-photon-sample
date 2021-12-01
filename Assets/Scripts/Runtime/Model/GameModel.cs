using Runtime.Data.UnityObject;
using UnityEngine;

namespace Runtime.Model
{
    public class GameModel : IGameModel
    {
        private RD_GameStatus _status;
        private RD_PoolHelper _poolHelper;

        [PostConstruct]
        public void OnPostConstruct()
        {
            _status = Resources.Load<RD_GameStatus>("Data/AppStatus");
            _poolHelper = Resources.Load<RD_PoolHelper>("Data/PoolHelper");
        }

        public RD_GameStatus Status
        {
            get
            {
                if (_status == null)
                    OnPostConstruct();
                return _status;
            }
        }
        
        public RD_PoolHelper PoolHelper
        {
            get
            {
                if (_poolHelper == null)
                    OnPostConstruct();
                return _poolHelper;
            }
        }

        public void Clear()
        {
        }
    }
}