library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench is
end testbench;

architecture test of testbench is
  -- Instância do componente mips
  component mips
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
  end component;

  signal writedata_B, addr, readdata, srcA, srcB, aluresult: STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset, memwrite, alusrcA: STD_LOGIC;
  signal alusrcB: STD_LOGIC_VECTOR(1 downto 0);

begin
  -- Instancie o componente mips (MIPS multi-ciclo com memória)
  dut: mips port map(
            clk        => clk,
            reset      => reset,
            readdata   => readdata,
            addr       => addr,
            memwrite   => memwrite,
            writedata_B => writedata_B,
				alusrcA     => alusrcA,
				alusrcB     => alusrcB,
				srcA        => srcA,
				srcB        => srcB,
				aluresult   => aluresult
				);

  -- Geração do clock com período de 10 ns
  clk_process: process
  begin
    clk <= '1';
    wait for 5 ns; 
    clk <= '0';
    wait for 5 ns;
  end process;

  -- Processo de reset (sinal de reset ativo nos primeiros 2 ciclos)
  reset_process: process
  begin
    reset <= '1';
    wait for 1 ns; 
    reset <= '0';
    wait; 
  end process;

  -- Monitoramento e verificação do comportamento do processador
  -- Especificamente, verifica se o valor 7 foi escrito no endereço 84
  process (clk)
    variable addr_int: integer;
    variable writedata_int: integer;
  begin
    if falling_edge(clk) then
      if memwrite = '1' then
        -- Converte os sinais addr e writedata_B para inteiros para facilitar a verificação
        addr_int := to_integer(unsigned(addr));
        writedata_int := to_integer(signed(writedata_B));
        
        -- Verifica se o dado foi escrito no endereço 84
        if (addr_int = 84 and writedata_int = 7) then
          report "Sem erros: Sucesso" severity failure;
        elsif (addr_int /= 80) then
          report "Simulacao falhou!" severity failure;
        end if;
      end if;
    end if;
  end process;

end test;
      
