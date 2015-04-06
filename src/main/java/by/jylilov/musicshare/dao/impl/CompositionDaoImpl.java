package by.jylilov.musicshare.dao.impl;

import by.jylilov.musicshare.dao.CompositionDao;
import by.jylilov.musicshare.model.Composition;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate4.HibernateTemplate;
import org.springframework.stereotype.Repository;

import java.util.Collection;

@Repository
public class CompositionDaoImpl implements CompositionDao {

    @Autowired
    private HibernateTemplate hibernateTemplate;

    @Override
    public Composition get(Integer id) {
        return hibernateTemplate.get(Composition.class, id);
    }

    @Override
    public Collection<Composition> getAll() {
        return hibernateTemplate.loadAll(Composition.class);
    }
}
