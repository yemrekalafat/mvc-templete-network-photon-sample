using MVC.Base.Runtime.Abstract.Model;
using MVC.Base.Runtime.Concrete.Context;
using MVC.Base.Runtime.Concrete.Model;
using MVC.Base.Runtime.Extensions;
using Runtime.Controller;
using Runtime.Model;
using Runtime.Signals;


namespace Runtime.Context
{
    public class GameContext :  MVCContext
    {
        private GameSignals _gameSignals;

        protected override void mapBindings()
        {
            base.mapBindings();
            _gameSignals = injectionBinder.BindCrossContextSingletonSafely<GameSignals>();

            injectionBinder.BindCrossContextSingletonSafely<IGameModel, GameModel>();
            injectionBinder.BindCrossContextSingletonSafely<IObjectPoolModel, ObjectPoolModel>();


            commandBinder.Bind(_gameSignals.StartGame).To<InitPoolCommand>();
        }

        public override void Launch()
        {
            _gameSignals.StartGame.Dispatch();
        }
    }
}
