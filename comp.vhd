library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- top-level design: interliga o processador com a memória, ou seja, define o computador.

entity comp is
  port(clk, reset:          in  STD_LOGIC;
       writedata_B, addr:   out STD_LOGIC_VECTOR(31 downto 0);
       memwrite:            out STD_LOGIC);
end comp;

architecture top of comp is

  -- Instância da memória
  component memory
    port(clk, we:       in  STD_LOGIC;
         addr:          in  STD_LOGIC_VECTOR(31 downto 0);
         wd:            in  STD_LOGIC_VECTOR(31 downto 0);
         rd:            out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  -- Instância do processador MIPS
  component mips
    port(clk:           in  STD_LOGIC;
         reset:         in  STD_LOGIC;
         readdata:      in  STD_LOGIC_VECTOR(31 downto 0);
         addr:          out STD_LOGIC_VECTOR(31 downto 0);
         memwrite:      out STD_LOGIC;
         writedata_B:   out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  -- Sinais intermediários entre MIPS e Memória
  signal memwrite:     STD_LOGIC;
  signal addr:         STD_LOGIC_VECTOR(31 downto 0);
  signal writedata_B:  STD_LOGIC_VECTOR(31 downto 0);
  signal readdata:     STD_LOGIC_VECTOR(31 downto 0);

begin
  -- Instanciando o processador MIPS
  mips_inst: mips
    port map(clk        => clk,
             reset      => reset,
             readdata   => readdata,   -- Dado lido da memória
             addr       => addr,       -- Endereço de memória
             memwrite   => memwrite,   -- Sinal de escrita
             writedata_B => writedata_B); -- Dado a ser escrito

  -- Instanciando a memória
  memory_inst: memory
    port map(clk        => clk,
             we         => memwrite,   -- Memória escreve quando o processador sinaliza
             addr       => addr,       -- Endereço da memória fornecido pelo MIPS
             wd         => writedata_B, -- Dado de escrita vindo do MIPS
             rd         => readdata);   -- Dado lido pela memória enviado ao MIPS

end top;
