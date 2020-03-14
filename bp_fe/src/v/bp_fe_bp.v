/*
 *  bp_fe_bp.v
 *  
 *  Branch Predictor Wrapper
 * 
 */
module bp_fe_bp
 import bp_fe_pkg::*; 
   #(parameter  bht_idx_width_p    = "inv"
   , parameter  bp_cnt_sat_bits_p  = 2
   , parameter  bp_n_hist          = 6
   , localparam els_lp             = 2**bht_idx_width_p
   , localparam BP_TYPE            = "tournament"
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

end else if (BP_TYPE == "bimodal") begin: branch_predictor_dynamic_bimodal

bp_fe_bp_bimodal
    #(.bht_idx_width_p(bht_idx_width_p),
      .bp_cnt_sat_bits_p(bp_cnt_sat_bits_p)
    ) bp
    ( .clk_i(clk_i)
    , .reset_i(reset_i)

    , .w_v_i(w_v_i)
    , .idx_w_i(idx_w_i)
    , .correct_i(correct_i)

    , .r_v_i(r_v_i)
    , .idx_r_i(idx_r_i)
    , .predict_o(predict_o)
);

end else if (BP_TYPE == "gshare") begin: branch_predictor_dynamic_gshare

bp_fe_bp_gshare
    #(.bht_idx_width_p(bht_idx_width_p),
      .bp_cnt_sat_bits_p(bp_cnt_sat_bits_p)
    ) bp
    ( .clk_i(clk_i)
    , .reset_i(reset_i)

    , .w_v_i(w_v_i)
    , .idx_w_i(idx_w_i)
    , .correct_i(correct_i)

    , .r_v_i(r_v_i)
    , .idx_r_i(idx_r_i)
    , .predict_o(predict_o)
);


end else if (BP_TYPE == "gselect") begin: branch_predictor_dynamic_gselect

bp_fe_bp_gselect
    #(.bht_idx_width_p(bht_idx_width_p),
      .bp_cnt_sat_bits_p(bp_cnt_sat_bits_p),
      .bp_n_hist(bp_n_hist)
    ) bp
    ( .clk_i(clk_i)
    , .reset_i(reset_i)

    , .w_v_i(w_v_i)
    , .idx_w_i(idx_w_i)
    , .correct_i(correct_i)

    , .r_v_i(r_v_i)
    , .idx_r_i(idx_r_i)
    , .predict_o(predict_o)
);

end else if (BP_TYPE == "tournament") begin: branch_predictor_dynamic_tournament

bp_fe_bp_tournament
    #(.bht_idx_width_p(bht_idx_width_p),
      .bp_cnt_sat_bits_p(bp_cnt_sat_bits_p)
    ) bp
    ( .clk_i(clk_i)
    , .reset_i(reset_i)

    , .w_v_i(w_v_i)
    , .idx_w_i(idx_w_i)
    , .correct_i(correct_i)

    , .r_v_i(r_v_i)
    , .idx_r_i(idx_r_i)
    , .predict_o(predict_o)
);

end else begin

  // catch unknown branch predictor
  initial begin
    $display("Error: BP_TYPE %s has not been implemented yet.", BP_TYPE);
    $finish();
  end

end
endgenerate
 
endmodule
