package mvc.backend_server.repository;

import mvc.backend_server.entity.POIOfDay;
import org.springframework.data.jpa.repository.JpaRepository;

public interface POIOfDayRepo extends JpaRepository<POIOfDay, Integer> {

    public POIOfDay findPOIOfDayById(int id);
}
