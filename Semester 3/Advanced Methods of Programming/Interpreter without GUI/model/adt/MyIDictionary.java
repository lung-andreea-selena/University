package model.adt;
import exception.MyException;

import java.util.Collection;
import java.util.Map;
import java.util.Set;
public interface MyIDictionary<K,V> {
    void update(K k, V v) throws MyException;

    void put(K k, V v);

    Map<K,V> getContent();

    boolean isDefined(K k);

    V lookUp(K k) throws MyException;

    void remove(K k) throws MyException;

    Collection<V> values();
    Set<K> keyset();
    MyIDictionary<K,V> deepCopy() throws MyException;

}
