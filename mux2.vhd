library IEEE; 
use IEEE.STD_LOGIC_1164.all;

-- Multiplexador de duas entradas de width bits.
-- Use generic map para fazer o mapeamento de portas.

-- Nao altere esse módulo, ele ja foi testado e 
-- funciona corretamente. Apeas estude-o.

entity mux2 is 
  generic(width: integer);
  port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
       s:      in  STD_LOGIC;
       y:      out STD_LOGIC_VECTOR(width-1 downto 0));
end;

architecture synth of mux2 is
begin
  y <= d1 when s = '1' else d0;
end;