package mvc.backend_server.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Data
@Entity
@Table(name = "account")
public class Account  {
    String ROLE_PREFIX = "ROLE_";

    @Id
    @Column(name = "account_id", columnDefinition = "VARCHAR(10)")
    private String id;

    @Column(name = "address")
    private String address;

    @Column(name = "date_of_birth")
    private Date DOB;

    @Column(name = "email")
    private String email;

    @Column(name = "full_name")
    private String fullName;

    @Column(name = "gender")
    private String gender;


    private String image;


    @Column(name = "phone_number")
    private String phoneNumber;



    @Column(name = "level")
    private Integer level;

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @Column(name = "level_point")
    private Integer levelPoint;

    @Column(columnDefinition = "TinyInt(1)")
    private Integer status;

    @ManyToOne
    @JoinColumn(name = "role_id", nullable = false)
//    @Enumerated(EnumType.STRING)
    private Role role;

    private String username;



    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }





    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }



}
