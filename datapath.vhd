library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.STD_LOGIC_ARITH.all;


entity datapath is -- MIPS datapath
    port(clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        pcen: in STD_LOGIC;
        IorD: in STD_LOGIC;
        irwrite: in STD_LOGIC;
        regdst: in STD_LOGIC;
        memtoreg: in STD_LOGIC;
        regwrite: in STD_LOGIC;
        alusrcA: in STD_LOGIC;
        alusrcB: in STD_LOGIC_VECTOR (1 downto 0);
        alucontrol: in STD_LOGIC_VECTOR (2 downto 0);
        pcsrc: in STD_LOGIC_VECTOR (1 downto 0);
        readdata: in STD_LOGIC_VECTOR(31 downto 0);
        addr: out STD_LOGIC_VECTOR (31 downto 0);
        zero: out STD_LOGIC;
        instr: buffer STD_LOGIC_VECTOR (31 downto 0);
        writedata_B: buffer STD_LOGIC_VECTOR(31 downto 0)
        );
end datapath;


architecture struct of datapath is
-- importa todos os componentes necessários
    component ula
        port(a, b: in STD_LOGIC_VECTOR(31 downto 0);
            alucontrol: in STD_LOGIC_VECTOR(2 downto 0);
            result: buffer STD_LOGIC_VECTOR(31 downto 0);
            zero: out STD_LOGIC
            );
    end component;
    component regfile
        port(clk: in STD_LOGIC;
        we3: in STD_LOGIC;
        ra1, ra2, wa3: in STD_LOGIC_VECTOR (4 downto 0);
        wd3: in STD_LOGIC_VECTOR (31 downto 0);
        rd1, rd2: out STD_LOGIC_VECTOR (31 downto 0)
        );
    end component;
    component sl2
        port(a: in STD_LOGIC_VECTOR (31 downto 0);
            y: out STD_LOGIC_VECTOR (31 downto 0)
            );
    end component;
    component signext
        port(a: in STD_LOGIC_VECTOR (15 downto 0);
            y: out STD_LOGIC_VECTOR (31 downto 0)
            );
    end component;
    component reg generic (width: integer);
        port(clk, reset: in STD_LOGIC;
            d: in STD_LOGIC_VECTOR (width-1 downto 0);
            q: out STD_LOGIC_VECTOR (width-1 downto 0)
            );
    end component;
    component regenable generic (width: integer);
        port(clk, enable, reset: in STD_LOGIC;
            d: in STD_LOGIC_VECTOR (width-1 downto 0);
            q: out STD_LOGIC_VECTOR (width-1 downto 0)
            );
    end component;
    component mux2 generic (width: integer);
        port(d0, d1: in STD_LOGIC_VECTOR (width-1 downto 0);
            s: in STD_LOGIC;
            y: out STD_LOGIC_VECTOR (width-1 downto 0)
            );
    end component;
    component mux4 generic (width: integer);
        port(d0, d1, d2, d3: in STD_LOGIC_VECTOR (width-1 downto 0);
            s: in STD_LOGIC_VECTOR (1 downto 0);
            y: out STD_LOGIC_VECTOR (width-1 downto 0)
            );
    end component;

signal pc: STD_LOGIC_VECTOR (31 downto 0);
signal pcnext: STD_LOGIC_VECTOR (31 downto 0);
signal data: STD_LOGIC_VECTOR (31 downto 0);
signal writereg_a3: STD_LOGIC_VECTOR (4 downto 0);
signal writedata3: STD_LOGIC_VECTOR (31 downto 0);
signal rd1, rd2: STD_LOGIC_VECTOR (31 downto 0);
signal A: STD_LOGIC_VECTOR (31 downto 0);
signal srcA: STD_LOGIC_VECTOR (31 downto 0);
signal signimm, signimmsh: STD_LOGIC_VECTOR (31 downto 0);
signal srcb: STD_LOGIC_VECTOR (31 downto 0);
signal instrsh: STD_LOGIC_VECTOR (27 downto 0);
signal pcjump: STD_LOGIC_VECTOR (31 downto 0);
signal aluresult: STD_LOGIC_VECTOR (31 downto 0);
signal aluout: STD_LOGIC_VECTOR (31 downto 0);


begin

pcreg_inst: regenable generic map (32) port map (clk, pcen, reset, pcnext, pc);

mux_IorD_inst: mux2 generic map (32) port map (pc, aluout, IorD, addr);

instrreg_inst: regenable generic map (32) port map (clk, irwrite, reset, readdata, instr);

datareg_inst: reg generic map (32) port map (clk, reset, readdata, data);

mux_wa3_inst: mux2 generic map (5) port map (instr(20 downto 16), instr(15 downto 11), regdst, writereg_a3);

mux_wd3_inst: mux2 generic map (32) port map (aluout, data, memtoreg, writedata3);

regfile_inst: regfile port map (clk, regwrite, instr(25 downto 21), instr(20 downto 16), writereg_a3, writedata3, rd1, rd2);

signext_inst: signext port map (instr(15 downto 0), signimm);

rd1reg_inst: reg generic map (32) port map (clk, reset, rd1, A);

rd2reg_inst: reg generic map (32) port map (clk, reset, rd2, writedata_B);

mux_alusrcA_inst: mux2 generic map (32) port map (pc, A, alusrcA, srcA);

sl2_inst: sl2 port map (signimm, signimmsh);

mux_alusrcB_inst: mux4 generic map (32) port map (writedata_B, "00000000000000000000000000000100", signimm, signimmsh, alusrcB, srcb);

ula_inst: ula port map (srcA, srcb, alucontrol, aluresult, zero);

instr_sl2_inst: sl2 port map (instr(25 downto 0), instrsh);

pcjump <= pc(31 downto 28) & instrsh;

alureg_inst: reg generic map (32) port map (clk, reset, aluresult, aluout);

mux_pcsrc_inst: mux4 generic map (32) port map (aluresult, aluout, pcjump, pcsrc, pcnext);

end struct;
