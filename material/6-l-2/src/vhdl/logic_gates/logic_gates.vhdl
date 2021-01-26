library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity logic_gates is
    port(
        a: in std_logic;
        b: in std_logic;

        c_and: out std_logic;
        c_or:  out std_logic;
        c_xor: out std_logic;
        c_not: out std_logic;

        rst: in std_logic;
        clk: in std_logic
    );
end logic_gates;

architecture RTL of logic_gates is
begin

    -- TODO implement hardware

end architecture RTL;
