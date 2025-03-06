
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_Majority_Voting is

				generic (
						c_clock_freq   : integer := 100_000_000;
						c_baud_rate    : integer := 115_200
				);
	
end tb_Majority_Voting;

architecture Behavioral of tb_Majority_Voting is


component Majority_Voting is
    generic(
        c_clock_freq : integer := 100_000_000;
        c_baud_rate       : integer := 115_200
    );
    port(
        clk                        : in  std_logic;
        majority_voting_input_data : in  std_logic;
        majority_voting_data_out   : out std_logic
    );
end component;

signal clk                        : std_logic := '0';
signal majority_voting_input_data : std_logic := '0';
signal majority_voting_data_out   : std_logic := '0'; 
signal clock_period : time := 10 ns; 

constant c_hex_test : std_logic_vector(15 downto 0) := "1101110111011111";
 
 
begin

DUT : Majority_Voting
	generic map(
					c_clock_freq => c_clock_freq,
					c_baud_rate  => c_baud_rate
	)
	port 	map(
					clk 					   => clk,
					majority_voting_input_data => majority_voting_input_data,
					majority_voting_data_out   => majority_voting_data_out
	);	

CLOCK_GENERATOR : process
	begin
			clk <= '1';
			wait for clock_period/2;
			clk <= '0';
			wait for clock_period/2;
end process CLOCK_GENERATOR;

P_MAIN : process
	begin
	
				wait for clock_period*10;
				
				-- process 
				for i in 0 to 15 loop
				
					majority_voting_input_data <= c_hex_test(i);
					wait for 0.54 us;
						
				end loop;
				
					wait for clock_period*10;
					
				assert false
				report "SIM DONE!"
				severity failure;
						
end process P_MAIN;


end Behavioral;