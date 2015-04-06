package by.jylilov.musicshare.service;

import by.jylilov.musicshare.model.Playlist;

import java.util.Collection;

public interface PlaylistService {
    Collection<Playlist> getAll();
    Playlist get(Integer id);
}
