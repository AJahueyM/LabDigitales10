----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2021 03:00:52 PM
-- Design Name: 
-- Module Name: main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
  Port (
    clk : in std_logic;
    reset: in std_logic;
    hs, vs : out std_logic
    );
end main;

-- 25.175 Mhz
architecture Behavioral of main is
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  -- Status and control signals
  reset             : in     std_logic;
  locked            : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

component vga_controller IS
  port(
    pixel_clk : IN   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
    reset_n   : IN   STD_LOGIC;  --active low asycnchronous reset
    h_sync    : OUT  STD_LOGIC;  --horiztonal sync pulse
    v_sync    : OUT  STD_LOGIC;  --vertical sync pulse
    disp_ena  : OUT  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    column    : OUT  INTEGER;    --horizontal pixel coordinate
    row       : OUT  INTEGER;    --vertical pixel coordinate
    n_blank   : OUT  STD_LOGIC;  --direct blacking output to DAC
    n_sync    : OUT  STD_LOGIC); --sync-on-green output to DAC
END component;

signal pixel_clock : std_logic := '0';
signal div_locked : std_logic;
signal n_blank : std_logic;
signal n_sync : std_logic;
signal column_int : integer := 0;
signal row_int : integer := 0;
signal n_reset : std_logic;

signal video_on : std_logic;
    
begin
    clock_div : clk_wiz_0
       port map ( 
      -- Clock out ports  
       clk_out1 => pixel_clock,
      -- Status and control signals                
       reset => '0',
       locked => div_locked,
       -- Clock in ports
       clk_in1 => clk
     );
     
    vga : vga_controller
    port map ( 
    -- Clock out ports  
        pixel_clk => pixel_clock,
        reset_n => n_reset,
        h_sync => hs, 
        v_sync => vs,  --vertical sync pulse
        disp_ena => video_on,  --display enable ('1' = display time, '0' = blanking time)
        column => column_int,    --horizontal pixel coordinate
        row  => row_int,    --vertical pixel coordinate
        n_blank => n_blank,  --direct blacking output to DAC
        n_sync  => n_sync --sync-on-green output to DAC
    );
    
    n_reset <= not reset;

end Behavioral;
