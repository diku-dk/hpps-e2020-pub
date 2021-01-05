library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity half_adder is
    port(
        a: in std_logic;
        b: in std_logic;

        s: out std_logic;
        c: out std_logic;

        rst: in std_logic;
        clk: in std_logic
    );
end half_adder;

architecture RTL of half_adder is
begin

    process(clk, rst)
    begin
        if RST = '1' then
            s <= '0';
            c <= '0';
        elsif rising_edge(CLK) then
            s <= a xor b;
            c <= a and b;
        end if;
    end process;

end architecture RTL;
