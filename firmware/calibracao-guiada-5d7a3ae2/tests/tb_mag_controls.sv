`timescale 1ns/1ps
module tb_mag_controls;
 reg clk=0;always #5 clk=~clk;
 reg reset=1,eligible=0,right_button=0;reg[1:0]buttons=0;
 wire owned,start,next_step,cancel,recover,inhibit;
 integer starts=0,nexts=0,cancels=0,recovers=0;
 mag_calibration_controls #(.DEBOUNCE(2),.LONG_CYCLES(12)) dut(.clk(clk),.reset(reset),.eligible(eligible),.right_button(right_button),.buttons(buttons),.owned(owned),.start(start),.next_step(next_step),.cancel(cancel),.recover(recover),.inhibit_buttons(inhibit));
 always @(negedge clk)begin if(start)starts++;if(next_step)nexts++;if(cancel)cancels++;if(recover)recovers++;end
 task tick(input integer n);repeat(n)@(negedge clk);endtask
 initial begin
  tick(3);reset=0;right_button=1;tick(30);if(owned || starts || inhibit)$fatal(1,"Capturou controle fora da pagina");
  right_button=0;tick(8);eligible=1;tick(8);right_button=1;tick(10);right_button=0;tick(10);if(owned || starts)$fatal(1,"Pressao curta iniciou calibracao");
  right_button=1;tick(30);if(!owned || starts!=1)$fatal(1,"Long press");right_button=0;tick(10);if(nexts)$fatal(1,"Release de long press virou NEXT");
  right_button=1;tick(10);right_button=0;tick(10);if(nexts!=1)$fatal(1,"NEXT curto");
  buttons=1;tick(10);if(recovers!=1 || !owned)$fatal(1,"Recuperacao");buttons=0;tick(10);
  buttons=2;tick(10);if(owned || cancels!=1 || !inhibit)$fatal(1,"Cancelamento/guarda");
  buttons=0;tick(10);if(inhibit)$fatal(1,"Guarda nao liberou");
  right_button=1;tick(30);right_button=0;tick(10);eligible=0;tick(10);if(owned || cancels!=2)$fatal(1,"Saida pagina nao cancelou");
  $display("PASS controles: pagina exclusiva, debounce, long/short, cancelar, recuperar e guarda de soltura");$finish;
 end
endmodule
