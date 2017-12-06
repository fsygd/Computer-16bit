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
		CLKout : in STD_LOGIC;
		CLKin : in STD_LOGIC;
		Reset : in  STD_LOGIC;
		EN : in STD_LOGIC;
		-- CharBufferA
		CharWea : in STD_LOGIC_VECTOR(0 downto 0);
		CharAddra : in STD_LOGIC_VECTOR(10 downto 0);
		CharDina : in STD_LOGIC_VECTOR(7 downto 0);
		CharDouta : out STD_LOGIC_VECTOR(7 downto 0);
		-- GRam
		GRamAddra : out STD_LOGIC_VECTOR(14 downto 0);
		GRamDina : out STD_LOGIC_VECTOR(15 downto 0)
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
    
	signal CharAddrb_in : STD_LOGIC_VECTOR(10 downto 0);
	signal CharDoutb_in : STD_LOGIC_VECTOR(7 downto 0);
	signal LettersAddr : STD_LOGIC_VECTOR(11 downto 0);
	signal LettersDout : STD_LOGIC_VECTOR(15 downto 0);
	signal LetterDoutReverse : STD_LOGIC_VECTOR(15 downto 0);
	signal LettersResult : STD_LOGIC_VECTOR(15 downto 0);
	signal LineNumOfChar : STD_LOGIC_VECTOR(3 downto 0);
	signal Char : STD_LOGIC_VECTOR(7 downto 0);
	signal TempChar : STD_LOGIC_VECTOR(7 downto 0);
	signal Second : STD_LOGIC;
    
	type STATE_TYPE is (RST, INIT, INIT2, CHARA, GRAMAD, FINISH);
	signal state : STATE_TYPE;
    
begin
	LetterDoutReverse(0) <= LettersDout(15);
	LetterDoutReverse(1) <= LettersDout(14);
	LetterDoutReverse(2) <= LettersDout(13);
	LetterDoutReverse(3) <= LettersDout(12);
	LetterDoutReverse(4) <= LettersDout(11);
	LetterDoutReverse(5) <= LettersDout(10);
	LetterDoutReverse(6) <= LettersDout(9);
	LetterDoutReverse(7) <= LettersDout(8);
	LetterDoutReverse(8) <= LettersDout(7);
	LetterDoutReverse(9) <= LettersDout(6);
	LetterDoutReverse(10) <= LettersDout(5);
	LetterDoutReverse(11) <= LettersDout(4);
	LetterDoutReverse(12) <= LettersDout(3);
	LetterDoutReverse(13) <= LettersDout(2);
	LetterDoutReverse(14) <= LettersDout(1);
	LetterDoutReverse(15) <= LettersDout(0);
	CharBuffer_c : CharBuffer port map(
		clka => CLKout,
		clkb => CLKin,
		wea => CharWea,
		addra => CharAddra,
		dina => CharDina,
		douta => CharDouta,
		web => "0",
		addrb => CharAddrb_in,
		dinb => (others => 'Z'),
		doutb => CharDoutb_in
	);
	Letters_c : Letters port map(
		clka => CLKin,
		addra => LettersAddr,
		douta => LettersDout
	);
    
	Char <= TempChar when TempChar(7) = '0' else
			not TempChar;
	LettersResult <= not LetterDoutReverse when Second = '1' and TempChar(7) = '1' else
						LetterDoutReverse;
    -- TempChar(7) = '1' ==> reverse color
    
	LettersAddr <= Char(7 downto 0) & LineNumOfChar;
    
	process( CLKin, Reset, EN )
	variable RowNum : integer range 0 to 39 := 0;
	variable LineNum : integer range 0 to 29 := 0;
	variable num : integer range 0 to 15 := 0;
	variable result : integer range 0 to 19200;
	begin
		if EN = '1' then
			if Reset = '0' then
				LineNumOfChar <= (others => '0');
				CharAddrb_in <= (others => '0');
				state <= RST;
			elsif rising_edge(CLKin) then
				case state is
					when RST =>
						CharAddrb_in <= CharAddrb_in + 1; -- input address ++
						state <= INIT;
					when INIT =>
						state <= INIT2;
					when INIT2 =>
						TempChar <= CharDoutb_in; -- current char val
						state <= CHARA;
					when CHARA =>
						GRamDina <= LettersResult; -- 
						result := (LineNum * 16 + num) * 40 + RowNum; -- 
						GRamAddra <= CONV_STD_LOGIC_VECTOR(result, 15);
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
						CharAddrb_in <= CharAddrb_in + 1;
					when FINISH =>
						LineNumOfChar <= (others => '0');
						CharAddrb_in <= (others => '0');
						state <= INIT;
					when others =>
						state <= INIT;
				end case;
			end if;
		end if;
	end process;

	process(CLKin)
	variable counter : integer range 0 to 25000002 := 0;
	begin
		if rising_edge(CLKin) then
			counter := counter + 1;
			if counter = 25000000 then
				counter := 0;
				Second <= not Second;
			end if;
		end if;
	end process;
    -- second is a color signal
    
end Behavioral;

