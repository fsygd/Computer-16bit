--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library IEEE;
use IEEE.STD_LOGIC_1164.all;

package def is

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	constant OP_ADD:  STD_LOGIC_VECTOR(3 downto 0):= "0000";
	constant OP_SUB:  STD_LOGIC_VECTOR(3 downto 0):= "0001";
	constant OP_CMP:  STD_LOGIC_VECTOR(3 downto 0):= "0010";
	constant OP_SLT:  STD_LOGIC_VECTOR(3 downto 0):= "0011";
	constant OP_AND:  STD_LOGIC_VECTOR(3 downto 0):= "0100";
	constant OP_OR:   STD_LOGIC_VECTOR(3 downto 0):= "0101";
	constant OP_SLL:  STD_LOGIC_VECTOR(3 downto 0):= "0110";
	constant OP_SRA:  STD_LOGIC_VECTOR(3 downto 0):= "0111";
	constant OP_PASS_A: STD_LOGIC_VECTOR(3 downto 0):= "1000";
	constant OP_PASS_B: STD_LOGIC_VECTOR(3 downto 0):= "1001";
	constant OP_SLTU: STD_LOGIC_VECTOR(3 downto 0):= "1010";
  
	constant R0: STD_LOGIC_VECTOR(3 downto 0):= "0000";
	constant R1: STD_LOGIC_VECTOR(3 downto 0):= "0001";
	constant R2: STD_LOGIC_VECTOR(3 downto 0):= "0010";
	constant R3: STD_LOGIC_VECTOR(3 downto 0):= "0011";
	constant R4: STD_LOGIC_VECTOR(3 downto 0):= "0100";
	constant R5: STD_LOGIC_VECTOR(3 downto 0):= "0101";
	constant R6: STD_LOGIC_VECTOR(3 downto 0):= "0110";
	constant R7: STD_LOGIC_VECTOR(3 downto 0):= "0111";
	constant SP: STD_LOGIC_VECTOR(3 downto 0):= "1000";
	constant IH: STD_LOGIC_VECTOR(3 downto 0):= "1001";
	constant RA:  STD_LOGIC_VECTOR(3 downto 0):= "1010";
	constant T: STD_LOGIC_VECTOR(3 downto 0):= "1011";
	constant NO_REG: STD_LOGIC_VECTOR(3 downto 0):= "0000";
	
	constant ZERO: STD_LOGIC_VECTOR(15 downto 0):= "0000000000000000";
end def;

package body def is

---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end def;
