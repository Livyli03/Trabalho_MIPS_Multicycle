library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--------------------- máquina de estado finito -------------------------
--                                                          -
-- Esse módulo implementa o decodificador principal, que    - 
-- é controlado por uma máquina de estado finito e controla -
-- o datapath e dois sinais para para o módulo aludec       -
--                                                          -
--                                                          -
-- Entradas:                                                -
--   op (6 bits): opcode da instrução.                      -
--   clk: clock.                                            -
-- Saidas:                                                  -
--   op, regdst, memtoreg, regwrite, memwrite, branch       -
--   pcwrite, iord, irwrite, aluop, pcsrc, alusrcA, alusrcB -
--   são sinais que controlam o datapath;                   -
--   aluop alimenta o módulo aludec.                        -
------------------------------------------------------------------------


entity fsm is
    Port ( op 				: in  STD_LOGIC_VECTOR (5 downto 0);
           clk 			    : in  STD_LOGIC;
           reset 		    : in  STD_LOGIC;
           regdst 		    : out  STD_LOGIC;
           memtoreg 		: out  STD_LOGIC;
           regwrite 		: out  STD_LOGIC;
           memwrite 		: out  STD_LOGIC;
		   branch	        : out  STD_LOGIC;
		   pcwrite		    : out  STD_LOGIC;
		   IorD			    : out  STD_LOGIC;
		   irwrite		    : out  STD_LOGIC;
           pcsrc		    : out  STD_LOGIC_VECTOR (1 downto 0);
           alusrcA 		    : out  STD_LOGIC;
           alusrcB		    : out  STD_LOGIC_VECTOR (1 downto 0);
		   aluop 			: out  STD_LOGIC_VECTOR (1 downto 0));
end fsm;

architecture synth of fsm is
--definição dos estados
type tipo_estados is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
signal estado, prox_estado: tipo_estados;
 
begin

  process(clk, reset)
  begin 
    if reset = '1' then
      estado <= S0;
    elsif rising_edge(clk) then 
      estado <= prox_estado;
    end if;
  end process;

  -- lógica de próximo estado
  process(estado, op)
  begin
    case estado is
      when S0 =>
        prox_estado <= S1;

      when S1 =>
        --if lw ou sw
        if (op = "100011" or op = "101011") then 
          prox_estado <= S2;
        --if Tipo-R
        elsif (op = "000000") then 
          prox_estado <= S6;
        --if beq
        elsif (op = "000100") then 
          prox_estado <= S8;
        --if addi
        elsif (op = "001000") then 
          prox_estado <= S9;
        --if jump
        elsif (op = "000010") then 
          prox_estado <= S11;
        end if;

      when S2 =>
        --if lw
        if (op = "100011") then
          prox_estado <= S3;
        else --sw
          prox_estado <= S5;
        end if;

      when S3 => 
        prox_estado <= S4;

      when S4 =>
        prox_estado <= S0;

      when S5 =>
        prox_estado <= S0;

      when S6 =>
        prox_estado <= S7;
    
      when S7 =>
        prox_estado <= S0;

      when S8 =>
        prox_estado <= S0;

      when S9 =>
        prox_estado <= S10;

      when S10 =>
        prox_estado <= S0;

      when S11 =>
        prox_estado <= S0;

      when others =>
        prox_estado <= S0;

    end case;
  end process;

  --saídas dos estados
  process(estado)
  begin
    case estado is
      --fetch de instrução
      when S0 =>
        pcwrite <= '1';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '1';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "01";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
      --fetch de decodificação/registro
      when S1 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "11";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
      --lw/sw executar
      when S2 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "10";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
      --lw acesso de memória
      when S3 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '1';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
	    --lw write back
      when S4 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='1';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='1';
        regdst <= '0';
	    --sw write back
      when S5 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '1';
        memwrite <= '1';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
      --Tipo-R execução
      when S6 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="10";
        alusrcB <= "00";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
      --Tipo-R finalização
      when S7 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='1';
        regdst <= '1';
      --BEQ finalização
      when S8 =>
        pcwrite <= '0';
        branch <= '1';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="01";
        aluop <="01";
        alusrcB <= "00";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
      --addi execução
      when S9 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "10";
        alusrcA <='1';
        regwrite <='0';
        regdst <= '0';
      --addi write back
      when S10 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="00";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='1';
        regdst <= '0';
      --jump
      when S11 =>
        pcwrite <= '0';
        branch <= '0';
        IorD <= '0';
        memwrite <= '0';
        irwrite <= '0';
        memtoreg <='0';
        pcsrc <="10";
        aluop <="00";
        alusrcB <= "00";
        alusrcA <='0';
        regwrite <='0';
        regdst <= '0';
      when others =>
        null;
    end case;
  end process;

end synth;
