library IEEE; 
use IEEE.STD_LOGIC_1164.all;  

-- Use esse componente para gravar apenas com habilitaçãp.
-- Use generic map para fazer a instanciação.

-- Nao altere esse módulo, ele ja foi testado e 
-- funciona corretamente. Apenas estude-o.


entity regenable is 
  generic(width: integer);
  port(clk, enable, reset: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
       q:          out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture synth of regenable is
begin
  process(clk, enable, reset) begin
    if reset = '1' then  
      q <= (others => '0');
    elsif enable = '1' and rising_edge(clk) then
        q <= d;
    end if;
  end process;
end;
