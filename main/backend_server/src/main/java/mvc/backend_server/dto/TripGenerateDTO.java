package mvc.backend_server.dto;

import lombok.Data;

@Data
public class TripGenerateDTO {
    private String walletId;
    private String destination;
    private String budget;
    private String startDate;
    private String endDate;
}
