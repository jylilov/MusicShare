package by.jylilov.musicshare.service;

import by.jylilov.musicshare.model.Composition;
import by.jylilov.musicshare.model.User;

import java.util.Collection;

public interface CompositionService {
    Composition get(Integer id);
    Collection<Composition> getAll();
    void updateComposition(Composition composition);
    void deleteComposition(Integer id);
}
