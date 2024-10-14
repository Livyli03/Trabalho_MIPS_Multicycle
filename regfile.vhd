library IEEE; 
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_std.all;

------------ Register File ------------------------
--                                                  -
-- Entradas:                                        -
--   clk (1 bits): clock para sincronizar escrita.  -                                  
--   we3 (1 bits): sinal de habilitação de escrita. -
--   r1a e ra2 (5 bits): endereços de leitura.      -
--   wa3 (5 bits): endereço de escrita.             -
--   wd3 (32 bits): dados a serem escritos.         -
-- Saídas:                                          -
--   rd1 e rd2 (32 bits): portas de leitura.        -
--                                                  -
-- Implementa uma memória com 32 palavras de 32 bits-
-- com capacidade de gravação sincronizada e leitura-
-- combinational para duas portas.                  -
-- Para mais detalhes, estude a seção 7.1.1 e 7.1.2 - 
-- do livro indicado.                               - 
----------------------------------------------------

-- Nao altere esse módulo, ele ja foi testado e 
-- funciona corretamente. Apenas estude-o.

-- Register file com duas portas de leitura e uma porta de escrita
entity regfile is 
  port(clk:           in  STD_LOGIC;
       we3:           in  STD_LOGIC;
       ra1, ra2, wa3: in  STD_LOGIC_VECTOR(4 downto 0);   -- ra1 e ra2: endereços p/ leitura; wa3: endereco p/ escrita
       wd3:           in  STD_LOGIC_VECTOR(31 downto 0);  -- conteudo a ser gravado no endereco wa3
       rd1, rd2:      out STD_LOGIC_VECTOR(31 downto 0)); -- portas de leitura: rd1 associado a ra1 e rd2 associado ra2
end;

architecture synth of regfile is
  type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0); -- 32 registradores de 32 bits
  signal mem: ramtype;
begin
  -- escrita sincronizada na borda de subida do sinal de clock
  process(clk) begin
    if rising_edge(clk) then
       if we3 = '1' then 
		    mem(to_integer(unsigned(wa3))) <= wd3;
       end if;
    end if;
  end process;
  
  -- leitura combinacional para rd1 e rd2 a partir dos enderecos ra1 e ra2
  -- registrador 0 sempre em 0
  process(all) begin
    if (to_integer(unsigned(ra1)) = 0) then 
	     rd1 <= X"00000000"; -- registrador 0 sempre em 0
    else 
	     rd1 <= mem(to_integer(unsigned(ra1)));
    end if;
    
	 if (to_integer(unsigned(ra2)) = 0) then 
	    rd2 <= X"00000000";  -- registrador 0 sempre em 0
    else 
	    rd2 <= mem(to_integer(unsigned(ra2)));
    end if;
  end process;
end synth;