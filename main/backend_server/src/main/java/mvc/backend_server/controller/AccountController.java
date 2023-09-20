package mvc.backend_server.controller;


import mvc.backend_server.dto.AccountDTO;
import mvc.backend_server.entity.Account;
import mvc.backend_server.service.interfaces.IAccountService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/account")
public class AccountController {
    @Autowired
    private IAccountService accountService;

    @PostMapping(value = "/admin/editAccount")
    public String editUserByAdmin(){
        return "Admin edited.";
    }
}
