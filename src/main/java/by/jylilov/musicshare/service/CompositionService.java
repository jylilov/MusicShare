package by.jylilov.musicshare.service;

import by.jylilov.musicshare.model.Composition;

import java.util.Collection;

public interface CompositionService {
    Composition get(Integer id);
    Collection<Composition> getAll();
}
