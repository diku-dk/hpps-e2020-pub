library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity full_adder is
    port(
        a: in std_logic;
        b: in std_logic;
        c_in: in std_logic;

        s: out std_logic;
        c_out: out std_logic;

        rst: in std_logic;
        clk: in std_logic
    );
end full_adder;

architecture RTL of full_adder is
begin

    process(clk, rst)
    begin
        if RST = '1' then
            s <= '0';
            c_out <= '0';
        elsif rising_edge(CLK) then
            s <= (a xor b) xor c_in;
            c_out <= (a and b) or (c_in and (a xor b));
        end if;
    end process;

end architecture RTL;
