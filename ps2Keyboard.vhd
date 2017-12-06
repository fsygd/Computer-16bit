----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:18:07 12/03/2017 
-- Design Name: 
-- Module Name:    ps2Keyboard - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2Keyboard is
	port (
		ps2_data : in STD_LOGIC; -- data from ps2
		ps2_clk : in STD_LOGIC; -- ps2 clk
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dataReceive : in STD_LOGIC; -- if the data is fetched
		dataReady : out STD_LOGIC;
		ps2_out : out STD_LOGIC_VECTOR(7 downto 0) -- output in ps2 scan mode
	);

end ps2Keyboard;

architecture Behavioral of ps2Keyboard is

type state_type is (state_wait, state_start, state_data0, state_data1, state_data2, state_data3, state_data4, state_data5, state_data6,
							state_data7, state_parity, state_stop, state_finish);
signal data, clock, clk1, clk2, odd, isReady : STD_LOGIC;
signal code : std_logic_vector (7 downto 0);
signal outputcode : std_logic_vector (7 downto 0);
signal st : std_logic_vector (3 downto 0) := "0000";
signal state : state_type;
begin
	clk1 <= ps2_clk when rising_edge(clk);
	clk2 <= clk1 when rising_edge(clk);
	clock <= (not clk1) and clk2;
	data <= ps2_data when rising_edge(clk);
	odd <= code(0) xor code(1) xor code(2) xor code(3) xor code(4) xor code(5) xor code(6) xor code(7);
	outputcode <= code when isReady = '1';
	
	process(rst, clk, dataReceive)
	begin
		if rst = '0' then
			state <= state_wait;
			code <= (others => '0');
			isReady <= '1';
			code <= "00000000";
			isReady <= '0';
			dataReady <= '0';
		elsif rising_edge(clk) then
			isReady <= '0';
			case state is
				when state_wait =>
					state <= state_start;

				when state_start =>
					if clock = '1' then
						if data = '0' then
							state <= state_data0;
						else
							state <= state_wait;
						end if;
					else
						--none
					end if;

				when state_data0 =>
					if clock = '1' then
						code(0) <= data;
						state <= state_data1;
					else
						--none
					end if;
				
				when state_data1 =>
					if clock = '1' then
						code(1) <= data;
						state <= state_data2;
					else
						--none
					end if;
					
				when state_data2 =>
					if clock = '1' then
						code(2) <= data;
						state <= state_data3;
					else
						--none
					end if;

				when state_data3 =>
					if clock = '1' then
						code(3) <= data;
						state <= state_data4;
					else
						--none
					end if;

				when state_data4 =>
					if clock = '1' then
						code(4) <= data;
						state <= state_data5;
					else
						--none
					end if;

				when state_data5 =>
					if clock = '1' then
						code(5) <= data;
						state <= state_data6;
					else
						--none
					end if;

				when state_data6 =>
					if clock = '1' then
						code(6) <= data;
						state <= state_data7;
					else
						--none
					end if;

				when state_data7 =>
					if clock = '1' then
						code(7) <= data;
						state <= state_parity;
					else
						--none;
					end if;

				when state_parity =>
					if clock = '1' then
						if (data xor odd) = '1' then
							state <= state_stop;
						else
							state <= state_wait;
						end if;
					else
						--none
					end if;
					
				when state_stop =>
					if clock = '1' then
						if data = '1' then
							state <= state_finish;
						else
							state <= state_wait;
						end if;
					else
						--none
					end if;

				when state_finish =>
					state <= state_wait;
					isReady <= '1';
				
				when others =>
					state <= state_wait;
			end case;
			
			if outputcode = x"F0" then
				st <= "0001";
			else
				case st is
					when "0001" =>
						dataReady <= '1';
						ps2_out <= outputcode;
						st <= "0000";
					when others =>
						st <= "0000";
				end case;
			end if;
			if dataReceive = '1' then
				dataReady <= '0';
			end if;
		end if;
	end process;

end Behavioral;

