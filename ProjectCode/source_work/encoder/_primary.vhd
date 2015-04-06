library verilog;
use verilog.vl_types.all;
entity encoder is
    port(
        clk             : in     vl_logic;
        d_in            : in     vl_logic_vector(7 downto 0);
        data_enable     : in     vl_logic;
        C0              : in     vl_logic;
        C1              : in     vl_logic;
        q_out           : out    vl_logic_vector(9 downto 0)
    );
end encoder;
