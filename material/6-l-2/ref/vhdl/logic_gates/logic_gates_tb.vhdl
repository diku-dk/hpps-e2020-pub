library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity logic_gates_tb is
end logic_gates_tb;

architecture tb of logic_gates_tb is
    signal a, b : std_logic;
    signal c_and, c_or, c_not, c_xor : std_logic;

    signal clk, rst : std_logic;
    signal done_driver : boolean := false;
    signal done_tester : boolean := false;
begin
    inst_logic_gates : entity work.logic_gates
    port map(
        a => a,
        b => b,
        c_and => c_and,
        c_or => c_or,
        c_not => c_not,
        c_xor => c_xor,
        clk => clk,
        rst => rst
    );

    clk_proc: process
    begin
        while not (done_driver and done_tester) loop
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    driver: process
    begin
        a <= '0';
        b <= '0';
        rst <= '1';
        wait for 5 ns;
        rst <= '0';

        wait until rising_edge(clk);
        a <= '0';
        b <= '0';

        wait until rising_edge(clk);
        a <= '0';
        b <= '1';

        wait until rising_edge(clk);
        a <= '1';
        b <= '0';

        wait until rising_edge(clk);
        a <= '1';
        b <= '1';

        done_driver <= true;
        wait;
    end process;

    tester: process
    begin
        wait for 5 ns;
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        wait until falling_edge(clk);
        assert(c_and = '0');
        assert(c_or = '0');
        assert(c_not = '1');
        assert(c_xor = '0');

        wait until falling_edge(clk);
        assert(c_and = '0');
        assert(c_or = '1');
        assert(c_not = '1');
        assert(c_xor = '1');

        wait until falling_edge(clk);
        assert(c_and = '0');
        assert(c_or = '1');
        assert(c_not = '0');
        assert(c_xor = '1');

        wait until falling_edge(clk);
        assert(c_and = '1');
        assert(c_or = '1');
        assert(c_not = '0');
        assert(c_xor = '0');

        done_tester <= true;
        wait;
    end process;
end architecture tb;
