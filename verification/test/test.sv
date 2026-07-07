module test (
    vif_if vif
);
  // =================== DPI FUNCTIONS ==================== //
  //  import "DPI-C" function real ref_model(real initial_value);

  // ================== GLOBAL VARIABLES ================== //

  //  import config_pkg::*;

  // =================== MAIN SEQUENCE ==================== //

  initial begin
    // Initial values
    $display("Begin Of Simulation.");
    //   get_config_args();

    fork
      // Monitor
      monitor_output();
    join_none
    // Apply reset
    reset();


    fork
      // Stimulus

      send_data_port_a();



    join_any
    // Drain time
    #(20ns);
    $display("End Of Simulation at %0t.", $realtime);
    $finish;
  end


  // ======================= TASKS ======================== //

  task automatic reset();

    //for adder 
    vif.a_i     = 16'b0;
    vif.b_i     = 16'b0;
    vif.carry_i = 1'b0;
    vif.rst_i   = 1'b1;
    repeat (5) @(vif.cb);
    vif.rst_i <= 1'b0;
  endtask : reset


  task automatic send_data_port_a();
    //Initial Values
    for (int i = 0; i < 5; i++) begin
      @(vif.cb);
      vif.cb.a_i <= $urandom_range(0, 15);
      vif.cb.b_i <= $urandom_range(0, 15);
      vif.cb.carry_i <= $urandom_range(0, 1);
    end
  endtask : send_data_port_a


  task automatic monitor_output();
    forever begin
      @(vif.cb);
      $display(
          "[INFO:Gate SUmador]: %8t:,Rst = %d, A = %d, B = %d, Carry = %1d, Suma = %d, Carry out = %d",
          $realtime, vif.rst_i, vif.a_i, vif.b_i, vif.carry_i, vif.sum_o, vif.carry_o);


    end
  endtask : monitor_output



endmodule : test
