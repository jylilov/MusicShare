package by.jylilov.musicshare.dao.impl;

import by.jylilov.musicshare.dao.PlaylistDao;
import by.jylilov.musicshare.model.Playlist;
import org.hibernate.Hibernate;
import org.hibernate.hql.internal.ast.util.SessionFactoryHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate4.HibernateTemplate;
import org.springframework.stereotype.Repository;

import java.util.Collection;

@Repository
public class PlaylistDaoImpl implements PlaylistDao{
    @Autowired
    private HibernateTemplate hibernateTemplate;

    @Override
    public Collection<Playlist> getAll() {
        return hibernateTemplate.loadAll(Playlist.class);
    }

    @Override
    public Playlist get(Integer id) {
        return hibernateTemplate.get(Playlist.class, id);
    }
}
