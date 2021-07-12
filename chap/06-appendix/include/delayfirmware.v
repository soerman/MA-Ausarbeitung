`timescale 1ns / 1ps

module SDI_Delay_NB6L295(
    // data for respective delay chips
    input [10:0]        In_1, In_2, In_3, In_4, In_5, In_6, In_7, In_8,      
    input               Clk,
    input               Reset,
    output reg          [7:0] EN,                                                                           // enable signal for delay chips, active LOW
    output reg          SDIN,                                                                               // configuration data 
    output reg          SLOAD,                                                                              // signals delay chip to load previously sent data
    output              SCLK                                                                                // clock for serial communication with delay chips
    );
    
    reg                 start_clk;
    assign SCLK = start_clk & (!Clk);
                                                                           
    reg [21:0]          In_1_reg, In_2_reg, In_3_reg, In_4_reg, In_5_reg, In_6_reg, In_7_reg, In_8_reg;     // registers to intermediately store the inputs
    
    reg [7:0]           select;                                                                             // register used by Priority Encoder to detect which input changed
         
    parameter           DATA_SHIFT_WIDTH = 11;                                                              // number of bits to be shifted during transmission, 1 Data word = 11 bits
    reg [4:0]           clk_cnt;
    
    
    reg [DATA_SHIFT_WIDTH-1:0]  Data_reg;                                                                   // register for storing data for state machine
    
    reg                  start;                                                                             // signal for state machine to start sending data 
    reg                  dataSent;                                                                          // flags if transmission for one delay chip is finished

    parameter            dly = 1;                                                                           // delay control
    
    reg                  delayReady;

    
    always @ (posedge Clk)
    begin   
        if (select == 'd0)     delayReady <= #dly 'b1;
        else                   delayReady <= #dly 'b0;   
    end

    // Priority Encoder
    // Check if any input has changed, select which data should be sent accordingly 
    always @ (posedge Clk)
        begin
            if (Reset)
                begin
                    In_1_reg         <= #dly 'd0;
                    In_2_reg         <= #dly 'd0;
                    In_3_reg         <= #dly 'd0;
                    In_4_reg         <= #dly 'd0;
                    In_5_reg         <= #dly 'd0;
                    In_6_reg         <= #dly 'd0;
                    In_7_reg         <= #dly 'd0;
                    In_8_reg         <= #dly 'd0; 
                    Data_reg         <= #dly 'd0;
                                        
                    select           <= #dly 'd0;
                    
                    start            <= #dly 1'b0;;                 
                end
            else
                begin
                     if (~start & delayReady)
                        begin  
                                select[7]    <= #dly In_1_reg != In_1;
                                select[6]    <= #dly In_2_reg != In_2;  
                                select[5]    <= #dly In_3_reg != In_3;
                                select[4]    <= #dly In_4_reg != In_4;
                                select[3]    <= #dly In_5_reg != In_5;
                                select[2]    <= #dly In_6_reg != In_6;
                                select[1]    <= #dly In_7_reg != In_7;
                                select[0]    <= #dly In_8_reg != In_8;
                          end
                      else
                         begin
                            if (clk_cnt == 4'd12 & ~start_clk) // = end of sequence
                                    start                 <= #dly 1'b0;
                                else
                                    start                 <= #dly 1'b1;
                          end                    
                
                        casex (select)
                            8'b1???????: 
                               begin 
                                 if (~dataSent)
                                   begin
                                        In_1_reg            <= #dly In_1;
                                        Data_reg            <= #dly In_1;
                                        EN                  <= #dly 8'b01111111;
                                        start               <= #dly 1'b1;
                                        end
                                   else 
                                     begin
                                        start               <= #dly 1'b0;
                                        select[7]           <= #dly 1'b0;
                                     end
                                end
                            8'b01??????: 
                                begin 
                                 if (~dataSent)
                                   begin
                                        In_2_reg             <= #dly In_2;
                                        Data_reg             <= #dly In_2;
                                        EN                   <= #dly 8'b10111111;
                                        start                <= #dly 1'b1;
                                    end
                                  else 
                                    begin
                                        select[6]            <= #dly 1'b0;
                                        start                <= #dly 1'b0;
                                    end
                                end
                            8'b001?????: 
                                begin 
                                if (~dataSent)
                                   begin
                                       In_3_reg              <= #dly In_3;
                                       Data_reg              <= #dly In_3;
                                       EN                    <= #dly 8'b11011111;
                                       start                 <= #dly 1'b1;                                      
                                   end
                                 else 
                                        begin
                                           select[5]         <= #dly 1'b0;
                                           start             <= #dly 1'b0;
                                         end
                                end
                            8'b0001????: 
                                begin 
                                if (~dataSent)
                                   begin
                                       In_4_reg              <= #dly In_4;
                                       Data_reg              <= #dly In_4;
                                       EN                    <= #dly 8'b11101111;
                                       start                 <= #dly 1'b1;
                                   end
                                   
                                 else 
                                        begin
                                           select[4]         <= #dly 1'b0;
                                           start             <= #dly 1'b0;
                                         end
                                end
                            8'b00001???: 
                                begin 
                                if (~dataSent)
                                    begin
                                       In_5_reg              <= #dly In_5;
                                       Data_reg              <= #dly In_5;
                                       EN                    <= #dly 8'b11110111;
                                       start                 <= #dly 1'b1;
                                    end
                                    
                                 else 
                                        begin
                                           select[3]         <= #dly 1'b0;
                                           start             <= #dly 1'b0;
                                         end
                                end
                            8'b000001??: 
                                begin
                                if (~dataSent)
                                    begin 
                                       In_6_reg              <= #dly In_6;
                                       Data_reg              <= #dly In_6;
                                       EN                    <= #dly 8'b11111011;
                                       start                 <= #dly 1'b1;
                                    end
                                    
                                 else 
                                        begin
                                           select[2]         <= #dly 1'b0;
                                           start             <= #dly 1'b0;
                                         end
                                end
                            8'b0000001?: 
                                begin 
                                 if (~dataSent)
                                    begin
                                       In_7_reg              <= #dly In_7;
                                       Data_reg              <= #dly In_7;
                                       EN                    <= #dly 8'b11111101;
                                       start                 <= #dly 1'b1;
                                    end
                                  else 
                                        begin
                                           select[1]         <= #dly 1'b0;
                                           start             <= #dly 1'b0;
                                         end
                                end
                            8'b00000001: 
                                begin 
                                 if (~dataSent)
                                    begin
                                       In_8_reg              <= #dly In_8;
                                       Data_reg              <= #dly In_8;
                                       EN                    <= #dly 8'b11111110;
                                       start                 <= #dly 1'b1;
                                    end
                                   else 
                                        begin
                                           select[0]         <= #dly 1'b0;
                                           start             <= #dly 1'b0;
                                         end
                                end
                            default: 
                                begin
                                    EN                       <= #dly 8'b11111111;
                                    start                    <= #dly 1'b0;
                                end
                        endcase
                    end 
          end        
         
         
        // State Machine for Sending Configuration Data to Delay Chip NB6L295  
        /* 
            State                   Description
            --------------------------------------------------------------
            RESET                   Resetting all parameters and registers -> if (reset): stay; else: to IDLE
            IDLE                    Waiting for start signal from priority encoder -> if (start): to LOAD_P0; else: stay
            LOAD_P0                 Load first half of Delay_X - which corresponds to data for Delay PD0 on delay chip - into temporary register -> to LOAD_P1
            LOAD_P1                 Load second half of Delay_X - which corresponds to data for Delay PD1 on delay chip - into temporary register -> to SHIFT
            SHIFT                   Shift bits for sending serial bitstream to SDIN, assert SLOAD -> to END
            END                     End transmission, deassert SLOAD, inform priority encoder about end of transmission -> to IDLE
        
        */
        parameter RESET		= 3'd0;
        parameter IDLE      = 3'd1;
        parameter LOAD      = 3'd2;
        parameter SHIFT     = 3'd3;
        parameter END       = 3'd4;    
        reg [2:0] STATE;  
        reg [DATA_SHIFT_WIDTH-1:0]	tmp;
        
        always @ (posedge Clk)
        begin
            if (Reset)
                begin
                    STATE         <= #dly RESET;
                    tmp           <= #dly 'd0;
                    dataSent      <= #dly 1'b0;
                    start_clk     <= #dly 1'b0;
                    SLOAD         <= #dly 1'b0;  
                    clk_cnt       <= #dly 1'b0; 
                end
            else
                begin
                    case (STATE)
                        RESET:
                            begin
                                if (Reset)
                                    STATE    <= #dly RESET;
                                else
                                    STATE    <= #dly IDLE;
                            end // RESET
                        IDLE:
                           begin
                                SDIN         <= #dly 1'b0;
                                clk_cnt      <= #dly 5'd0;
                                dataSent     <= #dly 1'b0;
                                SLOAD        <= #dly 1'b0;
                                
                                if (start & ~dataSent)
                                    STATE    <= #dly LOAD;
                                else
                                    STATE    <= #dly IDLE;
                            end // IDLE
                        LOAD:
                            begin
                                tmp          <= #dly Data_reg;
                                STATE        <= #dly SHIFT;
                            end // LOAD_W1   
                        SHIFT:
                            begin
                                if (clk_cnt < 4'd12) // number of bits to be shifted //
                                    begin
                                        start_clk       <= #dly 1'b1;
                                        clk_cnt         <= #dly clk_cnt +1;                                       
                                        tmp             <= #dly {tmp[DATA_SHIFT_WIDTH-2:0], 1'b0}; 
                                        SDIN            <= #dly tmp[DATA_SHIFT_WIDTH-1];
                                    end    
                                else
                                     begin
                                         SLOAD          <= #dly 1'b1;
                                         clk_cnt		   <= #dly clk_cnt;
                                         start_clk      <= #dly 1'b0;
                                         STATE          <= #dly END;
                                         SDIN           <= #dly 1'b0;
                                     end
                              end // SHIFT                                         
                        END:
                            begin
                                SLOAD            <= #dly 1'b0;
                                start_clk        <= #dly 1'b0;
                                dataSent         <= #dly 1'b1;
                                clk_cnt		     <= #dly clk_cnt;
                                SDIN             <= #dly 1'b0;   
                                STATE            <= #dly IDLE;
                            end // END
                        default:
                            STATE    <= #dly RESET;
                    endcase
                end    
        end     
                   
    
endmodule
