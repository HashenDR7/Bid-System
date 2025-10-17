package lk.jiat.ee.ejb.remote;

import lk.jiat.ee.core.model.User;

import java.util.List;

public interface AuctionServiceLocal {
    void registerUser(User user);
    List<User> getAllUsers();
}
