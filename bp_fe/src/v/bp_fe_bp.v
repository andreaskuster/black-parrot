/*
 *  bp_fe_bp.v
 *  
 *  Branch Predictor Wrapper
 * 
 */
module bp_fe_pb
 import bp_fe_pkg::*; 
   #(parameter bht_idx_width_p     = "inv"
   , localparam els_lp             = 2**bht_idx_width_p
   , localparam saturation_size_lp = 2
   , localparam BP_TYPE = "always_taken"
   )
   ( input                       clk_i
   , input                       reset_i
    
   , input                       w_v_i
   , input [bht_idx_width_p-1:0] idx_w_i
   , input                       correct_i
 
   , input                       r_v_i   
   , input [bht_idx_width_p-1:0] idx_r_i
   , output                      predict_o
   );

generate

if (BP_TYPE == "always_not_taken") begin : branch_predictor_static_always_not_taken

  // predict not taken
  assign predict_o = 1'b0;

end else if (BP_TYPE == "always_taken") begin : branch_predictor_static_always_taken

  // predict always taken
  assign predict_o = 1'b1;

end else begin

  // catch unknown branch predictor
  initial begin
    $display("Error: BP_TYPE %s has not been implemented yet.", BP_TYPE);
    $finish();
  end

end
endgenerate
 
endmodule
