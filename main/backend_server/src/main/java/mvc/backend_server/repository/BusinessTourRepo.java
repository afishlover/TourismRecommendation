package mvc.backend_server.repository;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import mvc.backend_server.entity.Distance;
import mvc.backend_server.entity.Tour;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public interface BusinessTourRepo extends JpaRepository<Tour, Integer> {


    ArrayList<Tour> getToursByAccount(String Account);
    Tour getTourById(int id);

}
