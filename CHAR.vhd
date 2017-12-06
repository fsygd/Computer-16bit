----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:17:01 12/05/2017 
-- Design Name: 
-- Module Name:    CHAR - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CHAR is
	port(
		clk_origin : in STD_LOGIC;
		clk_25 : in STD_LOGIC;
		rst : in  STD_LOGIC;
		EN : in STD_LOGIC;
        
		WE : in STD_LOGIC_VECTOR(0 downto 0);
		GAddress : in STD_LOGIC_VECTOR(10 downto 0);
		GData : in STD_LOGIC_VECTOR(7 downto 0);
        
		PAddress : out STD_LOGIC_VECTOR(14 downto 0);
		PData : out STD_LOGIC_VECTOR(15 downto 0)
	  );
end CHAR;

architecture Behavioral of CHAR is
	component Letters is
		port (
			clka : in STD_LOGIC;
			addra : in STD_LOGIC_VECTOR(11 downto 0);
			douta : out STD_LOGIC_VECTOR(15 downto 0)
		);
	end component;
    -- address to get data
    
	component CharBuffer is
		port (
			clka : in STD_LOGIC;
			wea : in STD_LOGIC_VECTOR(0 downto 0);
			addra : in STD_LOGIC_VECTOR(10 downto 0);
			dina : in STD_LOGIC_VECTOR(7 downto 0);
			douta : out STD_LOGIC_VECTOR(7 downto 0);
			clkb : in STD_LOGIC;
			web : in STD_LOGIC_VECTOR(0 downto 0);
			addrb : in STD_LOGIC_VECTOR(10 downto 0);
			dinb : in STD_LOGIC_VECTOR(7 downto 0);
			doutb : out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
    -- another GRAM
    
	signal CAddr : STD_LOGIC_VECTOR(10 downto 0);
	signal CData : STD_LOGIC_VECTOR(7 downto 0);
	signal LAddr : STD_LOGIC_VECTOR(11 downto 0);
	signal LData : STD_LOGIC_VECTOR(15 downto 0);
	signal LDataReverse : STD_LOGIC_VECTOR(15 downto 0);
	signal LShow : STD_LOGIC_VECTOR(15 downto 0);
	signal LineNumOfChar : STD_LOGIC_VECTOR(3 downto 0);
	signal Char : STD_LOGIC_VECTOR(7 downto 0);
	signal TempChar : STD_LOGIC_VECTOR(7 downto 0);
	signal Second : STD_LOGIC;
    
	type STATE_TYPE is (STATE_RST, INIT, INIT2, CHARA, GRAMAD, FINISH);
	signal state : STATE_TYPE;
    
begin

	process( clk_25, rst, EN )
	variable RowNum : integer range 0 to 39 := 0;
	variable LineNum : integer range 0 to 29 := 0;
	variable num : integer range 0 to 15 := 0;
	variable result : integer range 0 to 19200;
	begin
		if EN = '1' then
			if rst = '0' then
				LineNumOfChar <= (others => '0');
				CAddr <= (others => '0');
				state <= STATE_RST;
			elsif rising_edge(clk_25) then
				case state is
					when STATE_RST =>
						CAddr <= CAddr + 1; -- input address ++
						state <= INIT;
					when INIT =>
						state <= INIT2;
					when INIT2 =>
						TempChar <= CData; -- current char val
						state <= CHARA;
					when CHARA =>
						PData <= LShow; -- 
						result := (LineNum * 16 + num) * 40 + RowNum; -- 
						PAddress <= CONV_STD_LOGIC_VECTOR(result, 15);
						if LineNumOfChar = "1111" then
							LineNumOfChar <= "0000";
							num := 0;
							state <= GRAMAD;
						else
							LineNumOfChar <= LineNumOfChar + 1;
							num := num + 1;
							state <= CHARA;
						end if ;
					when GRAMAD =>
						if RowNum = 39 then
							RowNum := 0;
							if LineNum = 29 then
								LineNum := 0;
								state <= FINISH;
							else
								LineNum := LineNum + 1;
								state <= INIT;
							end if;
						else
							RowNum := RowNum + 1;
							state <= INIT;
						end if;
						CAddr <= CAddr + 1;
					when FINISH =>
						LineNumOfChar <= (others => '0');
						CAddr <= (others => '0');
						state <= INIT;
					when others =>
						state <= INIT;
				end case;
			end if;
		end if;
	end process;

	process(clk_25)
	variable counter : integer range 0 to 25000002 := 0;
	begin
		if rising_edge(clk_25) then
			counter := counter + 1;
			if counter = 25000000 then
				counter := 0;
				Second <= not Second;
			end if;
		end if;
	end process;
    -- second is a color signal

	LDataReverse(0) <= LData(15);
	LDataReverse(1) <= LData(14);
	LDataReverse(2) <= LData(13);
	LDataReverse(3) <= LData(12);
	LDataReverse(4) <= LData(11);
	LDataReverse(5) <= LData(10);
	LDataReverse(6) <= LData(9);
	LDataReverse(7) <= LData(8);
	LDataReverse(8) <= LData(7);
	LDataReverse(9) <= LData(6);
	LDataReverse(10) <= LData(5);
	LDataReverse(11) <= LData(4);
	LDataReverse(12) <= LData(3);
	LDataReverse(13) <= LData(2);
	LDataReverse(14) <= LData(1);
	LDataReverse(15) <= LData(0);
	myCharBuffer : CharBuffer port map(
		clka => clk_origin,
		clkb => clk_25,
		wea => WE,
		addra => GAddress,
		dina => GData,
		douta => open,
		web => "0",
		addrb => CAddr,
		dinb => (others => 'Z'),
		doutb => CData
	);
	myLetters : Letters port map(
		clka => clk_25,
		addra => LAddr,
		douta => LData
	);
    
	Char <= TempChar when TempChar(7) = '0' else
			not TempChar;
	LShow <= not LDataReverse when Second = '1' and TempChar(7) = '1' else
						LDataReverse;
    -- TempChar(7) = '1' ==> reverse color
    
	LAddr <= Char(7 downto 0) & LineNumOfChar;
    
end Behavioral;

