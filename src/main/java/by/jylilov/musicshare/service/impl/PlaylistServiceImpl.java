package by.jylilov.musicshare.service.impl;

import by.jylilov.musicshare.dao.PlaylistDao;
import by.jylilov.musicshare.dao.UserDao;
import by.jylilov.musicshare.model.Playlist;
import by.jylilov.musicshare.model.PlaylistComposition;
import by.jylilov.musicshare.model.User;
import by.jylilov.musicshare.service.PlaylistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Collection;

@Transactional
@Service
public class PlaylistServiceImpl implements PlaylistService {

    @Autowired
    private PlaylistDao dao;

    @Override
    public Collection<Playlist> getAll() {
        return dao.getAll();
    }

    @Override
    public Playlist get(Integer id) {
        return dao.get(id);
    }

    @Override
    public PlaylistComposition updatePlaylistComposition(PlaylistComposition newPlaylistComposition) {
        PlaylistComposition playlistComposition;
        Integer id = newPlaylistComposition.getId();
        if (id != null) {
            playlistComposition = dao.getPlaylistComposition(id);
            playlistComposition.setCompositionOrder(newPlaylistComposition.getCompositionOrder());
            dao.updatePlaylistComposition(playlistComposition);
        } else {
            playlistComposition = newPlaylistComposition;
            dao.createPlaylistComposition(playlistComposition);

        }
        return playlistComposition;
    }

    @Override
    public Playlist updatePlaylist(Playlist newPlaylist) {
        Playlist playlist;
        if (newPlaylist.getId() != null) {
            playlist = dao.get(newPlaylist.getId());
            playlist.setName(newPlaylist.getName());
            playlist.setDescription(newPlaylist.getDescription());
            dao.updatePlaylist(playlist);
        } else {
            dao.createPlaylist(newPlaylist);
            playlist = newPlaylist;
        }
        return playlist;
    }

    @Override
    public User deletePlaylist(Integer id) {
        Playlist p = dao.get(id);
        dao.deletePlaylist(p);
        return p.getUser();
    }

    @Override
    public void deletePlaylistComposition(Integer id) {
        PlaylistComposition playlistComposition = dao.getPlaylistComposition(id);
        dao.deletePlaylistComposition(playlistComposition);
    }
}
