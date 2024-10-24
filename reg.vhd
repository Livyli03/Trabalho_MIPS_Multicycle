library IEEE; 
use IEEE.STD_LOGIC_1164.all;  

-- Use esse componente para registrar um dado.
-- Use generic map para fazer a instanciação.

-- Nao altere esse módulo, ele ja foi testado e 
-- funciona corretamente. Apenas estude-o.


entity reg is 
  generic(width: integer);
  port(clk, reset: in  STD_LOGIC;
       d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
       q:          out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture synth of reg is
begin
  process(clk, reset) begin
    if reset = '1' then  
	    q <= (others => '0');
    elsif rising_edge(clk) then
      q <= d;
    end if;
  end process;
end;
