`include "tests/tb_top_sd_integration.sv"
module tb_top_sd_overlay;
    tb_top_sd_integration #(.TEST_OVERLAY(1), .TEST_OPERATIONAL(1),
        .TEST_LBA(30006080), .TEST_REFERENCE_FILE("tests/hud_aircraft_64.hex")) test();
endmodule
