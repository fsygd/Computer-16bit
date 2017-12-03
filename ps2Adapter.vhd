----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:03:24 12/03/2017 
-- Design Name: 
-- Module Name:    ps2Adapter - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ps2Adapter is
	port(
		ps2_data : in STD_LOGIC; -- data from ps2
		ps2_clk : in STD_LOGIC; -- ps2 clk
		clk : in STD_LOGIC; -- main clk
		rst : in STD_LOGIC;
		dataReceive : in STD_LOGIC;
		dataReady : out STD_LOGIC;
		output : out STD_LOGIC_VECTOR(7 downto 0)
		-- data in ascii
	);
end ps2Adapter;

architecture Behavioral of ps2Adapter is
component ps2Keyboard
	port (
		ps2_data : in STD_LOGIC; -- data from ps2
		ps2_clk : in STD_LOGIC; -- ps2 clk
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		dataReceive : in STD_LOGIC; -- for VGA?
		dataReady : out STD_LOGIC;
		ps2_out : out STD_LOGIC_VECTOR(7 downto 0) -- output in ps2 scan mode
	);
end component;

component ps2ToAscii
	port(
		ps2_data : in STD_LOGIC_VECTOR(7 downto 0);
		ascii_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
end component;

signal ps2_out_signal : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

begin

	myps2Keyboard : ps2Keyboard port map(
		ps2_data => ps2_data,
		ps2_clk => ps2_clk,
		clk => clk,
		rst => rst,
		dataReceive => dataReceive,
		dataReady => dataReady,
		ps2_out => ps2_out_signal
	);
	
	myps2ToAscii : ps2ToAscii port map(
		ps2_data => ps2_out_signal,
		ascii_out => output
	);
end Behavioral;