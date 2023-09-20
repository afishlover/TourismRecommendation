package mvc.backend_server.repository;

import mvc.backend_server.entity.Distance;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DistanceRepo extends JpaRepository<Distance,Integer> {
}
