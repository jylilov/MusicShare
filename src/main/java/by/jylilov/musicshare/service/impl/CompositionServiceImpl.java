package by.jylilov.musicshare.service.impl;


import by.jylilov.musicshare.dao.CompositionDao;
import by.jylilov.musicshare.model.Composition;
import by.jylilov.musicshare.service.CompositionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Collection;

@Transactional
@Service
public class CompositionServiceImpl implements CompositionService {

    @Autowired
    CompositionDao dao;

    @Override
    public Composition get(Integer id) {
        return dao.get(id);
    }

    @Override
    public Collection<Composition> getAll() {
        return dao.getAll();
    }
}
