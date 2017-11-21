----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:04:57 11/19/2017 
-- Design Name: 
-- Module Name:    MEMWB - Behavioral 
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

entity MEMWB is
    Port ( 
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  inRegWrite in STD_LOGIC; -- RegWE
			  inRegToWrite:  in  STD_LOGIC_VECTOR(3 downto 0); -- DestReg
			  inDestval: in STD_LOGIC_VECTOR(15 downto 0); -- DestVal
			
			  outRegWrite out STD_LOGIC;
			  outRegToWrite: out STD_LOGIC_VECTOR(3 downto 0); -- bind to REG
			  outDestval: out STD_LOGIC_VECTOR(15 downto 0);
			  
			  );

end MEMWB;

architecture Behavioral of MEMWB is

begin
-- pass when clk up
end Behavioral;

