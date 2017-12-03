----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:07:38 12/03/2017 
-- Design Name: 
-- Module Name:    ps2ToAscii - Behavioral 
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

entity ps2ToAscii is
	port(
		ps2_data : in STD_LOGIC_VECTOR(7 downto 0);
		ascii_out : out STD_LOGIC_VECTOR(7 downto 0)
	);
end ps2ToAscii;

architecture Behavioral of ps2ToAscii is

begin
	-- combinal logic to convert ps2 code to ascii code

	ascii_out <=
		x"41" when ps2_data = x"1C" else  -- A
		x"42" when ps2_data = x"32" else  -- B
		x"43" when ps2_data = x"21" else  -- C
		x"44" when ps2_data = x"23" else  -- D
		x"45" when ps2_data = x"24" else  -- E
		x"46" when ps2_data = x"2B" else  -- F
		x"47" when ps2_data = x"34" else  -- G
		x"48" when ps2_data = x"33" else  -- H
		x"49" when ps2_data = x"43" else  -- I
		x"4A" when ps2_data = x"3B" else  -- J
		x"4B" when ps2_data = x"42" else  -- K
		x"4C" when ps2_data = x"4B" else  -- L
		x"4D" when ps2_data = x"3A" else  -- M
		x"4E" when ps2_data = x"31" else  -- N
		x"4F" when ps2_data = x"44" else  -- O
		x"50" when ps2_data = x"4D" else  -- P
		x"51" when ps2_data = x"15" else  -- Q
		x"52" when ps2_data = x"2D" else  -- R
		x"53" when ps2_data = x"1B" else  -- S
		x"54" when ps2_data = x"2C" else  -- T
		x"55" when ps2_data = x"3C" else  -- U
		x"56" when ps2_data = x"2A" else  -- V
		x"57" when ps2_data = x"1D" else  -- W
		x"58" when ps2_data = x"22" else  -- X
		x"59" when ps2_data = x"35" else  -- Y
		x"5A" when ps2_data = x"1A" else  -- Z
		x"30" when ps2_data = x"45" else  -- 0
		x"31" when ps2_data = x"16" else  -- 1
		x"32" when ps2_data = x"1E" else  -- 2
		x"33" when ps2_data = x"26" else  -- 3
		x"34" when ps2_data = x"25" else  -- 4
		x"35" when ps2_data = x"2E" else  -- 5
		x"36" when ps2_data = x"36" else  -- 6
		x"37" when ps2_data = x"3D" else  -- 7
		x"38" when ps2_data = x"3E" else  -- 8
		x"39" when ps2_data = x"46" else  -- 9
		x"2D" when ps2_data = x"4E" else  -- -
		x"3D" when ps2_data = x"55" else  -- =
		x"5C" when ps2_data = x"5D" else  -- \
		x"08" when ps2_data = x"66" else  -- BKSP
		x"20" when ps2_data = x"29" else  -- SPACE
		x"09" when ps2_data = x"0D" else  -- TAB
		x"25" when ps2_data = x"58" else  -- CAPS
		x"00" when ps2_data = x"12" else  -- L SHFT
		x"01" when ps2_data = x"14" else  -- L CTRL
		x"02" when ps2_data = x"11" else  -- L ALT
		x"12" when ps2_data = x"5A" else  -- ENTER
		x"1B" when ps2_data = x"76" else  -- ESC
		x"5B" when ps2_data = x"54" else  -- [
		x"21" when ps2_data = x"75" else  -- U ARROW
		x"22" when ps2_data = x"6B" else  -- L ARROW
		x"23" when ps2_data = x"72" else  -- D ARROW
		x"24" when ps2_data = x"74" else  -- R ARROW
		x"5D" when ps2_data = x"5B" else  -- ]
		x"3B" when ps2_data = x"4C" else  -- ;
		x"27" when ps2_data = x"52" else  -- '
		x"2C" when ps2_data = x"41" else  -- ,
		x"2E" when ps2_data = x"49" else  -- .
		x"2F" when ps2_data = x"4A";      -- /
end Behavioral;

