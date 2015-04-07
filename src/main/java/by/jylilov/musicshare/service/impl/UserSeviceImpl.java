package by.jylilov.musicshare.service.impl;

import by.jylilov.musicshare.dao.UserDao;
import by.jylilov.musicshare.model.User;
import by.jylilov.musicshare.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserSeviceImpl implements UserService {

    @Autowired
    private UserDao dao;

    @Override
    public User get(Integer id) {
        return dao.get(id);
    }
}
