----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:51:14 11/21/2017 
-- Design Name: 
-- Module Name:    MEM - Behavioral 
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

entity MEM is
Port (
		memRead : in  STD_LOGIC;
		aluout : in STD_LOGIC_VECTOR(15 downto 0);
		memData : in STD_LOGIC_VECTOR(15 downto 0);
		destval : out STD_LOGIC_VECTOR(15 downto 0)
	);
end MEM;

architecture Behavioral of MEM is

begin
-- a selector
end Behavioral;

