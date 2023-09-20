package mvc.backend_server.repository;

import mvc.backend_server.entity.MyPOI;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface POIRepo extends JpaRepository<MyPOI, Integer> {
    public MyPOI findByPOIId(int POIId);
}
