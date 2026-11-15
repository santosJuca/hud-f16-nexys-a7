`timescale 1ns/1ps
// Teste dirigido do caminho matematico que foi dividido para fechar timing.
module tb_mag_score;
 reg clk=0;always #5 clk=~clk;
 reg reset=1;
 wire[3:0]state,reason;wire healthy,active,changed,suspect,cs;
 wire signed[15:0]ox,oy,cx,cy,cox,coy,minx,maxx,miny,maxy,minz,maxz;
 wire[13:0]gx,gy,cgx,cgy;wire[15:0]samples,dup,invalids;wire[7:0]coverage;
 mag_calibration_2d dut(.clk(clk),.reset(reset),.start(1'b0),.next_step(1'b0),.cancel(1'b0),.recover(1'b0),
 .sensor_ok(1'b1),.sample(1'b0),.level(1'b1),.mx(16'sd0),.my(16'sd0),.mz(16'sd0),.state(state),.reason(reason),
 .active(active),.profile_changed(changed),.offset_x(ox),.offset_y(oy),.gain_x(gx),.gain_y(gy),.healthy(healthy),.suspect(suspect),
 .samples(samples),.duplicates(dup),.invalid_samples(invalids),.coverage(coverage),.min_x(minx),.max_x(maxx),.min_y(miny),.max_y(maxy),.min_z(minz),.max_z(maxz),
 .candidate_x(cox),.candidate_y(coy),.candidate_gx(cgx),.candidate_gy(cgy),.corrected_sample(cs),.corrected_x(cx),.corrected_y(cy));
 reg[99:0]vectors[0:127];reg[24:0]a,b,c,d;
 reg[49:0]new_ref,old_ref;
 string file_name;
 initial begin
 if(!$value$plusargs("FILE=%s",file_name))$fatal(1,"FILE");$readmemh(file_name,vectors);
 for(integer i=0;i<128;i++)begin
  reset=1;repeat(2)@(negedge clk);reset=0;{a,b,c,d}=vectors[i];
  force dut.state=4'd3;force dut.candidate_max=a;force dut.base_min=b;force dut.base_max=c;force dut.candidate_min=d;
  dut.eval_step=2;
  repeat(6)@(negedge clk);
  new_ref=50'(a)*50'(b);old_ref=50'(c)*50'(d);
  if(dut.score_new!==new_ref || dut.score_old!==old_ref ||
     dut.weighted_new!==55'(new_ref)*55'd20 || dut.weighted_old!==55'(old_ref)*55'd19 ||
     dut.not_improved!==(55'(new_ref)*55'd20>55'(old_ref)*55'd19))$fatal(1,"Produto/criterio divergiu i=%0d",i);
  release dut.state;release dut.candidate_max;release dut.base_min;release dut.base_max;release dut.candidate_min;
 end
 $display("PASS score:128 vetores, limites25bit, produtos50bit, pesos55bit e comparacao exata");$finish;
 end
endmodule
