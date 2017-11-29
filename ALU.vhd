----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:34:54 11/19/2017 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use WORK.def.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( op : in  STD_LOGIC_VECTOR (3 downto 0);
           operand1 : in  STD_LOGIC_VECTOR (15 downto 0);
           operand2 : in  STD_LOGIC_VECTOR (15 downto 0);
           aluout : out  STD_LOGIC_VECTOR (15 downto 0)
			 );
end ALU;

architecture Behavioral of ALU is
signal result : STD_LOGIC_VECTOR(15 downto 0);
begin

-- alu, combinational logic
	process (operand1, operand2, op)
	begin
		case op is
			when OP_ADD =>
				result <= operand1 + operand2;
			
			when OP_AND =>
				result <= operand1 and operand2;
				
			when OP_CMP =>
				if operand1 = operand2 then
					result <= x"0000";
				else
					result <= x"0001";
				end if;
			
			when OP_OR =>
				result <= operand1 or operand2;
			
			--fsygd: immediate = 0 ?
			when OP_SLL =>
				if operand2 = x"0000" then
					result <= to_stdlogicvector(to_bitvector(operand1) sll 8);
				else
					result <= to_stdlogicvector(to_bitvector(operand1) sll conv_integer(operand2(2 downto 0)));
				end if;
			
			when OP_SLT =>
				if signed(operand1) >= signed(operand2) then
					result <= x"0000";
				else
					result <= x"0001";
				end if;
				
			when OP_SLTU =>
				if operand1 >= operand2 then
					result <= x"0000";
				else
					result <= x"0001";
				end if;
			--fsygd: immediate = 0 ?
			when OP_SRA =>
				if operand2 = x"0000" then
					result <= to_stdlogicvector(to_bitvector(operand1) sra 8);
				else
					result <= to_stdlogicvector(to_bitvector(operand1) sra conv_integer(operand2(2 downto 0)));
				end if;
				
			when OP_SUB =>
				result <= operand1 - operand2;
			
			when OP_PASS_A =>
				result <= operand1;
			
			when OP_PASS_B =>
				result <= operand2;
			
			when OTHERS =>
				result <= x"0000";
		end case;
	end process;
	aluout <= result;
end Behavioral;

