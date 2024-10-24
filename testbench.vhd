library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity testbench is
end testbench;

architecture test of testbench is
  -- Instância do componente comp
  component comp
    port(clk, reset:          in  STD_LOGIC;
         writedata_B, addr:   out STD_LOGIC_VECTOR(31 downto 0);
         memwrite:            out STD_LOGIC);
  end component;

  signal writedata_B, addr:    STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset,  memwrite: STD_LOGIC;

begin
  -- Instancie o componente comp (MIPS multi-ciclo com memória)
  dut: comp
    port map(clk        => clk,
             reset      => reset,
             writedata_B => writedata_B,
             addr       => addr,
             memwrite   => memwrite);

  -- Geração do clock com período de 10 ns
  process begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
  end process;

  -- Processo de reset (sinal de reset ativo nos primeiros 22 ns)
  process begin
    reset <= '1';
    wait for 22 ns;
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
