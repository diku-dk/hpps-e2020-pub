library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity full_adder_tb is
end full_adder_tb;

architecture tb of full_adder_tb is
    signal a, b, c_in : std_logic;
    signal s, c_out : std_logic;

    signal clk, rst : std_logic;
    signal done_driver : boolean := false;
    signal done_tester : boolean := false;
begin
    inst_full_adder : entity work.full_adder
    port map(
        a => a,
        b => b,
        c_in => c_in,

        s => s,
        c_out => c_out,

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
        c_in <= '0';
        rst <= '1';
        wait for 5 ns;
        rst <= '0';

        wait until rising_edge(clk);
        a <= '0';
        b <= '0';
        c_in <= '0';

        wait until rising_edge(clk);
        a <= '0';
        b <= '0';
        c_in <= '1';

        wait until rising_edge(clk);
        a <= '0';
        b <= '1';
        c_in <= '0';

        wait until rising_edge(clk);
        a <= '0';
        b <= '1';
        c_in <= '1';

        wait until rising_edge(clk);
        a <= '1';
        b <= '0';
        c_in <= '0';

        wait until rising_edge(clk);
        a <= '1';
        b <= '0';
        c_in <= '1';

        wait until rising_edge(clk);
        a <= '1';
        b <= '1';
        c_in <= '0';

        wait until rising_edge(clk);
        a <= '1';
        b <= '1';
        c_in <= '1';

        wait until rising_edge(clk);
        done_driver <= true;
        wait;
    end process;

    tester: process
    begin
        wait for 5 ns;
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        wait until rising_edge(clk);
        assert(s = '0');
        assert(c_out = '0');

        wait until rising_edge(clk);
        assert(s = '1');
        assert(c_out = '0');

        wait until rising_edge(clk);
        assert(s = '1');
        assert(c_out = '0');

        wait until rising_edge(clk);
        assert(s = '0');
        assert(c_out = '1');

        wait until rising_edge(clk);
        assert(s = '1');
        assert(c_out = '0');

        wait until rising_edge(clk);
        assert(s = '0');
        assert(c_out = '1');

        wait until rising_edge(clk);
        assert(s = '0');
        assert(c_out = '1');

        wait until rising_edge(clk);
        assert(s = '1');
        assert(c_out = '1');

        done_tester <= true;
        wait;
    end process;
end architecture tb;
