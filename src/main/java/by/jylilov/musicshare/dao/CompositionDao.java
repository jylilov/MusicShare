package by.jylilov.musicshare.dao;

import by.jylilov.musicshare.model.Composition;

import java.util.Collection;

public interface CompositionDao {
    Composition get(Integer id);
    Collection<Composition> getAll();
    void updateComposition(Composition composition);
    void deleteComposition(Integer id);
}
