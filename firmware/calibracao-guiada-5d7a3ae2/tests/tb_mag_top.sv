`timescale 1ns/1ps
module tb_mag_top;
 reg clk=0;always #5 clk=~clk;
 reg right_button=0;reg[1:0]buttons=0;
 reg signed [15:0] mx=600,my=-120,mz=300;reg sample=0;
 tri1 sda,scl,bsda,bscl,msda,mscl;
 wire [3:0] r,g,b;wire[6:0]seg;wire[7:0]an;
 top_reticula #(.ENABLE_MAG_GUIDED_CAL(1),.ENABLE_MAG_TILT(1),.MAG_CALIBRATED_3D(1),
    .MAG_OFFSET_X(67),.MAG_OFFSET_Y(-181),.MAG_OFFSET_Z(-226),
    .MAG_GAIN_X_Q12(3923),.MAG_GAIN_Y_Q12(4004),.MAG_GAIN_Z_Q12(4390),
    .MAG_INVERTER_X(1),.MAG_INVERTER_Y(1),.MAG_ALINHAMENTO_GRAUS(81)) dut(
    .cpu_resetn(1'b1),.clk(clk),.operacao_sw(2'b00),.ack_btn(1'b0),.btn_heading(buttons),.sw(7'b1111000),
    .display_mode(1'b0),.style_mode(1'b1),.vauxp3(1'b0),.vauxn3(1'b0),.vauxp10(1'b0),.vauxn10(1'b0),.joystick_sw_n(1'b1),
    .i2c_sda(sda),.i2c_scl(scl),.baro_sda(bsda),.baro_scl(bscl),.mag_sda(msda),.mag_scl(mscl),
    .ALIGN_RIGHT_BUTTON(right_button),.VIDEO_TOGGLE_BUTTON(1'b0),.SD_READ_SWITCH(1'b1),.SD_DIAG_PAGE(4'b1010),
    .SD_DAT0(1'b1),.SD_CD(1'b1),.SD_SEG(seg),.SD_AN(an),.VGA_R(r),.VGA_G(g),.VGA_B(b));
 defparam dut.u_mag_cal_controls.DEBOUNCE=2;
 defparam dut.u_mag_cal_controls.LONG_CYCLES=16;
 defparam dut.u_mag_calibration.STALE_CYCLES=1000;
 defparam dut.u_mag_calibration.PHASE_CYCLES=20000;
 reg[47:0]train[0:71],holdout[0:71];string dir;
 task tick(input integer n);repeat(n)@(negedge clk);endtask
 task send(input[47:0]row);
  begin @(negedge clk);{mx,my,mz}=row;
   force dut.u_magnetometro.mag_x=mx;force dut.u_magnetometro.mag_y=my;force dut.u_magnetometro.mag_z=mz;
   sample=1;force dut.u_magnetometro.amostra_nova=sample;@(negedge clk);sample=0;force dut.u_magnetometro.amostra_nova=sample;tick(38);
  end
 endtask
 task next_command;begin right_button=1;tick(10);right_button=0;tick(10);end endtask
 always @(negedge clk)if(dut.mag_cal_owned)begin
   if(dut.heading_command_buttons!=0 || dut.align_command_buttons!=0 || dut.zero_request)$fatal(1,"Comando vazou da calibracao");
   if(!dut.video_mode || dut.capture_mode)$fatal(1,"Calibracao alterou video/captura");
   if(dut.fusao_pitch_q10!=10240 || dut.fusao_roll_q10!=-5120)$fatal(1,"Calibracao alterou pitch/roll");
 end
 initial begin
  if(!$value$plusargs("DIR=%s",dir))$fatal(1,"DIR");
  $readmemh({dir,"/diagonal-train.hex"},train);$readmemh({dir,"/diagonal-holdout.hex"},holdout);
  force dut.reset_operacao=1;tick(5);force dut.reset_operacao=0;
  force dut.mag_sensor_ok=1;force dut.vector_valid=1;force dut.vector_calibrated=1;
  force dut.compass_gravity_x=0;force dut.compass_gravity_y=0;force dut.compass_gravity_z=1048576;
  force dut.vector_pitch=10240;force dut.vector_roll=-5120;
  force dut.heading_approved_deg=200;force dut.heading_approved_valid=1;force dut.heading_approved_updated=0;
  tick(20);send(train[0]);
  if(dut.heading_magnetico_deg!=200 || !dut.heading_magnetico_valido)$fatal(1,"Boot nao preservou heading 3D");
  right_button=1;tick(40);right_button=0;tick(10);
  if(!dut.mag_cal_owned || dut.mag_cal_state!=1)$fatal(1,"Entrada top");
  next_command();for(integer i=0;i<72;i++)send(train[i]);
  next_command();tick(60);if(dut.mag_cal_state!=4)$fatal(1,"VALIDATE");
  for(integer i=0;i<72;i++)send(holdout[i]);next_command();tick(10);
  if(dut.mag_cal_state!=5 || dut.mag_cal_active)$fatal(1,"Candidato");
  next_command();send(holdout[0]);send(holdout[1]);
  if(!dut.mag_cal_active || !dut.mag_use_planar || !dut.heading_magnetico_valido)$fatal(1,"Aplicacao top");
  force dut.compass_gravity_x=200000;tick(10);
  if(dut.mag_use_planar || dut.heading_magnetico_deg!=200 || !dut.heading_magnetico_valido)$fatal(1,"Inclinado nao voltou ao 3D");
  force dut.compass_gravity_x=0;send(holdout[2]);
  buttons=1;tick(12);buttons=0;tick(12);
  if(dut.mag_cal_active || dut.heading_magnetico_deg!=200)$fatal(1,"Recuperar top");
  force dut.mag_sensor_ok=0;tick(10);
  if(dut.heading_magnetico_valido)$fatal(1,"Heading obsoleto valido no top");
  buttons=2;tick(12);buttons=0;tick(12);if(dut.mag_cal_owned)$fatal(1,"Saida top");
  $display("PASS top: perfil original, controles, coleta, validacao, aplicacao, fallback 3D, recuperacao, invalidade, pitch/roll/video preservados");$finish;
 end
 initial begin #2000000;$fatal(1,"Timeout top");end
endmodule
