package mvc.backend_server.dto;

import lombok.Data;

@Data
public class TicketDTO {

    private int id;
    private double price;
    private int type;
    private int accountId;
    private int travelServiceId;
}
