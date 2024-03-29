-- generated by Digital. Don't modify this file!
-- Any changes will be lost if this file is regenerated.

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity DIG_RAMDualPort is
  generic (
    Bits : integer;       
    AddrBits : integer ); 
  port (
    D: out std_logic_vector ((Bits-1) downto 0);
    A: in std_logic_vector ((AddrBits-1) downto 0);
    Din: in std_logic_vector ((Bits-1) downto 0);
    str: in std_logic;
    C: in std_logic;
    ld: in std_logic );
end DIG_RAMDualPort;

architecture Behavioral of DIG_RAMDualPort is
    -- CAUTION: uses distributed RAM
    type memoryType is array(0 to (2**AddrBits)-1) of STD_LOGIC_VECTOR((Bits-1) downto 0);
    signal memory : memoryType;
begin
  process ( C )
  begin
    if rising_edge(C) AND (str='1') then
      memory(to_integer(unsigned(A))) <= Din;
    end if;
  end process;
  D <= memory(to_integer(unsigned(A))) when ld='1' else (others => 'Z');
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity DIG_Add is
  generic ( Bits: integer ); 
  port (
    s: out std_logic_vector((Bits-1) downto 0);
    c_o: out std_logic;
    a: in std_logic_vector((Bits-1) downto 0);
    b: in std_logic_vector((Bits-1) downto 0);
    c_i: in std_logic );
end DIG_Add;

architecture Behavioral of DIG_Add is
   signal temp : std_logic_vector(Bits downto 0);
begin
   temp <= ('0' & a) + b + c_i;

   s    <= temp((Bits-1) downto 0);
   c_o  <= temp(Bits);
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;



entity DIG_BitExtender is
  generic ( inputBits  : integer;  
            outputBits : integer); 
  port (
    p_in: in std_logic_vector ((inputBits-1) downto 0);
    p_out: out std_logic_vector ((outputBits-1) downto 0) );
end DIG_BitExtender;

architecture DIG_BitExtender_arch of DIG_BitExtender is
begin
    p_out((inputBits-2) downto 0) <= p_in((inputBits-2) downto 0);
    p_out((outputBits-1) downto (inputBits-1)) <= (others => p_in(inputBits-1));
end DIG_BitExtender_arch;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity DIG_RegisterFile is
  generic (
    Bits : integer;       
    AddrBits : integer ); 
  port (
    Da: out std_logic_vector ((Bits-1) downto 0);
    Db: out std_logic_vector ((Bits-1) downto 0);
    Din: in std_logic_vector ((Bits-1) downto 0);
    we: in std_logic;
    Rw: in std_logic_vector ((AddrBits-1) downto 0);
    C: in std_logic;
    Ra: in std_logic_vector ((AddrBits-1) downto 0);
    Rb: in std_logic_vector ((AddrBits-1) downto 0) );
end DIG_RegisterFile;

architecture Behavioral of DIG_RegisterFile is
    type memoryType is array(0 to (2**AddrBits)-1) of STD_LOGIC_VECTOR((Bits-1) downto 0);
    signal memory : memoryType;
begin
  process ( C )
  begin
    if rising_edge(C) AND (we='1') then
      memory(to_integer(unsigned(Rw))) <= Din;
    end if;
  end process;
  Da <= memory(to_integer(unsigned(Ra)));
  Db <= memory(to_integer(unsigned(Rb)));
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity MUX_GATE_BUS_1 is
  generic ( Bits : integer ); 
  port (
    p_out: out std_logic_vector ((Bits-1) downto 0);
    sel: in std_logic;
    
    in_0: in std_logic_vector ((Bits-1) downto 0);
    in_1: in std_logic_vector ((Bits-1) downto 0) );
end MUX_GATE_BUS_1;

architecture Behavioral of MUX_GATE_BUS_1 is
begin
  with sel select
    p_out <=
      in_0 when '0',
      in_1 when '1',
      (others => '0') when others;
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ControlUnit is
  port (
    Fl: in std_logic_vector(3 downto 0);
    Op: in std_logic_vector(5 downto 0);
    Fu: in std_logic_vector(4 downto 0);
    Br: out std_logic;
    We: out std_logic;
    A: out std_logic;
    Ld: out std_logic;
    Str: out std_logic;
    Jmp: out std_logic;
    En: out std_logic;
    Ctrl: out std_logic_vector(4 downto 0);
    push: out std_logic;
    pop: out std_logic);
end ControlUnit;

architecture Behavioral of ControlUnit is
  signal A_temp: std_logic;
  signal Ld_temp: std_logic;
  signal s0: std_logic_vector(4 downto 0);
  signal Jmp_temp: std_logic;
  signal s1: std_logic;
  signal s2: std_logic;
  signal push_temp: std_logic;
  signal s3: std_logic;
  signal s4: std_logic;
  signal s5: std_logic;
  signal pop_temp: std_logic;
  signal s6: std_logic;
begin
  s0 <= Op(4 downto 0);
  Jmp_temp <= Op(5);
  s4 <= s0(0);
  s2 <= s0(1);
  s1 <= s0(2);
  s5 <= s0(3);
  s3 <= s0(4);
  push_temp <= (Jmp_temp AND NOT s3 AND NOT s5 AND s1 AND s2 AND NOT s4);
  pop_temp <= (Jmp_temp AND NOT s3 AND NOT s5 AND s1 AND s2 AND s4);
  s6 <= NOT (s4 OR s2 OR s1 OR s5 OR s3 OR Jmp_temp);
  Ld_temp <= (NOT Jmp_temp AND NOT s3 AND NOT s5 AND NOT s1 AND NOT s2 AND s4);
  Str <= (NOT Jmp_temp AND NOT s3 AND NOT s5 AND NOT s1 AND s2 AND NOT s4);
  Br <= ((Jmp_temp AND NOT s3 AND NOT s5 AND NOT s1 AND NOT s2 AND s4 AND Fl(3)) OR (Jmp_temp AND NOT s3 AND NOT s5 AND NOT s1 AND s2 AND NOT s4 AND Fl(2)) OR (Jmp_temp AND NOT s3 AND NOT s5 AND NOT s1 AND s2 AND s4 AND Fl(1)) OR (Jmp_temp AND NOT s3 AND NOT s5 AND s1 AND NOT s2 AND NOT s4 AND Fl(0)) OR (Jmp_temp AND NOT s3 AND NOT s5 AND s1 AND NOT s2 AND s4));
  En <= (push_temp OR pop_temp);
  A_temp <= (s6 AND NOT Fu(4) AND Fu(3) AND NOT Fu(2) AND NOT Fu(1) AND Fu(0));
  gate0: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 5)
    port map (
      sel => s6,
      in_0 => s0,
      in_1 => Fu,
      p_out => Ctrl);
  We <= ((NOT Jmp_temp AND NOT s3 AND s5 AND NOT s1 AND NOT s2 AND s4) OR A_temp OR Ld_temp);
  A <= A_temp;
  Ld <= Ld_temp;
  Jmp <= Jmp_temp;
  push <= push_temp;
  pop <= pop_temp;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity DIG_Register_BUS is
  generic ( Bits: integer ); 
  port (
    Q: out std_logic_vector ((Bits-1) downto 0);
    D: in std_logic_vector ((Bits-1) downto 0);
    C: in std_logic;
    en: in std_logic );
end DIG_Register_BUS;

architecture Behavioral of DIG_Register_BUS is
  signal state : std_logic_vector ((Bits-1) downto 0) := (others => '0');
begin
   Q <= state;

   process ( C )
   begin
      if rising_edge(C) and (en='1') then
        state <= D;
      end if;
   end process;
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity COMP_GATE_UNSIGNED is
  generic ( Bits : integer );
  port (
    gr: out std_logic;
    eq: out std_logic;
    le: out std_logic;
    a: in std_logic_vector ((Bits-1) downto 0);
    b: in std_logic_vector ((Bits-1) downto 0) );
end COMP_GATE_UNSIGNED;

architecture Behavioral of COMP_GATE_UNSIGNED is
begin
  process(a, b)
  begin
    if (a > b ) then
      le <= '0';
      eq <= '0';
      gr <= '1';
    elsif (a < b) then
      le <= '1';
      eq <= '0';
      gr <= '0';
    else
      le <= '0';
      eq <= '1';
      gr <= '0';
    end if;
  end process;
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ADD is
  port (
    a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end ADD;

architecture Behavioral of ADD is
  signal s0: std_logic_vector(15 downto 0);
  signal s1: std_logic;
  signal s2: std_logic;
  signal s3: std_logic;
begin
  gate0: entity work.DIG_Add
    generic map (
      Bits => 16)
    port map (
      a => a,
      b => b,
      c_i => '0',
      s => s0,
      c_o => s1);
  gate1: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s0,
      eq => s3);
  s2 <= s0(15);
  p_out(15 downto 0) <= s0;
  p_out(16) <= ((s2 AND NOT a(15) AND NOT b(15)) OR (NOT s2 AND b(15) AND a(15)));
  p_out(17) <= s1;
  p_out(18) <= s2;
  p_out(19) <= s3;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

entity DIG_Sub is
  generic ( Bits: integer ); 
  port (
    s: out std_logic_vector((Bits-1) downto 0);
    c_o: out std_logic;
    a: in std_logic_vector((Bits-1) downto 0);
    b: in std_logic_vector((Bits-1) downto 0);
    c_i: in std_logic );
end DIG_Sub;

architecture Behavioral of DIG_Sub is
   signal temp : std_logic_vector(Bits downto 0);
begin
   temp <= ('0' & a) - b - c_i;

   s    <= temp((Bits-1) downto 0);
   c_o  <= temp(Bits);
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity SUB is
  port (
    a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end SUB;

architecture Behavioral of SUB is
  signal s0: std_logic_vector(15 downto 0);
  signal s1: std_logic;
  signal s2: std_logic;
  signal s3: std_logic;
begin
  gate0: entity work.DIG_Sub
    generic map (
      Bits => 16)
    port map (
      a => a,
      b => b,
      c_i => '0',
      s => s0,
      c_o => s1);
  gate1: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s0,
      eq => s3);
  s2 <= s0(15);
  p_out(15 downto 0) <= s0;
  p_out(16) <= (NOT (s2 XOR b(15)) AND (b(15) XOR a(15)));
  p_out(17) <= s1;
  p_out(18) <= s2;
  p_out(19) <= s3;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;



entity DIG_Mul_signed is
  generic ( Bits: integer ); 
  port (
    a: in std_logic_vector ((Bits-1) downto 0);
    b: in std_logic_vector ((Bits-1) downto 0);
    mul: out std_logic_vector ((Bits*2-1) downto 0) );
end DIG_Mul_signed;

architecture Behavioral of DIG_Mul_signed is
begin
    
    mul <= std_logic_vector(signed(a) * signed(b));
    
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity MUL is
  port (
    a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end MUL;

architecture Behavioral of MUL is
  signal s0: std_logic_vector(15 downto 0);
  signal s1: std_logic;
  signal s2: std_logic;
  signal s3: std_logic_vector(31 downto 0);
  signal s4: std_logic_vector(15 downto 0);
  signal s5: std_logic;
  signal s6: std_logic;
begin
  gate0: entity work.DIG_Mul_signed
    generic map (
      Bits => 16)
    port map (
      a => a,
      b => b,
      mul => s3);
  s1 <= s3(15);
  s4 <= s3(31 downto 16);
  s0 <= s3(15 downto 0);
  gate1: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s0,
      eq => s2);
  gate2: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s4,
      eq => s5);
  gate3: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "1111111111111111",
      b => s4,
      eq => s6);
  p_out(15 downto 0) <= s0;
  p_out(16) <= ((NOT a(15) AND NOT b(15) AND s1) OR (NOT a(15) AND b(15) AND NOT s1) OR (NOT s6 AND NOT s5) OR (a(15) AND NOT b(15) AND NOT s1) OR (a(15) AND b(15) AND s1));
  p_out(17) <= '0';
  p_out(18) <= s1;
  p_out(19) <= s2;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity p_AND is
  port (
    a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end p_AND;

architecture Behavioral of p_AND is
  signal s0: std_logic_vector(15 downto 0);
  signal s1: std_logic;
begin
  s0 <= (a AND b);
  gate0: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s0,
      eq => s1);
  p_out(15 downto 0) <= s0;
  p_out(16) <= '0';
  p_out(17) <= '0';
  p_out(18) <= s0(15);
  p_out(19) <= s1;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity p_OR is
  port (
    a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end p_OR;

architecture Behavioral of p_OR is
  signal s0: std_logic_vector(15 downto 0);
  signal s1: std_logic;
begin
  s0 <= (a OR b);
  gate0: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s0,
      eq => s1);
  p_out(15 downto 0) <= s0;
  p_out(16) <= '0';
  p_out(17) <= '0';
  p_out(18) <= s0(15);
  p_out(19) <= s1;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity p_XOR is
  port (
    a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end p_XOR;

architecture Behavioral of p_XOR is
  signal s0: std_logic_vector(15 downto 0);
  signal s1: std_logic;
begin
  s0 <= (a XOR b);
  gate0: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s0,
      eq => s1);
  p_out(15 downto 0) <= s0;
  p_out(16) <= '0';
  p_out(17) <= '0';
  p_out(18) <= s0(15);
  p_out(19) <= s1;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity p_NOT is
  port (
    a: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end p_NOT;

architecture Behavioral of p_NOT is
  signal s0: std_logic_vector(15 downto 0);
  signal s1: std_logic;
begin
  s0 <= NOT a;
  gate0: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s0,
      eq => s1);
  p_out(15 downto 0) <= s0;
  p_out(16) <= '0';
  p_out(17) <= '0';
  p_out(18) <= s0(15);
  p_out(19) <= s1;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity CMP is
  port (
    a: in std_logic_vector(15 downto 0);
    b: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end CMP;

architecture Behavioral of CMP is
  signal s0: std_logic;
  signal s1: std_logic;
begin
  gate0: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => a,
      b => b,
      eq => s0,
      le => s1);
  p_out(15 downto 0) <= "0000000000000000";
  p_out(16) <= '0';
  p_out(17) <= '0';
  p_out(18) <= s1;
  p_out(19) <= s0;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity INC is
  port (
    a: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end INC;

architecture Behavioral of INC is
  signal s0: std_logic_vector(15 downto 0);
begin
  s0(0) <= '1';
  s0(15 downto 1) <= "000000000000000";
  gate0: entity work.ADD
    port map (
      a => a,
      b => s0,
      p_out => p_out);
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity DEC is
  port (
    a: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end DEC;

architecture Behavioral of DEC is
  signal s0: std_logic_vector(15 downto 0);
begin
  s0(0) <= '1';
  s0(15 downto 1) <= "000000000000000";
  gate0: entity work.SUB
    port map (
      a => a,
      b => s0,
      p_out => p_out);
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity THROUGH is
  port (
    a: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end THROUGH;

architecture Behavioral of THROUGH is
begin
  p_out(15 downto 0) <= a;
  p_out(16) <= '0';
  p_out(17) <= '0';
  p_out(18) <= '0';
  p_out(19) <= '0';
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity DIG_Register is
  
  port (
    Q: out std_logic;
    D: in std_logic;
    C: in std_logic;
    en: in std_logic );
end DIG_Register;

architecture Behavioral of DIG_Register is
  signal state : std_logic := '0';
begin
   Q <= state;

   process ( C )
   begin
      if rising_edge(C) and (en='1') then
        state <= D;
      end if;
   end process;
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity DRIVER_INV_GATE_BUS is
  generic ( Bits : integer ); 
  port (
    p_out: out std_logic_vector ((Bits-1) downto 0);
    p_in: in std_logic_vector ((Bits-1) downto 0);
    sel: in std_logic );
end DRIVER_INV_GATE_BUS;

architecture Behavioral of DRIVER_INV_GATE_BUS is
begin
  p_out <= p_in when sel = '1' else (others => 'Z');
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;

entity DRIVER_INV_GATE is
  
  port (
    p_out: out std_logic;
    p_in: in std_logic;
    sel: in std_logic );
end DRIVER_INV_GATE;

architecture Behavioral of DRIVER_INV_GATE is
begin
  p_out <= p_in when sel = '1' else 'Z';
end Behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity LogicShiftLeft_LSL is
  port (
    CLK: in std_logic;
    A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end LogicShiftLeft_LSL;

architecture Behavioral of LogicShiftLeft_LSL is
  signal s0: std_logic;
  signal s1: std_logic_vector(15 downto 0);
  signal s2: std_logic_vector(15 downto 0);
  signal s3: std_logic_vector(15 downto 0);
  signal s4: std_logic_vector(14 downto 0);
  signal s5: std_logic_vector(15 downto 0);
  signal s6: std_logic_vector(15 downto 0);
  signal s7: std_logic_vector(15 downto 0);
  signal s8: std_logic_vector(19 downto 0);
  signal s9: std_logic;
  signal s10: std_logic_vector(15 downto 0);
  signal s11: std_logic;
  signal s12: std_logic;
  signal s13: std_logic;
begin
  gate0: entity work.DIG_Register
    port map (
      D => CLK,
      C => CLK,
      en => '1',
      Q => s0);
  gate1: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => A,
      in_1 => s3,
      p_out => s1);
  gate2: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => B,
      in_1 => s7,
      p_out => s5);
  gate3: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s1,
      C => CLK,
      en => '1',
      Q => s2);
  gate4: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s5,
      C => CLK,
      en => '1',
      Q => s6);
  gate5: entity work.DEC
    port map (
      a => s6,
      p_out => s8);
  s4 <= s2(15 downto 1);
  s3(14 downto 0) <= s4;
  s3(15) <= s4(14);
  s7 <= s8(15 downto 0);
  gate6: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s7,
      eq => s9);
  gate7: entity work.DRIVER_INV_GATE_BUS
    generic map (
      Bits => 16)
    port map (
      p_in => s3,
      sel => s9,
      p_out => s10);
  gate8: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s9,
      p_out => s11);
  gate9: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s9,
      p_out => s12);
  gate10: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s10,
      eq => s13);
  p_out(15 downto 0) <= s10;
  p_out(16) <= s11;
  p_out(17) <= s12;
  p_out(18) <= s10(15);
  p_out(19) <= s13;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity LogicShiftRight_LSR is
  port (
    CLK: in std_logic;
    A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end LogicShiftRight_LSR;

architecture Behavioral of LogicShiftRight_LSR is
  signal s0: std_logic;
  signal s1: std_logic_vector(15 downto 0);
  signal s2: std_logic_vector(15 downto 0);
  signal s3: std_logic_vector(15 downto 0);
  signal s4: std_logic_vector(15 downto 0);
  signal s5: std_logic_vector(15 downto 0);
  signal s6: std_logic_vector(15 downto 0);
  signal s7: std_logic_vector(19 downto 0);
  signal s8: std_logic;
  signal s9: std_logic_vector(15 downto 0);
  signal s10: std_logic;
  signal s11: std_logic;
  signal s12: std_logic;
begin
  gate0: entity work.DIG_Register
    port map (
      D => CLK,
      C => CLK,
      en => '1',
      Q => s0);
  gate1: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => A,
      in_1 => s3,
      p_out => s1);
  gate2: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => B,
      in_1 => s6,
      p_out => s4);
  gate3: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s1,
      C => CLK,
      en => '1',
      Q => s2);
  gate4: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s4,
      C => CLK,
      en => '1',
      Q => s5);
  gate5: entity work.DEC
    port map (
      a => s5,
      p_out => s7);
  s3(0) <= '0';
  s3(15 downto 1) <= s2(14 downto 0);
  s6 <= s7(15 downto 0);
  gate6: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s6,
      eq => s8);
  gate7: entity work.DRIVER_INV_GATE_BUS
    generic map (
      Bits => 16)
    port map (
      p_in => s3,
      sel => s8,
      p_out => s9);
  gate8: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s8,
      p_out => s10);
  gate9: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s8,
      p_out => s11);
  gate10: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s9,
      eq => s12);
  p_out(15 downto 0) <= s9;
  p_out(16) <= s10;
  p_out(17) <= s11;
  p_out(18) <= s9(15);
  p_out(19) <= s12;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity RotateShiftLeft_RSL is
  port (
    CLK: in std_logic;
    A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end RotateShiftLeft_RSL;

architecture Behavioral of RotateShiftLeft_RSL is
  signal s0: std_logic;
  signal s1: std_logic_vector(15 downto 0);
  signal s2: std_logic_vector(15 downto 0);
  signal s3: std_logic_vector(15 downto 0);
  signal s4: std_logic_vector(15 downto 0);
  signal s5: std_logic_vector(15 downto 0);
  signal s6: std_logic_vector(15 downto 0);
  signal s7: std_logic_vector(19 downto 0);
  signal s8: std_logic;
  signal s9: std_logic_vector(15 downto 0);
  signal s10: std_logic;
  signal s11: std_logic;
  signal s12: std_logic;
begin
  gate0: entity work.DIG_Register
    port map (
      D => CLK,
      C => CLK,
      en => '1',
      Q => s0);
  gate1: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => A,
      in_1 => s3,
      p_out => s1);
  gate2: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => B,
      in_1 => s6,
      p_out => s4);
  gate3: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s1,
      C => CLK,
      en => '1',
      Q => s2);
  gate4: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s4,
      C => CLK,
      en => '1',
      Q => s5);
  gate5: entity work.DEC
    port map (
      a => s5,
      p_out => s7);
  s3(0) <= s2(15);
  s3(15 downto 1) <= s2(14 downto 0);
  s6 <= s7(15 downto 0);
  gate6: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s6,
      eq => s8);
  gate7: entity work.DRIVER_INV_GATE_BUS
    generic map (
      Bits => 16)
    port map (
      p_in => s3,
      sel => s8,
      p_out => s9);
  gate8: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s8,
      p_out => s10);
  gate9: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s8,
      p_out => s11);
  gate10: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s9,
      eq => s12);
  p_out(15 downto 0) <= s9;
  p_out(16) <= s10;
  p_out(17) <= s11;
  p_out(18) <= s9(15);
  p_out(19) <= s12;
end Behavioral;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity RotateShiftRight_RSR is
  port (
    CLK: in std_logic;
    A: in std_logic_vector(15 downto 0);
    B: in std_logic_vector(15 downto 0);
    p_out: out std_logic_vector(19 downto 0));
end RotateShiftRight_RSR;

architecture Behavioral of RotateShiftRight_RSR is
  signal s0: std_logic;
  signal s1: std_logic_vector(15 downto 0);
  signal s2: std_logic_vector(15 downto 0);
  signal s3: std_logic_vector(15 downto 0);
  signal s4: std_logic_vector(15 downto 0);
  signal s5: std_logic_vector(15 downto 0);
  signal s6: std_logic_vector(15 downto 0);
  signal s7: std_logic_vector(19 downto 0);
  signal s8: std_logic;
  signal s9: std_logic_vector(15 downto 0);
  signal s10: std_logic;
  signal s11: std_logic;
  signal s12: std_logic;
begin
  gate0: entity work.DIG_Register
    port map (
      D => CLK,
      C => CLK,
      en => '1',
      Q => s0);
  gate1: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => A,
      in_1 => s3,
      p_out => s1);
  gate2: entity work.MUX_GATE_BUS_1
    generic map (
      Bits => 16)
    port map (
      sel => s0,
      in_0 => B,
      in_1 => s6,
      p_out => s4);
  gate3: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s1,
      C => CLK,
      en => '1',
      Q => s2);
  gate4: entity work.DIG_Register_BUS
    generic map (
      Bits => 16)
    port map (
      D => s4,
      C => CLK,
      en => '1',
      Q => s5);
  gate5: entity work.DEC
    port map (
      a => s5,
      p_out => s7);
  s3(14 downto 0) <= s2(15 downto 1);
  s3(15) <= s2(0);
  s6 <= s7(15 downto 0);
  gate6: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s6,
      eq => s8);
  gate7: entity work.DRIVER_INV_GATE_BUS
    generic map (
      Bits => 16)
    port map (
      p_in => s3,
      sel => s8,
      p_out => s9);
  gate8: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s8,
      p_out => s10);
  gate9: entity work.DRIVER_INV_GATE
    port map (
      p_in => '0',
      sel => s8,
      p_out => s11);
  gate10: entity work.COMP_GATE_UNSIGNED
    generic map (
      Bits => 16)
    port map (
      a => "0000000000000000",
      b => s9,
      eq => s12);
  p_out(15 downto 0) <= s9;
  p_out(16) <= s10;
  p_out(17) <= s11;
  p_out(18) <= s9(15);
  p_out(19) <= s12;
end Behavioral;
