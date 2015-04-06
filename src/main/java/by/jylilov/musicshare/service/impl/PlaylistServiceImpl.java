package by.jylilov.musicshare.service.impl;

import by.jylilov.musicshare.dao.PlaylistDao;
import by.jylilov.musicshare.model.Playlist;
import by.jylilov.musicshare.service.PlaylistService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;

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
}
