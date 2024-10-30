library IEEE; 
use IEEE.STD_LOGIC_1164.all;

 -- Processador MIPS de multi ciclo

entity mips is
  port(clk:               in  STD_LOGIC;
       reset:             in  STD_LOGIC;
       readdata:          inout  STD_LOGIC_VECTOR(31 downto 0);
       addr:              inout STD_LOGIC_VECTOR(31 downto 0);
       memwrite:          inout STD_LOGIC;
       writedata_B:       inout STD_LOGIC_VECTOR(31 downto 0);
       alusrcA: 			  inout STD_LOGIC;
       alusrcB: 			  inout STD_LOGIC_VECTOR (1 downto 0);
	    srcA: 				  out STD_LOGIC_VECTOR (31 downto 0);
		 srcB: 				  out STD_LOGIC_VECTOR (31 downto 0);
		 aluresult: 		  out STD_LOGIC_VECTOR (31 downto 0)
		 );
end;

architecture top of mips is
  component controller
    port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
        clk, reset:         in  STD_LOGIC;
        memtoreg:           out STD_LOGIC;
        alusrcA:            out STD_LOGIC;
        regdst, regwrite:   out STD_LOGIC;
        pcwrite, irwrite:   out STD_LOGIC;
        IorD:               out STD_LOGIC;
        pcsrc, alusrcB:     out STD_LOGIC_VECTOR(1 downto 0);
        alucontrol:         out STD_LOGIC_VECTOR(2 downto 0);
        memwrite:           buffer STD_LOGIC);
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
        alusrcA: inout STD_LOGIC;
        alusrcB: inout STD_LOGIC_VECTOR (1 downto 0);
        alucontrol: in STD_LOGIC_VECTOR (2 downto 0);
        pcsrc: in STD_LOGIC_VECTOR (1 downto 0);
        readdata: in STD_LOGIC_VECTOR(31 downto 0);
        addr: out STD_LOGIC_VECTOR (31 downto 0);
        zero: out STD_LOGIC;
        instr: buffer STD_LOGIC_VECTOR (31 downto 0);
        writedata_B: buffer STD_LOGIC_VECTOR(31 downto 0);
		  srcA: buffer STD_LOGIC_VECTOR (31 downto 0);
		  srcB: buffer STD_LOGIC_VECTOR (31 downto 0);
		  aluresult: buffer STD_LOGIC_VECTOR (31 downto 0)
		  );
  end component;
  component memory
    port(clk, we:  in STD_LOGIC;
        addr:     in STD_LOGIC_VECTOR(31 downto 0);
        wd:       in STD_LOGIC_VECTOR(31 downto 0);
        rd:       out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  -- Definindo os sinais intermediários
  signal pcen:           STD_LOGIC;
  signal memtoreg:       STD_LOGIC;
  signal IorD:           STD_LOGIC;
  signal regdst:         STD_LOGIC;
  signal regwrite:       STD_LOGIC;
  signal pcwrite:        STD_LOGIC;
  signal branch:         STD_LOGIC;
  signal irwrite:        STD_LOGIC;
  signal zero:           STD_LOGIC;
  signal pcsrc:          STD_LOGIC_VECTOR(1 downto 0);
  signal alucontrol:     STD_LOGIC_VECTOR(2 downto 0);
  signal instr:          STD_LOGIC_VECTOR(31 downto 0);

begin
-- Instancie a unidade de controle (controller) conectando os sinais de entrada de forma apropriada
  controller_inst: controller port map(
      op         => instr(31 downto 26),
      funct      => instr(5 downto 0),
      clk        => clk,
      reset      => reset,
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
      writedata_B     => writedata_B,
		srcA            => srcA,
		srcB            => srcB,
		aluresult		 => aluresult
  );

-- Instanciando a memória
  memory_inst: memory
    port map(clk        => clk,
             we         => memwrite,   -- Memória escreve quando o processador sinaliza
             addr       => addr,       -- Endereço da memória fornecido pelo MIPS
             wd         => writedata_B, -- Dado de escrita vindo do MIPS
             rd         => readdata);   -- Dado lido pela memória enviado ao MIPS

pcen <= (branch and zero) or pcwrite;

end top;
