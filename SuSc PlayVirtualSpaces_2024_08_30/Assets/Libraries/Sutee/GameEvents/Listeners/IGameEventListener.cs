

namespace sutee.GameEvents2 {
    public interface IGameEventListener<T> {
        void OnEventRaised(T item);
    }

    public interface IGameEventListener<T0, T1>
    {
        void OnEventRaised(T0 t0item, T1 t1item);
    }
}