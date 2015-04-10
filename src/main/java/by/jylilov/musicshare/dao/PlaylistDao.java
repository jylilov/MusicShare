package by.jylilov.musicshare.dao;

import by.jylilov.musicshare.model.Playlist;
import by.jylilov.musicshare.model.PlaylistComposition;

import java.util.Collection;

public interface PlaylistDao {
    Collection<Playlist> getAll();
    Playlist get(Integer id);
    PlaylistComposition getPlaylistComposition(Integer id);
    void updatePlaylistComposition(PlaylistComposition playlistComposition);
    void updatePlaylist(Playlist playlist);
    void deletePlaylist(Playlist playlist);
    void createPlaylist(Playlist playlist);
}
