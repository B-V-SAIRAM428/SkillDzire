
module Indian_coin_counter#(parameter Max_amount_cn_inst = 2048)(
    input clk,
    input rst,
    input i_rupee_1,i_rupee_2,i_rupee_5,i_rupee_10, // input from comparator
    input enable,                                   // tells to count or not
    output amt_full,                                // indicates that bag was full
    output [$clog2(Max_amount_cn_inst)-1:0] balance_amount_cn_inst,
    output reg [$clog2(Max_amount_cn_inst)-1:0] inserted_amount      // inserted_amount in the machine
    );
    localparam idle = 3'd0,s1 = 3'd1, s2=3'd2,s5=3'd3,s10=3'd4;     // states 1rs, 2rs, 5rs, 10rs
    reg r_rupee_1,r_rupee_2,r_rupee_5,r_rupee_10;                   // register to save the pervious input values
    wire pulse_1,pulse_2,pulse_5,pulse_10;                           // Pulse signals of inputs
    reg [2:0] state;                                                
    
    // Pulse generation 
    
    assign pulse_1 = i_rupee_1 & ~r_rupee_1;
    assign pulse_2 = i_rupee_2 & ~r_rupee_2;
    assign pulse_5 = i_rupee_5 & ~r_rupee_5;
    assign pulse_10 = i_rupee_10 & ~r_rupee_10;
    
    // Sending input to register for edgedetection
    
    always@(posedge clk) begin
        if(rst) begin
            r_rupee_1 <= 0;
            r_rupee_2 <= 0;
            r_rupee_5 <= 0;
            r_rupee_10 <= 0;
        end else begin
            r_rupee_1 <= i_rupee_1;
            r_rupee_2 <= i_rupee_2;
            r_rupee_5 <= i_rupee_5;
            r_rupee_10 <= i_rupee_10;
        end
    end
    
    // FSM for sorting the coins 
    
    always@(posedge clk) begin
        if(rst) begin
            state <= idle;
            inserted_amount <= 0;
        end else begin
            if(enable && !amt_full) begin
                
                case(state)
                
                    idle: begin                         /// Idle state
                        if(pulse_1) state <= s1;
                        else if(pulse_2) state <= s2;
                        else if(pulse_5) state <= s5;
                        else if(pulse_10) state <= s10;
                        else state <= idle;
                    end
                    
                    s1: begin                          /// 1rupee state 
                        inserted_amount <= inserted_amount + 1;
                        state <= idle;
                    end
                    
                    s2: begin                           /// 2 rupee state
                        inserted_amount <= inserted_amount + 2;
                        state <= idle;
                    end
                    
                    s5: begin                           //// 5 rupee state
                        inserted_amount <= inserted_amount + 5;
                        state <= idle;
                    end
                    
                    s10: begin                       // 10 rupee state
                        inserted_amount <= inserted_amount + 10;
                        state <= idle;
                    end
                    
                    default: begin
                        inserted_amount <= 0;
                        state <= idle;
                    end
                endcase
            end
        end
    end
    
    // Balance amount you can insert 
    
    assign balance_amount_cn_inst = Max_amount_cn_inst - inserted_amount;
    
    //// Box full or not 
    
    assign amt_full = (inserted_amount == Max_amount_cn_inst);
    
endmodule
