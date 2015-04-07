package by.jylilov.musicshare.dao.impl;

import by.jylilov.musicshare.dao.UserDao;
import by.jylilov.musicshare.model.User;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.orm.hibernate4.HibernateTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private HibernateTemplate hibernateTemplate;

    @Override
    public User get(Integer id) {
        return hibernateTemplate.get(User.class, id);
    }
}
