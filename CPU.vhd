----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:12:37 11/21/2017 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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



-- my stop become a follower of bubble
-- add some trivial to process signal

entity CPU is    
Port (  
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;

        --IFF
        Ram2Addr : out STD_LOGIC_VECTOR(15 downto 0);
		  AddrExtra: out STD_LOGIC_VECTOR(3 downto 0);
        Ram2Data : inout STD_LOGIC_VECTOR(15 downto 0);
        Ram2OE : out STD_LOGIC;
        Ram2WE : out STD_LOGIC;
        Ram2EN : out STD_LOGIC;

        --MMU
        Ram1EN : out STD_LOGIC;
        Ram1WE : out STD_LOGIC;
        Ram1OE : out STD_LOGIC;
        Ram1Data : inout STD_LOGIC_VECTOR(15 downto 0);
        Ram1Addr : out STD_LOGIC_VECTOR(15 downto 0);
        UARTdataready : in STD_LOGIC;
        UARTtbre : in STD_LOGIC;
        UARTtsre : in STD_LOGIC;
        UARTrdn : out STD_LOGIC;
        UARTwrn : out STD_LOGIC;
		  
		  light : out STD_LOGIC_VECTOR(15 downto 0)
    );
end CPU;

architecture Behavioral of CPU is
    component IFF
	Port (
			clk :  in STD_LOGIC;
			rst :  in STD_LOGIC;
			bubble :  in  STD_LOGIC; -- to stop computer
            pcStop : in STD_LOGIC; -- TODO
			pcVal : in  STD_LOGIC_VECTOR (15 downto 0); -- when jump (to a address stored by registers)
			pcMuxSel :  in  STD_LOGIC; -- which pc should be selected (bind to decoder output)
			pc : out  STD_LOGIC_VECTOR (15 downto 0);
			rpc : out  STD_LOGIC_VECTOR (15 downto 0) -- pc + 1
		);
    end component;
    
    signal bubble : STD_LOGIC;
    signal pcVal : STD_LOGIC_VECTOR (15 downto 0);
    signal pcMuxSel : STD_LOGIC;
    signal pc : STD_LOGIC_VECTOR (15 downto 0);
    signal rpc : STD_LOGIC_VECTOR (15 downto 0);
    signal pcStop : STD_LOGIC;
    
    component IFID
	Port ( 
            bubble : in STD_LOGIC;
            pcStop : in STD_LOGIC;
            clk :  in STD_LOGIC;
            rst :  in STD_LOGIC;
            inRpc :  in STD_LOGIC_VECTOR (15 downto 0);
            inInstruction : in  STD_LOGIC_VECTOR (15 downto 0);
            outRpc :  out STD_LOGIC_VECTOR (15 downto 0); -- pc + 1
            outInstruction : out  STD_LOGIC_VECTOR (15 downto 0)
           );
    end component;
    
    signal instruction : STD_LOGIC_VECTOR (15 downto 0);
    signal outRpc : STD_LOGIC_VECTOR (15 downto 0);
    signal outInstruction : STD_LOGIC_VECTOR (15 downto 0);
    
    component DECODE
	port(
            instruction: IN  STD_LOGIC_VECTOR(15 downto 0);
            op: OUT  STD_LOGIC_VECTOR(3 downto 0);
            regToRead1: OUT  STD_LOGIC_VECTOR(3 downto 0);
            regToRead2: OUT  STD_LOGIC_VECTOR(3 downto 0);
            regToWrite: OUT  STD_LOGIC_VECTOR(3 downto 0);
            regWrite: OUT  STD_LOGIC;
            memIn:  OUT STD_LOGIC_VECTOR(15 downto 0);
            memWrite:  OUT STD_LOGIC;
            memRead:  OUT STD_LOGIC;
            dataRead1 : IN  STD_LOGIC_VECTOR (15 downto 0);
            dataRead2 : IN  STD_LOGIC_VECTOR (15 downto 0);
            operand1 : OUT  STD_LOGIC_VECTOR(15 downto 0);
            operand2 : OUT  STD_LOGIC_VECTOR(15 downto 0);
            rpc:  IN STD_LOGIC_VECTOR (15 downto 0);
            pcMuxSel :  OUT STD_LOGIC;
            pcVal :  OUT  STD_LOGIC_VECTOR (15 downto 0)
		);
    end component;
    
    signal op : STD_LOGIC_VECTOR (3 downto 0);
    signal regToRead1 : STD_LOGIC_VECTOR (3 downto 0);
    signal regToRead2 : STD_LOGIC_VECTOR (3 downto 0);
    signal regToWrite : STD_LOGIC_VECTOR (3 downto 0);
    signal regWrite : STD_LOGIC;
    signal memIn : STD_LOGIC_VECTOR (15 downto 0);
    signal memWrite : STD_LOGIC;
    signal memRead : STD_LOGIC;
    signal dataRead1 : STD_LOGIC_VECTOR (15 downto 0);
    signal dataRead2 : STD_LOGIC_VECTOR (15 downto 0);
    signal operand1 : STD_LOGIC_VECTOR (15 downto 0);
    signal operand2 : STD_LOGIC_VECTOR (15 downto 0);
    
    component IDEXE
    Port ( 
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            bubble : in STD_LOGIC;
            pcStop : in STD_LOGIC;
            inOp : in  STD_LOGIC_VECTOR(3 downto 0);
            inOperand1: in  STD_LOGIC_VECTOR(15 downto 0);
            inOperand2: in  STD_LOGIC_VECTOR(15 downto 0);
            inRegWrite: in STD_LOGIC; -- RegWE
            inRegToWrite:  in  STD_LOGIC_VECTOR(3 downto 0); -- DestReg 
            inMemIn:  in STD_LOGIC_VECTOR(15 downto 0); -- MemDIn
            inMemWrite:   in STD_LOGIC; -- MemWE
            inMemAccess:  in STD_LOGIC; -- AccMem
            outOp:  out  STD_LOGIC_VECTOR(3 downto 0); 
            outOperand1: out  STD_LOGIC_VECTOR(15 downto 0); 
            outOperand2:  out  STD_LOGIC_VECTOR(15 downto 0);
            outRegWrite: out STD_LOGIC;
            outRegToWrite:   out  STD_LOGIC_VECTOR(3 downto 0);
            outMemIn:    out STD_LOGIC_VECTOR(15 downto 0);
            outMemWrite: out STD_LOGIC; 
            outMemAccess: out STD_LOGIC
        );
    end component;
    
    signal exeOp : STD_LOGIC_VECTOR (3 downto 0);
    signal exeOperand1 : STD_LOGIC_VECTOR (15 downto 0); 
    signal exeOperand2 : STD_LOGIC_VECTOR (15 downto 0); 
    signal exeRegWrite : STD_LOGIC;
    signal exeRegToWrite : STD_LOGIC_VECTOR (3 downto 0);
    signal exeMemIn : STD_LOGIC_VECTOR (15 downto 0);
    signal exeMemWrite : STD_LOGIC;
    signal exeMemAccess : STD_LOGIC;
    
    component ALU
    Port ( 
            op : in  STD_LOGIC_VECTOR (3 downto 0);
            operand1 : in  STD_LOGIC_VECTOR (15 downto 0);
            operand2 : in  STD_LOGIC_VECTOR (15 downto 0);
            aluout : out  STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;
    
    signal aluout : STD_LOGIC_VECTOR (15 downto 0);
    
    component EXEMEM
    Port ( 
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            inRegWrite: in STD_LOGIC; -- whether to write back (RegWE
            inRegToWrite:  in  STD_LOGIC_VECTOR(3 downto 0); -- which register to write back (DestReg
            inMemIn:   in  STD_LOGIC_VECTOR(15 downto 0);
            inMemWrite:   in STD_LOGIC;
            inMemAccess:  in STD_LOGIC;
            inAluout: in STD_LOGIC_VECTOR(15 downto 0);
            outRegWrite: out STD_LOGIC;
            outRegToWrite: out  STD_LOGIC_VECTOR(3 downto 0); 
            outMemIn: out STD_LOGIC_VECTOR(15 downto 0); 
            outMemWrite: out STD_LOGIC;
            outMemAccess: out STD_LOGIC;
            outAluout: out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
        
    signal memRegWrite : STD_LOGIC;
    signal memRegToWrite : STD_LOGIC_VECTOR (3 downto 0);
    signal memMemIn : STD_LOGIC_VECTOR (15 downto 0);
    signal memMemWrite : STD_LOGIC;
    signal memMemAccess : STD_LOGIC;
    signal memAluout : STD_LOGIC_VECTOR (15 downto 0);

    component MEM
	Port (
            memRead : in  STD_LOGIC;
            aluout : in STD_LOGIC_VECTOR(15 downto 0);
            memData : in STD_LOGIC_VECTOR(15 downto 0);
            destVal : out STD_LOGIC_VECTOR(15 downto 0)
		);
    end component;
    
    signal destVal : STD_LOGIC_VECTOR (15 downto 0);
    
    component MEMWB
    Port ( 
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            inRegWrite: in STD_LOGIC; -- RegWE
            inRegToWrite:  in  STD_LOGIC_VECTOR(3 downto 0); -- DestReg
            inDestval: in STD_LOGIC_VECTOR(15 downto 0); -- DestVal
            outRegWrite: out STD_LOGIC;
            outRegToWrite: out STD_LOGIC_VECTOR(3 downto 0); -- bind to REG
            outDestval: out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    signal wbRegWrite : STD_LOGIC;
    signal wbRegToWrite : STD_LOGIC_VECTOR (3 downto 0);
    signal wbDestval : STD_LOGIC_VECTOR(15 downto 0);
    
    component REG
    Port (
            clk : in  STD_LOGIC;
            rst : in  STD_LOGIC;
            regWrite : in  STD_LOGIC; -- '1' to write
            regToWrite : in  STD_LOGIC_VECTOR (3 downto 0);
            dataToWrite : in  STD_LOGIC_VECTOR (15 downto 0);
            regToRead1 : in  STD_LOGIC_VECTOR (3 downto 0);
            regToRead2 : in  STD_LOGIC_VECTOR (3 downto 0);
            dataRead1 : out  STD_LOGIC_VECTOR (15 downto 0);
            dataRead2 : out  STD_LOGIC_VECTOR (15 downto 0);
				dataOut : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    component FWD
    Port ( 
            ALUReg1 : in  STD_LOGIC_VECTOR (3 downto 0); -- current register used in ALU
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
            ALURegDataReal1 : out  STD_LOGIC_VECTOR (15 downto 0);
            ALURegDataReal2 : out  STD_LOGIC_VECTOR (15 downto 0);
            bubble : out STD_LOGIC
        );
    end component;
    
    signal dataReal1 : STD_LOGIC_VECTOR (15 downto 0);
    signal dataReal2 : STD_LOGIC_VECTOR (15 downto 0);
    
    component MMU
	Port(
			clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			memRead : in STD_LOGIC;
			memWrite : in STD_LOGIC;
			memAddr : in STD_LOGIC_VECTOR(15 downto 0);
			dataIn : in STD_LOGIC_VECTOR(15 downto 0);
			memData : out STD_LOGIC_VECTOR(15 downto 0);
			pc : in STD_LOGIC_VECTOR (15 downto 0);
			instruction : out STD_LOGIC_VECTOR(15 downto 0);
			ram1_oe : out STD_LOGIC;
            ram1_rw : out STD_LOGIC;
            ram1_en : out STD_LOGIC;
			ram1_addr: out STD_LOGIC_VECTOR(15 downto 0);
			ram1_data: inout STD_LOGIC_VECTOR(15 downto 0);
			ram2_oe: out STD_LOGIC;
            ram2_rw: out STD_LOGIC;
            ram2_en: out STD_LOGIC;
			ram2_addr: out STD_LOGIC_VECTOR(15 downto 0);
			ram2_data: inout STD_LOGIC_VECTOR(15 downto 0);
			data_ready: in STD_LOGIC;
            rdn: out STD_LOGIC;
            tbre: in STD_LOGIC; 
            tsre: in STD_LOGIC; 
            wrn: out STD_LOGIC;
            
            pcStop: out STD_LOGIC -- TODO
		);
    end component;
    
    signal memOut : STD_LOGIC_VECTOR (15 downto 0);
    signal dataOut : STD_LOGIC_VECTOR(15 downto 0);
	 signal ledrdn : STD_LOGIC; -- fix me
    
begin
    myIF : IFF port map (
        clk => clk,
        rst =>rst,
        bubble => bubble,
        pcStop => pcStop,
        pcVal => pcVal, 
        pcMuxSel => pcMuxSel,
        pc => pc,
        rpc => rpc
    );
    myIFID : IFID port map (
        bubble => bubble,
        pcStop => pcStop,
        clk => clk,
        rst => rst,
        inRpc => rpc, 
        inInstruction => instruction,
        outRpc => outRpc,
        outInstruction => outInstruction
    );
    myDECODE : DECODE port map (
		instruction => outInstruction,
		op => op,
		regToRead1 => regToRead1,
		regToRead2 => regToRead2,
		regToWrite => regToWrite,
		regWrite => regWrite,
		memIn => memIn,
		memWrite => memWrite,
		memRead => memRead,
		dataRead1 => dataReal1,
		dataRead2 => dataReal2,
		operand1 => operand1,
		operand2 => operand2,
		rpc => outRpc,
		pcMuxSel => pcMuxSel,
		pcVal => pcVal
    );
    myIDEXE : IDEXE port map (
        clk => clk,
        rst => rst,
        bubble => bubble,
        pcStop => pcStop,
        inOp => op,
        inOperand1 => operand1,
        inOperand2 => operand2,
        inRegWrite => regWrite,
        inRegToWrite => regToWrite,
        inMemIn => memIn,
        inMemWrite => memWrite,
        inMemAccess => memRead,
        outOp => exeOp,
        outOperand1 => exeOperand1,
        outOperand2 => exeOperand2,
        outRegWrite => exeRegWrite,
        outRegToWrite => exeRegToWrite,
        outMemIn => exeMemIn,
        outMemWrite => exeMemWrite,
        outMemAccess => exeMemAccess
    );
    myALU : ALU port map (
        op => exeOp,
        operand1 => exeOperand1,
        operand2 => exeOperand2,
        aluout => aluout
    );
    myEXEMEM : EXEMEM port map (
        clk => clk,
        rst => rst,
        inRegWrite => exeRegWrite,
        inRegToWrite => exeRegToWrite,
        inMemIn => exeMemIn,
        inMemWrite => exeMemWrite,
        inMemAccess => exeMemAccess,
        inAluout => aluout,
        outRegWrite => memRegWrite,
        outRegToWrite => memRegToWrite,
        outMemIn => memMemIn,
        outMemWrite => memMemWrite,
        outMemAccess => memMemAccess,
        outAluout => memAluout
    );
    myMEM : MEM port map (
        memRead => memMemAccess,
        aluout => memAluout,
        memData => memOut,
        destVal => destVal
    );
    myMEMWB : MEMWB port map (
        clk => clk,
        rst => rst,
        inRegWrite => memRegWrite,
        inRegToWrite => memRegToWrite,
        inDestval => destval,
        outRegWrite => wbRegWrite,
        outRegToWrite => wbRegToWrite,
        outDestval => wbDestval
    );
    myREG : REG port map (
        clk => clk,
        rst => rst,
        regWrite => wbRegWrite,
        regToWrite => wbRegToWrite,
        dataToWrite => wbDestval,
        regToRead1 => regToRead1,
        regToRead2 => regToRead2,
        dataRead1 => dataRead1,
        dataRead2 => dataRead2,
		  dataOut => dataOut
    );
    myFWD : FWD port map (
        ALUReg1 => regToRead1, -- current register used in ALU
        ALUReg2 => regToRead2,
        ALURegData1 => dataRead1,
        ALURegData2 => dataRead2,
        IsRegWriteForward => exeRegWrite, -- last instruction write reg ( regWrite in EXE
        registerWriteForward => exeRegToWrite, -- ( regToWrite in EXE
        aluoutForwardData => aluout, -- last alu output ( aluout in EXE	  
        IsMemAccessForward => exeMemAccess, -- memAccess in EXE
        IsRegWriteForwardForward => memRegWrite, -- last last instruction write reg ( regWrite in MEM
        registerWriteForwardForward => memRegToWrite, -- ( regToWrite in MEM
        regWriteForwardForwardData => destval, -- ( DestVal in MEM
        IsRegWriteForwardForwardForward => wbRegWrite, -- last last last instruction write reg ( regWrite in WB
        registerWriteForwardForwardForward => wbRegToWrite, -- ( regToWrite in WB
        regWriteForwardForwardForwardData => wbDestval, -- ( DestVal in WB
        ALURegDataReal1 => dataReal1,
        ALURegDataReal2 => dataReal2,
        bubble => bubble
    );
    myMMU : MMU port map (
        clk => clk,
        rst => rst,
        memRead => memMemAccess,
        memWrite => memMemWrite,
        memAddr => memAluout,
        dataIn => memMemIn,
        memData => memOut,
        pc => pc,
        instruction => instruction,
        ram1_oe => Ram1OE,
        ram1_rw => Ram1WE,
        ram1_en => Ram1EN,
        ram1_addr => Ram1Addr,
        ram1_data => Ram1Data,
        ram2_oe => Ram2OE,
        ram2_rw => Ram2WE,
        ram2_en => Ram2EN,
        ram2_addr => Ram2Addr,
        ram2_data => Ram2Data,
        data_ready => UARTdataready,
        rdn => ledrdn,
        tbre => UARTtbre,
        tsre => UARTtsre,
        wrn => UARTwrn,
        pcStop => pcStop
    );
	 AddrExtra <= "0000";
	 UARTrdn <= ledrdn;
    light(15 downto 11) <= instruction(15 downto 11);
    light(10) <= ledrdn;
    light(9) <= UARTdataready;
    light(8) <= UARTtbre and UARTtsre;
    light(7 downto 2) <= dataOut(7 downto 2);
	 light(1) <= memMemAccess;
	 light(0) <= memMemWrite;
end Behavioral;

