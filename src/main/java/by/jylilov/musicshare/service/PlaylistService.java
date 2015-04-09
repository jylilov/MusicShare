package by.jylilov.musicshare.service;

import by.jylilov.musicshare.model.Playlist;
import by.jylilov.musicshare.model.PlaylistComposition;
import by.jylilov.musicshare.model.User;

import java.util.Collection;

public interface PlaylistService {
    Collection<Playlist> getAll();
    Playlist get(Integer id);
    PlaylistComposition updatePlaylistComposition(PlaylistComposition playlistComposition);
    Playlist updatePlaylist(Playlist playlist);
    User deletePlaylist(Integer id);
}
