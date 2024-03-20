package a7.interpreterwithgui.model.adt;

import a7.interpreterwithgui.exception.MyException;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public class MyDictionary<K,V> implements MyIDictionary<K,V>{
    private Map<K,V> map;
    public MyDictionary()
    {
        map=new HashMap<K,V>();
    }

    @Override
    public Map<K,V> getContent()
    {
        return map;
    }

    @Override
    public void update(K k, V v) throws MyException //update
    {
        if(!isDefined(k))
            throw new MyException(k+" is not defined.");
        map.put(k,v);
    }

    @Override
    public boolean isDefined(K k)
    {
        return this.map.containsKey(k);
    }

    @Override
    public V lookUp(K k) throws MyException
    {
        if(!isDefined(k))
            throw new MyException(k+" is not defined.");
        return map.get(k);
    }

    @Override
    public String toString()
    {
        return "MyDictionary{" +
                "map=" + map +
                '}';
    }

    @Override
    public void put(K key, V value) {
        this.map.put(key, value);
    }

    public Map <K,V> getMap()
    {
        return map;
    }
    public void setMap(Map<K,V> map)
    {
        this.map=map;
    }
    @Override
    public void remove(K k) throws MyException
    {
        if(!isDefined(k))
            throw new MyException(k +"is not defined");
        this.map.remove(k);
    }
    @Override
    public Collection<V> values()
    {
        return this.map.values();
    }
    @Override
    public Set<K> keyset()
    {
        return this.map.keySet();
    }
    @Override
    public MyIDictionary<K,V> deepCopy() throws MyException
    {
        MyIDictionary<K,V> toReturn = new MyDictionary<>();
        for(K key: keyset())
            toReturn.put(key,lookUp(key));
        return toReturn;
    }

}
