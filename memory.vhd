library IEEE;  
use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD.all;

entity memory is 
  port(clk, we:  in STD_LOGIC;
       addr:     in STD_LOGIC_VECTOR(31 downto 0);
       wd:       in STD_LOGIC_VECTOR(31 downto 0);
       rd:       out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture synth of memory is
   -- Array de dados (128 palavras de 32 bits)
   type ram_type is array (127 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
   signal mem: ram_type := (
		    0 => x"20020005",  -- Instrução 1
              1 => x"2003000c",  -- Instrução 2
              2 => x"2067fff7",  -- Instrução 3
              3 => x"00e22025",  -- Instrução 4
              4 => x"00642824",  -- Instrução 5
              5 => x"00a42820",  -- Instrução 6
              6 => x"10a7000a",  -- Instrução 7
              7 => x"0064202a",  -- Instrução 8
              8 => x"10800001",  -- Instrução 9
              9 => x"20050000",  -- Instrução 10
              10 => x"00e2202a", -- Instrução 11
              11 => x"00853820", -- Instrução 12
              12 => x"00e23822", -- Instrução 13
              13 => x"ac670044", -- Instrução 14
              14 => x"8c020050", -- Instrução 15
              15 => x"08000011", -- Instrução 16
              16 => x"20020001", -- Instrução 17
              17 => x"ac020054", -- Instrução 18
              others => (others => '0') -- Inicializa o restante com zeros
   );
   
begin
   process(clk)
   begin
      if rising_edge(clk) then  -- A operação ocorre na borda de subida do clock
         -- Converte o endereço para inteiro para comparação
         if we = '1' and to_integer(unsigned(addr(7 downto 2))) >= 18 then  
            -- Escreve o dado 'wd' no endereço 'addr' se estiver após a 18ª instrução
            mem(to_integer(unsigned(addr(7 downto 2)))) <= wd;
         end if;
      end if;
   end process;

   -- Leitura sempre ocorre, o dado lido de 'mem' vai para a saída 'rd'
   rd <= mem(to_integer(unsigned(addr(7 downto 2))));

end synth;
