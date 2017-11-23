--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:07:40 11/23/2017
-- Design Name:   
-- Module Name:   D:/fsygd/code/github/computer/test_cpu.vhd
-- Project Name:  computer
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types STD_LOGIC and
-- STD_LOGIC_VECTOR for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.STD_LOGIC_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_cpu IS
END test_cpu;
 
ARCHITECTURE behavior OF test_cpu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU
    PORT(
         clk : in  STD_LOGIC;
         rst : in  STD_LOGIC;
         Ram2Addr : out  STD_LOGIC_VECTOR(15 downto 0);
         Ram2Data : inout  STD_LOGIC_VECTOR(15 downto 0);
         Ram2OE : out  STD_LOGIC;
         Ram2WE : out  STD_LOGIC;
         Ram2EN : out  STD_LOGIC;
         Ram1EN : out  STD_LOGIC;
         Ram1WE : out  STD_LOGIC;
         Ram1OE : out  STD_LOGIC;
         Ram1Data : inout  STD_LOGIC_VECTOR(15 downto 0);
         Ram1Addr : out  STD_LOGIC_VECTOR(15 downto 0);
         UARTdataready : in  STD_LOGIC;
         UARTtbre : in  STD_LOGIC;
         UARTtsre : in  STD_LOGIC;
         UARTrdn : out  STD_LOGIC;
         UARTwrn : out  STD_LOGIC
        );
    END COMPONENT;
    

   --Inputs
   signal clk : STD_LOGIC := '0';
   signal rst : STD_LOGIC := '0';
   signal UARTdataready : STD_LOGIC := '1';
   signal UARTtbre : STD_LOGIC := '1';
   signal UARTtsre : STD_LOGIC := '1';

	--BiDirs
   signal Ram2Data : STD_LOGIC_VECTOR(15 downto 0);
   signal Ram1Data : STD_LOGIC_VECTOR(15 downto 0);

 	--Outputs
   signal Ram2Addr : STD_LOGIC_VECTOR(15 downto 0);
   signal Ram2OE : STD_LOGIC;
   signal Ram2WE : STD_LOGIC;
   signal Ram2EN : STD_LOGIC;
   signal Ram1EN : STD_LOGIC;
   signal Ram1WE : STD_LOGIC;
   signal Ram1OE : STD_LOGIC;
   signal Ram1Addr : STD_LOGIC_VECTOR(15 downto 0);
   signal UARTrdn : STD_LOGIC;
   signal UARTwrn : STD_LOGIC;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGin
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU PORT MAP (
          clk => clk,
          rst => rst,
          Ram2Addr => Ram2Addr,
          Ram2Data => Ram2Data,
          Ram2OE => Ram2OE,
          Ram2WE => Ram2WE,
          Ram2EN => Ram2EN,
          Ram1EN => Ram1EN,
          Ram1WE => Ram1WE,
          Ram1OE => Ram1OE,
          Ram1Data => Ram1Data,
          Ram1Addr => Ram1Addr,
          UARTdataready => UARTdataready,
          UARTtbre => UARTtbre,
          UARTtsre => UARTtsre,
          UARTrdn => UARTrdn,
          UARTwrn => UARTwrn
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for clk_period;
		
		rst <= '0';

		wait for clk_period;

		rst <= '1';
		
		Ram2Data <= "0100101000000010";
		
		Ram1Data <= "0000000000000000";
		
		wait for clk_period;
		
		Ram2Data <= "0000000000000000";
		
		wait for clk_period;

      -- insert stimulus here 

      wait;
   end process;

END;
