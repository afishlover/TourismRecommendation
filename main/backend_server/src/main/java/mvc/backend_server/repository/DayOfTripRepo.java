package mvc.backend_server.repository;

import mvc.backend_server.entity.DayOfTrip;
import org.springframework.data.jpa.repository.JpaRepository;

public interface DayOfTripRepo extends JpaRepository<DayOfTrip, Integer> {
}
