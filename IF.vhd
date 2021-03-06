----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:52:40 11/19/2017 
-- Design Name: 
-- Module Name:    IF - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFF is
	Port (
			clk :  in STD_LOGIC;
			rst :  in STD_LOGIC;
			bubble :  in  STD_LOGIC; -- to stop computer
         pcStop : in STD_LOGIC; -- TODO
			pcVal : in  STD_LOGIC_VECTOR (15 downto 0); -- when jump (to a address stored by registers)
			pcMuxSel :  in  STD_LOGIC; -- which pc should be selected (bind to decoder output)
			pc : out  STD_LOGIC_VECTOR (15 downto 0);
			rpc : out  STD_LOGIC_VECTOR (15 downto 0) -- pc + 1
		);
end IFF;

architecture Behavioral of IFF is
	signal tempPc : STD_LOGIC_VECTOR (15 downto 0);
begin

-- combinational logic
	process(clk, rst, bubble, pcVal, pcMuxSel, tempPc, pcStop)
	begin
		if rst <= '0' then
			tempPc <= (others => '0');
		elsif clk'event and clk = '1' then
			if bubble = '1' or pcStop = '1' then
				--none
			elsif pcMuxSel = '1' then
				tempPc <= pcVal;
			else
				tempPc <= tempPc + x"1";
			end if;
		end if;
	end process;
	pc <= tempPc;
	rpc <= tempPc + x"1";
end Behavioral;

