package mvc.backend_server.service;

import mvc.backend_server.dto.AccountDTO;
import mvc.backend_server.dto.RegisterResponse;
import mvc.backend_server.entity.Account;
import mvc.backend_server.entity.Role;
import mvc.backend_server.repository.AccountRepo;
import mvc.backend_server.repository.RoleRepo;
import mvc.backend_server.service.interfaces.IAccountService;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class AccountService implements IAccountService {

    @Autowired
    private final AccountRepo accountRepo;
    @Autowired
    private final RoleRepo roleRepo;
    @Autowired
    private ModelMapper mapper;

    public AccountService(AccountRepo accountRepo, RoleRepo roleRepo, ModelMapper mapper) {
        this.accountRepo = accountRepo;
        this.roleRepo = roleRepo;
        this.mapper = mapper;
    }



}
