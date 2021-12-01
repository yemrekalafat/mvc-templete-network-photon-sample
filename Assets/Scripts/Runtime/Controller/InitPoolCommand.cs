using Runtime.Model;
using MVC.Base.Runtime.Abstract.Model;
using strange.extensions.command.impl;

namespace Runtime.Controller
{
    public class InitPoolCommand : Command
    {
        [Inject] public IObjectPoolModel PoolModel { get; set; }
        [Inject] public IGameModel GameModel { get; set; }
        public override void Execute()
        {
            for (int i = 0; i < GameModel.PoolHelper.List.Count; i++)
            {
                var item = GameModel.PoolHelper.List[i];
                PoolModel.Pool(item.Key.ToString(),item.Prefab,item.Count);
            }
            
        }
    }
}