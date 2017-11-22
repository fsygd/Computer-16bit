----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:45:36 11/19/2017 
-- Design Name: 
-- Module Name:    REG - Behavioral 
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

entity REG is
    Port ( clk : in  STD_LOGIC; -- this clk should only be used to write
           rst : in  STD_LOGIC;
			  
           regWrite : in  STD_LOGIC; -- '1' to write
			  
           regToWrite : in  STD_LOGIC_VECTOR (3 downto 0);
           dataToWrite : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  --*-- the read part of register files should code in combinational logic style --*--
			  
           regToRead1 : in  STD_LOGIC_VECTOR (3 downto 0);
           regToRead2 : in  STD_LOGIC_VECTOR (3 downto 0);
           dataRead1 : out  STD_LOGIC_VECTOR (15 downto 0);
           dataRead2 : out  STD_LOGIC_VECTOR (15 downto 0)
			  
			  );
end REG;

architecture Behavioral of REG is

begin

-- rst to reset all the registers
-- set the correct address (and data when write)
-- when CLK down, check regWrite (to see if write back)

end Behavioral;

