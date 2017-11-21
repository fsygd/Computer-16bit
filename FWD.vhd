----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:10:58 11/21/2017 
-- Design Name: 
-- Module Name:    FWD - Behavioral 
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

entity FWD is
    Port ( ALUReg1 : in  STD_LOGIC_VECTOR (3 downto 0); -- current register used in ALU
           ALUReg2 : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALURegData1 : in  STD_LOGIC_VECTOR (15 downto 0);
			  ALURegData2 : in  STD_LOGIC_VECTOR (15 downto 0);
			  
			  IsRegWriteForward : in STD_LOGIC; -- last instruction write reg ( regWrite in EXE
			  registerWriteForward : in STD_LOGIC_VECTOR (3 downto 0); -- ( regToWrite in EXE
			  aluoutForwardData : in STD_LOGIC_VECTOR (15 downto 0); -- last alu output ( aluout in EXE	  
			  IsMemAccessForward : in STD_LOGIC; -- memAccess in EXE
			  
			  IsRegWriteForwardForward : in STD_LOGIC; -- last last instruction write reg ( regWrite in MEM
			  registerWriteForwardForward : in STD_LOGIC_VECTOR (3 downto 0); -- ( regToWrite in MEM
			  regWriteForwardForwardData : in STD_LOGIC_VECTOR (15 downto 0); -- ( DestVal in MEM
			  
			  IsRegWriteForwardForwardForward : in STD_LOGIC; -- last last last instruction write reg ( regWrite in WB
			  registerWriteForwardForwardForward : in STD_LOGIC_VECTOR (3 downto 0); -- ( regToWrite in WB
			  regWriteForwardForwardForwardData : in STD_LOGIC_VECTOR (15 downto 0); -- ( DestVal in WB
			  
			  pcMuxSel : in STD_LOGIC_VECTOR (1 downto 0);
			  
			  ALURegDataReal1 : out  STD_LOGIC_VECTOR (15 downto 0);
			  ALURegDataReal2 : out  STD_LOGIC_VECTOR (15 downto 0)
			  
			  bubble : out STD_LOGIC
			  )
end FWD;

architecture Behavioral of FWD is

begin


end Behavioral;

