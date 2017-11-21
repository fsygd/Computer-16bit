----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:43:02 11/19/2017 
-- Design Name: 
-- Module Name:    IDEXE - Behavioral 
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

entity IDEXE is
    Port ( 
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  bubble : in STD_LOGIC;
			  
			  inOp: in  STD_LOGIC_VECTOR(3 downto 0);
			  inOperand1: in  STD_LOGIC_VECTOR(15 downto 0);
			  inOperand2: in  STD_LOGIC_VECTOR(15 downto 0);
			  inRegWrite: in STD_LOGIC; -- RegWE
			  inRegToWrite:  in  STD_LOGIC_VECTOR(3 downto 0); -- DestReg 
			  inMemIn:   in STD_LOGIC; -- MemDIn
			  inMemWrite:   in STD_LOGIC; -- MemWE
			  inMemAccess:  in STD_LOGIC; -- AccMem
		
			  outOp:  out  STD_LOGIC_VECTOR(3 downto 0); 
			  outOperand1: out  STD_LOGIC_VECTOR(15 downto 0); 
			  outOperand2:  out  STD_LOGIC_VECTOR(15 downto 0);
			  outRegWrite out STD_LOGIC;
			  outRegToWrite:   out  STD_LOGIC_VECTOR(3 downto 0);
			  outMemIn:    out STD_LOGIC;
			  outMemWrite: out STD_LOGIC; 
			  outMemAccess: out STD_LOGIC;
			  
			  
			  );
end IDEXE;

architecture Behavioral of IDEXE is
begin

-- pass when clk up

-- if bubble, pass a NOP

end Behavioral;

