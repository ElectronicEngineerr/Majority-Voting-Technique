library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Majority_Voting is
    generic (
        c_clock_freq : integer := 100_000_000;
        c_baud_rate       : integer := 115_200
    );
    port (
        clk                        : in  std_logic;
        majority_voting_input_data : in  std_logic;
        majority_voting_data_out   : out std_logic
    );
end Majority_Voting;

architecture Behavioral of Majority_Voting is

	constant c_timer_limit	  : integer := c_clock_freq / (c_baud_rate*16);

    signal bit_timer    	      : integer range 0 to c_timer_limit := 0;
    signal bit_counter   		  : integer range 0 to 15          	 := 0;
    signal data_register 		  : std_logic_vector(15 downto 0) 	 := (others => '0');
    signal majority_voting_result : std_logic 						 := '0'; 
	signal ones_counter  : integer range 0 to 15 := 0;
	signal zeros_counter : integer range 0 to 15 := 0;


begin

    process(clk)
        variable v_ones_counter  : integer := 0;
        variable v_zeros_counter : integer := 0;
        variable v_majority_out  : std_logic := '0';  -- Geçici çıkış değişkeni
    begin
        if rising_edge(clk) then
            if bit_timer = c_timer_limit then
                bit_timer <= 0;  -- Sayaç sıfırlanmalı

							
							if bit_counter = 15 then
									-- Majority Voting işlemi
									v_ones_counter  := 0;
									v_zeros_counter := 0;

									for i in 0 to 15 loop
										if data_register(i) = '1' then
											v_ones_counter  := v_ones_counter + 1;
										else
											v_zeros_counter := v_zeros_counter + 1;
										end if;
									end loop;
									ones_counter <= v_ones_counter;
									zeros_counter <= v_zeros_counter;
									-- Majority rule: Eğer 1'ler daha fazla ise çıkış 1, yoksa 0
									if v_ones_counter > 8 then
										v_majority_out := '1';
									else
										v_majority_out := '0';
									end if;

									-- Çıkışı güncelleme (gecikmeyi önlemek için)
									majority_voting_result <= v_majority_out;

									-- Sayaç ve register sıfırlama
									bit_counter   <= 0;
									data_register <= (others => '0');

							else
									-- Gelen biti kaydır
									data_register <= data_register(14 downto 0) & majority_voting_input_data;
									bit_counter <= bit_counter + 1;
							end if;
								
                
            else
                bit_timer <= bit_timer + 1;
            end if;
			
        end if;
    end process;

    majority_voting_data_out <= majority_voting_result; -- Çıkışa atanmış sinyal

end Behavioral;
