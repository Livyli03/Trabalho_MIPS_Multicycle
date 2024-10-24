library IEEE; 
use IEEE.STD_LOGIC_1164.all;

---------------- Unidade de Controle ----------------------
--                                                         -
-- Esse módulo implementa a unidade de controle, compondo  -
-- os módulos fsm e aludec.                                -
--                                                         -
-- Entradas:                                               -
--   op (6 bits): opcode da instrução.                     - 
--   funct (6 bits): campo funct (instruções tipo-R).      -
--   zero (1 bits): bit zero da saída da ula.              -
--   clk: clock.                                           -
-- Saidas:                                                 -
--   memtoreg, memwrite, pcsrc, alusrcA, alusrcB, regdst,  -
--   regwrite, pcwrite, irwrite, IorD, pcen, alucontrol,   -
--   são sinais que controlam o datapath.                  -
-----------------------------------------------------------


entity controller is 
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
       clk, zero:          in  STD_LOGIC;
       pcen:               out STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       alusrcA:            out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       pcwrite, irwrite:   out STD_LOGIC;
       IorD:               out STD_LOGIC;
       pcsrc, alusrcB:     out STD_LOGIC_VECTOR(1 downto 0);
       alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
end;


architecture struct of controller is
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
  end component;

  component fsm is
    port(  op 				  : in  STD_LOGIC_VECTOR (5 downto 0);
           clk 			    : in  STD_LOGIC;
           regdst 		  : out  STD_LOGIC;
           memtoreg 		: out  STD_LOGIC;
           regwrite 		: out  STD_LOGIC;
           memwrite 		: out  STD_LOGIC;
		       branch	      : out  STD_LOGIC;
		       pcwrite		  : out  STD_LOGIC;
		       IorD			    : out  STD_LOGIC;
		       irwrite		  : out  STD_LOGIC;
           pcsrc		    : out  STD_LOGIC_VECTOR (1 downto 0);
           alusrcA 		  : out  STD_LOGIC;
           alusrcB		  : out  STD_LOGIC_VECTOR (1 downto 0);
		       aluop 			  : out  STD_LOGIC_VECTOR (1 downto 0));
  end component;
  
  signal aluop:  STD_LOGIC_VECTOR(1 downto 0);
  signal branch: STD_LOGIC;
  signal sigpcwrite: STD_LOGIC;
begin
  fsm_inst: fsm port map(
    op        => op,               -- Conecta o opcode à entrada de 'fsm'
    clk       => clk,              -- Conecta o clock à entrada de 'fsm'
    pcwrite   => sigpcwrite,       -- Conecta a saída 'pcwrite' de 'fsm' ao sinal intermediário 'sigpcwrite'
    IorD      => IorD,             -- Conecta a saída 'IorD' de 'fsm' à saída de 'controller'
    irwrite   => irwrite,          -- Conecta a saída 'irwrite' de 'fsm' à saída de 'controller'
    pcsrc     => pcsrc,            -- Conecta a saída 'pcsrc' de 'fsm' à saída de 'controller'
    memtoreg  => memtoreg,         -- Conecta a saída 'memtoreg' de 'fsm' à saída de 'controller'
    memwrite  => memwrite,         -- Conecta a saída 'memwrite' de 'fsm' à saída de 'controller'
    branch    => branch,           -- Conecta a saída 'branch' de 'fsm' ao sinal intermediário 'branch'
    alusrcA    => alusrcA,           -- Conecta a saída 'alusrcA' de 'fsm' à saída de 'controller'
    alusrcB    => alusrcB,           -- Conecta a saída 'alusrcB' de 'fsm' à saída de 'controller'
    regdst    => regdst,           -- Conecta a saída 'regdst' de 'fsm' à saída de 'controller'
    regwrite  => regwrite,         -- Conecta a saída 'regwrite' de 'fsm' à saída de 'controller'
    aluop     => aluop             -- Conecta a saída 'aluop' de 'fsm' ao sinal intermediário 'aluop'
  );
  
  aludec_inst: aludec port map(
    funct      => funct,           -- Conecta o campo de função à entrada de 'aludec'
    aluop      => aluop,           -- Conecta o sinal 'aluop' de 'fsm' à entrada de 'aludec'
    alucontrol => alucontrol       -- Conecta a saída 'alucontrol' de 'aludec' à saída de 'controller'
  );

  pcen <= (branch and zero) or sigpcwrite;

end;
