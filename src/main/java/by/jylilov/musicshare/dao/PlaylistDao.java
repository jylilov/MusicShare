package by.jylilov.musicshare.dao;

import by.jylilov.musicshare.model.Playlist;

import java.util.Collection;

public interface PlaylistDao {
    Collection<Playlist> getAll();
    Playlist get(Integer id);
}
