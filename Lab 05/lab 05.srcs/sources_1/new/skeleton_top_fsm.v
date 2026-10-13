`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
<<<<<<< HEAD
// Company:
// Engineer: Muddassir Ali
// Module Name: top_fsm_system
// Project Name: Counter
// Target Devices: Baasys 3
//
//////////////////////////////////////////////////////////////////////////////////
=======
// Company: 
// Engineer: Muddassir Ali

// Module Name: top_fsm_system
// Project Name: Counter
// Target Devices: Baasys 3
// 
//////////////////////////////////////////////////////////////////////////////////

>>>>>>> 1e97a160fc7357c9145019023b56532714c9a859
module top_fsm_system (
    input wire clk,
    input wire pbin,
    input wire [15:0] physical_sw,
    output wire [15:0] physical_leds
);

    // DEBOUNCER (Cleans up the physical reset button signal)
    wire rst_clean;
<<<<<<< HEAD
    wire [31:0] switch_data; // hold the value read from the switches
    reg [31:0] led_write_data; // counter value here
    wire slow_clk;

    debouncer rst_db (
        .clk(clk),
        .pbin(pbin),
        .pbout(rst_clean) //generated a clean signal
    );

    // Uses the provided 'leds' module to read the physical switches
    leds switch_reader (
        .clk(clk), .rst(rst_clean),
        .btns(16'd0), // Required by the provided module
        .writeData(32'd0), 
        .writeEnable(1'b0), 
        .readEnable(1'b1), 
        .memAddress(30'd0),
        .switches(physical_sw), 
        .readData(switch_data) 
    );

    // Uses the provided 'switches' module to write to the physical LEDs
    switches led_writer (
        .clk(clk), .rst(rst_clean),
        .writeData(led_write_data),
        .writeEnable(1'b1), 
        .readEnable(1'b0), .memAddress(30'd0),
        .readData(), 
        .leds(physical_leds)
    );

    clock_divider ticker (
        .clk_in(clk), // Feed it the 100MHz fast clock
        .rst(rst_clean), // Feed it the clean reset signal
        .clk_out(slow_clk) // It spits out the 1Hz slow clock!
    );

    // FSM States matching Task 1 requirements
    localparam WAIT_INPUT = 2'b00;
    localparam COUNTDOWN  = 2'b01;
    localparam DONE       = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;
    reg [15:0] counter;

    // Combinational block: State transitions
    always @(*) begin
        case (state)
            WAIT_INPUT: begin
                // Transition condition: switch input is provided
                if (switch_data[15:0] != 16'd0)
                    next_state = COUNTDOWN;
                else
                    next_state = WAIT_INPUT;
            end
            
            COUNTDOWN: begin
                // Transition condition: counter reaches zero
                if (counter == 16'd0)
                    next_state = DONE;
                else
                    next_state = COUNTDOWN;
            end
            
            DONE: begin
                // Transition condition: wait for switches to be turned off to restart
                if (switch_data[15:0] == 16'd0)
                    next_state = WAIT_INPUT;
                else
                    next_state = DONE;
            end
            
            default: begin
                next_state = WAIT_INPUT;
            end
        endcase
    end

    // Sequential block: State Memory and Counter Logic
    always @(posedge slow_clk) begin
        if (rst_clean) begin
            counter <= 16'd0;
            state <= WAIT_INPUT;
        end
        else begin
            state <= next_state;
            
            case (state)
                WAIT_INPUT: begin
                    // Load the counter with the switch input value
                    counter <= switch_data[15:0];
                end
                
                COUNTDOWN: begin
                    // Decrement the counter on each clock cycle while enabled
                    if (counter > 16'd0)
                        counter <= counter - 16'd1;
                end
                
                DONE: begin
                    // Stop counting when the counter reaches zero
                    counter <= 16'd0;
                end
                
                default: begin
                    counter <= 16'd0;
                end
            endcase
        end
    end

    // Output logic: LEDs driven by counter value in each state
    always @(*) begin
        led_write_data = {16'd0, counter};
    end

endmodule
=======
  	wire [31:0] switch_data; // hold the value read from the switches
  	reg [31:0] led_write_data = 32'd0; // counter value here
  	wire slow_clk;
  
    debouncer rst_db (
      			.clk(clk),
        		.pbin(pbin), 
      				.pbout(rst_clean)	//generated a clean signal
    ); 

    
    
    leds switch_reader (
      			.clk(clk), .rst(rst_clean),
                    .btns(16'd0),			// Not used for this FSM
                    .writeData(32'd0),			// We don't write to switches
                    .writeEnable(1'b0),			// Disabled
                    .readEnable(1'b1),			// Always ON so we can monitor switches
                    .memAddress(30'd0),       
                    .switches(physical_sw),		// Plug in the physical switches
                    .readData(switch_data)		// output data 
    );
    
    switches led_writer (
                    .clk(clk), .rst(rst_clean),
                    .writeData(led_write_data),
                    .writeEnable(1'b1),         	// Always ON so LEDs update instantly
                    .readEnable(1'b0), .memAddress(30'd0),
                    .readData(),                	// Ignored
                    .leds(physical_leds)      
    );
    
    clock_divider ticker (
                    .clk_in(clk),          		// Feed it the 100MHz fast clock
                    .rst(rst_clean),       		// Feed it the clean reset signal
                    .clk_out(slow_clk)     		// It spits out the 1Hz slow clock!
    );

    // YOUR FSM AND COUNTER LOGIC
	// YOUR CODE HERE
    localparam IDLE  = 2'b00;
    localparam INPUT  = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;
    
    reg [1:0] state;
    reg [1:0] next_state;
    reg [15:0] counter;
    
     always @(*) begin
        case (state)
    
            IDLE: begin
                if (switch_data != 16'd0)
                    next_state = INPUT;
                else
                    next_state = IDLE;
            end
    
            INPUT: begin
                next_state = COUNT;
            end
    
            COUNT: begin
                if (counter == 16'd0)
                    next_state = DONE;
                else
                    next_state = COUNT;
            end
    
            DONE: begin
                if (switch_data != 16'd0)
                    next_state = INPUT;
                else
                    next_state = DONE;
            end
    
            default: begin
                next_state = IDLE;
            end
    
        endcase
    end
    
    
    always @(posedge slow_clk) begin
    if (rst_clean) begin
        counter <= 16'd0;
    end
    else begin
        case (state)

            IDLE: begin
                counter <= 16'd0;
            end

            INPUT: begin
                counter <= switch_data[15:0];
            end

            COUNT: begin
                if (counter > 16'd0)
                    counter <= counter - 16'd1;
                else
                    counter <= 16'd0;
            end

            DONE: begin
                counter <= 16'd0;
            end

            default: begin
                counter <= 16'd0;
            end

        endcase
    end
end


    always @(*) begin
    led_write_data = {16'd0, counter};
end
	
	
    endmodule
>>>>>>> 1e97a160fc7357c9145019023b56532714c9a859
