package mvc.backend_server.repository;


import mvc.backend_server.entity.Account;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AccountRepo extends JpaRepository<Account, String> {
    Account findAccountByUsername(String username);
}
