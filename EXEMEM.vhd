----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:02:29 11/19/2017 
-- Design Name: 
-- Module Name:    EXEMEM - Behavioral 
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

entity EXEMEM is
    Port ( 
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  
			  inRegWrite: in STD_LOGIC; -- whether to write back (RegWE
			  inRegToWrite:  in  STD_LOGIC_VECTOR(3 downto 0); -- which register to write back (DestReg
			  inMemIn:   in  STD_LOGIC_VECTOR(15 downto 0);
			  inMemWrite:   in STD_LOGIC;
			  inMemAccess:  in STD_LOGIC;
			  inAluout: in STD_LOGIC_VECTOR(15 downto 0);

		
			  outRegWrite out STD_LOGIC;
			  outRegToWrite: out  STD_LOGIC_VECTOR(3 downto 0); 
			  outMemIn: out STD_LOGIC_VECTOR(15 downto 0); 
			  outMemWrite: out STD_LOGIC;
			  outMemAccess: out STD_LOGIC;
			  outAluout: out STD_LOGIC_VECTOR(15 downto 0);
			  );

end EXEMEM;

architecture Behavioral of EXEMEM is

begin
-- pass when clk up
end Behavioral;

