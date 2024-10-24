library IEEE; 
use IEEE.STD_LOGIC_1164.all;

 -- Processador MIPS de multi ciclo

entity mips is
  port(clk:               in  STD_LOGIC;
       reset:             in  STD_LOGIC;
       readdata:          in  STD_LOGIC_VECTOR(31 downto 0);
       addr:              out STD_LOGIC_VECTOR(31 downto 0);
       memwrite:          out STD_LOGIC;
       writedata_B:       out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture struct of mips is
  component controller
    port(op, funct:         in  STD_LOGIC_VECTOR(5 downto 0);
        clk, zero:          in  STD_LOGIC;
        pcen:               out STD_LOGIC;
        memtoreg, memwrite: out STD_LOGIC;
        alusrcA:            out STD_LOGIC;
        regdst, regwrite:   out STD_LOGIC;
        pcwrite, irwrite:   out STD_LOGIC;
        IorD:               out STD_LOGIC;
        pcsrc, alusrcB:     out STD_LOGIC_VECTOR(1 downto 0);
        alucontrol:         out STD_LOGIC_VECTOR(2 downto 0));
  end component;
  component datapath
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
        writedata_B: buffer STD_LOGIC_VECTOR(31 downto 0);
		  aluout: buffer STD_LOGIC_VECTOR (31 downto 0));
  end component;

  -- Definindo os sinais intermediários
  signal pcen:           STD_LOGIC;
  signal memtoreg:       STD_LOGIC;
  signal IorD:           STD_LOGIC;
  signal alusrcA:        STD_LOGIC;
  signal regdst:         STD_LOGIC;
  signal regwrite:       STD_LOGIC;
  signal pcwrite:        STD_LOGIC;
  signal irwrite:        STD_LOGIC;
  signal pcsrc:          STD_LOGIC_VECTOR(1 downto 0);
  signal alusrcB:        STD_LOGIC_VECTOR(1 downto 0);
  signal alucontrol:     STD_LOGIC_VECTOR(2 downto 0);
  signal zero:           STD_LOGIC;
  signal instr:          STD_LOGIC_VECTOR(31 downto 0);
  signal aluout:         STD_LOGIC_VECTOR(31 downto 0);

begin
-- Instancie a unidade de controle (controller) conectando os sinais de entrada de forma apropriada
  controller_inst: controller port map(
      op         => instr(31 downto 26),
      funct      => instr(5 downto 0),
      clk        => clk,
      zero       => zero,
      pcen       => pcen,
      memtoreg   => memtoreg, 
      memwrite   => memwrite,
      alusrcA    => alusrcA,
      regdst     => regdst,
      regwrite   => regwrite,
      pcwrite    => pcwrite,
      irwrite    => irwrite,
      pcsrc		   => pcsrc,
      alusrcB    => alusrcB,
      alucontrol => alucontrol
  );

-- Instancie o datapath conectando os sinais de controle gerados pela unidade de controle
  datapath_inst: datapath port map(
      -- inputs
      clk 	   	      => clk,
      reset		        => reset,
      pcen			      => pcen,
      IorD			      => IorD,
      irwrite		      => irwrite,
      regdst				  => regdst,
      memtoreg 			  => memtoreg,
      regwrite 			  => regwrite,
      alusrcA			    => alusrcA,
      alusrcB			    => alusrcB,
      alucontrol			=> alucontrol,
      pcsrc			      => pcsrc,
      readdata        => readdata,
      addr            => addr,
      zero					  => zero,
      instr					  => instr,
      aluout          => aluout,
      writedata_B     => writedata_B
  );
end struct;
