library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity ripple_carry_adder_tb is
end ripple_carry_adder_tb;

architecture tb of ripple_carry_adder_tb is
    signal a, b, carry : std_logic_vector(3 downto 0);
    signal s : std_logic_vector(3 downto 0);

    signal clk, rst : std_logic;
    signal done_driver : boolean := false;
    signal done_tester : boolean := false;
begin
    adder0 : entity work.half_adder
    port map(
        a => a(0),
        b => b(0),

        s => s(0),
        c => carry(0),

        clk => clk,
        rst => rst
    );

    adder1 : entity work.full_adder
    port map(
        a => a(1),
        b => b(1),
        c_in => carry(0),

        s => s(1),
        c_out => carry(1),

        clk => clk,
        rst => rst
    );

    adder2 : entity work.full_adder
    port map(
        a => a(2),
        b => b(2),
        c_in => carry(1),

        s => s(2),
        c_out => carry(2),

        clk => clk,
        rst => rst
    );

    adder3 : entity work.full_adder
    port map(
        a => a(3),
        b => b(3),
        c_in => carry(2),

        s => s(3),
        c_out => carry(3),

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
        a <= (others => '0');
        b <= (others => '0');
        rst <= '1';
        wait for 5 ns;
        rst <= '0';
        wait until rising_edge(clk);

        for i in 0 to 15 loop
            for j in 0 to 15 loop
                a <= std_logic_vector(to_unsigned(i, 4));
                b <= std_logic_vector(to_unsigned(j, 4));
                wait until rising_edge(clk);
                for k in 0 to 3 loop
                    wait until rising_edge(clk);
                end loop;
            end loop;
        end loop;

        done_driver <= true;
        wait;
    end process;

    tester: process
        variable tmp : unsigned(4 downto 0);
    begin
        wait for 5 ns;
        wait until rising_edge(clk);

        for i in 0 to 15 loop
            for j in 0 to 15 loop
                wait until rising_edge(clk);
                for k in 0 to 3 loop
                    wait until rising_edge(clk);
                end loop;
                tmp := to_unsigned(i, 5) + to_unsigned(j, 5);
                assert(unsigned(s) = tmp(3 downto 0));
                assert(carry(3) = tmp(4));
            end loop;
        end loop;

        done_tester <= true;
        wait;
    end process;
end architecture tb;
