----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:33:59 11/19/2017 
-- Design Name: 
-- Module Name:    IFID - Behavioral 
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

entity IFID is
	 Port ( 
			  bubble : in STD_LOGIC;
           clk :  in STD_LOGIC;
           rst :  in STD_LOGIC;
			  
           inRpc :  in STD_LOGIC_VECTOR (15 downto 0);
           inInstruction : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  outRpc :  out STD_LOGIC_VECTOR (15 downto 0); -- pc + 1
           outInstruction : out  STD_LOGIC_VECTOR (15 downto 0)
           );
end IFID;

architecture Behavioral of IFID is
signal RpcBuffer : STD_LOGIC_VECTOR (15 downto 0);
signal InstructionBuffer : STD_LOGIC_VECTOR (15 downto 0);
begin

-- when CLK up, pass those data
-- if bubble, don't do anything
	process(clk, bubble, rst, inRpc, inInstruction)
	begin
		if rst = '0' then
			RpcBuffer <= (others => '0');
			InstructionBuffer <= (others => '0');
		elsif clk'event and clk = '1' then
			if bubble = '0' then
				RpcBuffer <= inRpc;
				InstructionBuffer <= inInstruction;
			end if;
		end if;
	end process;

	outRpc <= RpcBuffer;
	outInstruction <= InstructionBuffer;

end Behavioral;