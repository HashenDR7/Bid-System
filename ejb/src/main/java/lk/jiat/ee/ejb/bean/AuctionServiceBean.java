package lk.jiat.ee.ejb.bean;

import jakarta.ejb.Stateless;
import lk.jiat.ee.core.model.User;
import lk.jiat.ee.ejb.remote.AuctionServiceLocal;

import java.util.ArrayList;
import java.util.List;

@Stateless
public class AuctionServiceBean implements AuctionServiceLocal {
    private final List<User> users = new ArrayList<>();

    @Override
    public void registerUser(User user) {
        users.add(user); // store in memory
    }

    @Override
    public List<User> getAllUsers() {
        return users;
    }
}
