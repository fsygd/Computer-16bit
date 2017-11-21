----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:14:59 11/19/2017 
-- Design Name: 
-- Module Name:    DECODE - Behavioral 
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

entity DECODE is	
port( 
		--*-- decode part --*--
		instruction: IN  STD_LOGIC_VECTOR(15 downto 0);

		op: OUT  STD_LOGIC_VECTOR(3 downto 0); -- tell alu what to do

		regToRead1: OUT  STD_LOGIC_VECTOR(3 downto 0); -- which register to read accroding to instruction (ASel
		regToRead2: OUT  STD_LOGIC_VECTOR(3 downto 0); -- (BSel
		
		regToWrite: OUT  STD_LOGIC_VECTOR(3 downto 0); -- which register to write back
		regWrite: OUT  STD_LOGIC; -- whether write back
		
		memIn:  OUT STD_LOGIC_VECTOR(15 downto 0); -- data to write in memory
		memWrite:  OUT STD_LOGIC; -- whether write memory
		memAccess:  OUT STD_LOGIC; -- whether read memory
		
		--*-- fast read & pc set part --*--
		--*-- by access register files (using regToRead) --*--
		
	   dataRead1 : IN  STD_LOGIC_VECTOR (15 downto 0); -- bind to FWDUnit, the true data, can bind to operand?
	   dataRead2 : IN  STD_LOGIC_VECTOR (15 downto 0);
		operand1 : OUT  STD_LOGIC_VECTOR(15 downto 0); -- data send to alu
		operand2 : OUT  STD_LOGIC_VECTOR(15 downto 0);
		rpc:  IN STD_LOGIC_VECTOR (15 downto 0); -- bind back to IF
		pcMuxSel :  OUT STD_LOGIC_VECTOR (1 downto 0); -- bind back to IF
		pcOffset :  OUT STD_LOGIC_VECTOR (15 downto 0); -- bind back to IF
		pcVal :  OUT  STD_LOGIC_VECTOR (15 downto 0); -- bind back to IF
	); 
end DECODE;

architecture Behavioral of DECODE is

begin
-- combinational logic
end Behavioral;

