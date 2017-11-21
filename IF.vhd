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
           pcOffset : in  STD_LOGIC_VECTOR (15 downto 0); -- when branch
           pcVal : in  STD_LOGIC_VECTOR (15 downto 0); -- when jump (to a address stored by registers)
           pcMuxSel :  in  STD_LOGIC_VECTOR (1 downto 0); -- which pc should be selected (bind to decoder output)
           rpc : out  STD_LOGIC_VECTOR (15 downto 0); -- pc + 1
			  );
end IFF;

architecture Behavioral of IFF is
begin

-- combinational logic

end Behavioral;

