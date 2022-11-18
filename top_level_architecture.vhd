----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port (	clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;
		
		motor_l_pwm		: out	std_logic;
		motor_r_pwm		: out	std_logic
end main;

architecture Stuctural of main is
    --component input_buffer
    component input_buffer is
	port (	clk		: in	std_logic;

		sensor_l_in	: in	std_logic;
		sensor_m_in	: in	std_logic;
		sensor_r_in	: in	std_logic;

		sensor_l_out	: out	std_logic;
		sensor_m_out	: out	std_logic;
		sensor_r_out	: out	std_logic
	);
    end component input_buffer;

    --component controller
    component controller is
	port (  clk			: in	std_logic;
		reset			: in	std_logic;

		sensor_l		: in	std_logic;
		sensor_m		: in	std_logic;
		sensor_r		: in	std_logic;

		count_in		: in	std_logic_vector (7 downto 0);
		count_reset		: out	std_logic;

		motor_l_reset		: out	std_logic;
		motor_l_direction	: out	std_logic;

		motor_r_reset		: out	std_logic;
		motor_r_direction	: out	std_logic
	);
	end component controller;
    
    --component counter
    component counter is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;

		count_out	: out	std_logic_vector (7 downto 0)
	);
    end component counter;

    --component pwm_generator
    component pwm_generator is
	port (	clk		: in	std_logic;
		reset		: in	std_logic;
		direction	: in	std_logic;
		count_in	: in	std_logic_vector (7 downto 0);

		pwm		: out	std_logic
	);
    end component pwm_generator;

    -- signal assignments
    signal 	buf_sens_l: std_logic, buf_sens_m: std_logic, buf_sens_r: std_logic,
		cnt_reset: std_logic, cnt: std_logic_vector (7 downto 0),
		mtr_l_rst: std_logic, mtr_l_dir: std_logic, mtr_r_rst: std_logic, mtr_r_dir: std_logic; 
    
begin


    lbl0: input_buffer port map ( 	clk => clk,
					sensor_l_in => sensor_l, sensor_m_in => sensor_m, sensor_r_in => sensor_r,
					sensor_l_out => buf_sens_l, sensor_m_out => buf_sens_m, sensor_r_out => buf_sens_r
                                );
                              
    lbl1: controller port map ( clk => clk, reset => reset, count_in => cnt,
				sensor_l => buf_sens_l, sensor_m => buf_sens_m, sensor_r => buf_sens_r,
				motor_l_reset => mtr_l_rst, motor_l_direction => mtr_l_dir, motor_r_reset => mtr_r_rst, motor_r_direction => mtr_r_dir
                              );     
    lbl2: counter port map (clk => clk, reset => cnt_reset, count_out => cnt);
    lbl3: pwm_generator port map (clk => clk, reset => mtr_l_rst, direction => mtr_l_dir, count_in => cnt, pwm => motor_l_pwm);
    lbl4: pwm_generator port map (clk => clk, reset => mtr_r_rst, direction => mtr_r_dir, count_in => cnt, pwm => motor_r_pwm);

end architecture Stuctural;
