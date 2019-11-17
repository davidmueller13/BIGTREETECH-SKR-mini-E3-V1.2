#!/bin/sh
#
# SKR mini E3   Marlin 2.0   firmware build script
#
# Copyright (c) 2019 Pascal de Bruijn
#



VENV_DIR=PlatformIO
MARLIN_DIR=Marlin



python3 -m venv ${VENV_DIR}

./${VENV_DIR}/bin/pip install -U platformio --no-cache-dir



git clone https://github.com/MarlinFirmware/Marlin ${MARLIN_DIR}

git -C ${MARLIN_DIR} checkout bugfix-2.0.x
git -C ${MARLIN_DIR} describe --tags



sed -i 's@\[platformio\]@\[platformio\]\ncore_dir = PlatformIO@' ${MARLIN_DIR}/platformio.ini

sed -i 's@default_envs.*=.*@default_envs = STM32F103RC_bigtree_512K@' ${MARLIN_DIR}/platformio.ini



cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/Configuration.h ${MARLIN_DIR}/Marlin
cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/Configuration_adv.h ${MARLIN_DIR}/Marlin
cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/_Bootscreen.h ${MARLIN_DIR}/Marlin
cp ${MARLIN_DIR}/config/examples/Creality/Ender-3/_Statusscreen.h ${MARLIN_DIR}/Marlin



sed -i 's@#define SERIAL_PORT .*@#define SERIAL_PORT 2@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/*#define SERIAL_PORT_2 .*@#define SERIAL_PORT_2 -1@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@#define BAUDRATE .*@#define BAUDRATE 115200@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@ *#define MOTHERBOARD .*@  #define MOTHERBOARD BOARD_BTT_SKR_MINI_E3_V1_2@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/*#define X_DRIVER_TYPE .*@#define X_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define Y_DRIVER_TYPE .*@#define Y_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define Z_DRIVER_TYPE .*@#define Z_DRIVER_TYPE  TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define E0_DRIVER_TYPE .*@#define E0_DRIVER_TYPE TMC2209@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@/.*#define CR10_STOCKDISPLAY@#define CR10_STOCKDISPLAY@' ${MARLIN_DIR}/Marlin/Configuration.h

sed -i 's@#define SPEAKER@//#define SPEAKER@' ${MARLIN_DIR}/Marlin/Configuration.h



# discovered from BigTreeTech reference firmware sources
sed -i 's@#if HAS_TMC220x && !defined(TARGET_LPC1768) && ENABLED(ENDSTOP_INTERRUPTS_FEATURE)@& \&\& !defined(TARGET_STM32F1)@g' ${MARLIN_DIR}/Marlin/src/inc/SanityCheck.h
sed -i 's@/*#define ENDSTOP_INTERRUPTS_FEATURE@#define ENDSTOP_INTERRUPTS_FEATURE@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@//#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define FAN_SOFT_PWM@#define FAN_SOFT_PWM@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define TMC_DEBUG@#define TMC_DEBUG@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# personal tweaks
sed -i 's@#define STRING_CONFIG_H_AUTHOR .*@#define STRING_CONFIG_H_AUTHOR "(SKR mini E3)"@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define CUSTOM_MACHINE_NAME .*@#define CUSTOM_MACHINE_NAME "SKR mini E3"@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define SHOW_BOOTSCREEN@//#define SHOW_BOOTSCREEN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define SHOW_CUSTOM_BOOTSCREEN@//#define SHOW_CUSTOM_BOOTSCREEN@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define CUSTOM_STATUS_SCREEN_IMAGE@//#define CUSTOM_STATUS_SCREEN_IMAGE@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LEVEL_BED_CORNERS@#define LEVEL_BED_CORNERS@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LEVEL_CORNERS_INSET .*@  #define LEVEL_CORNERS_INSET 33@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define S_CURVE_ACCELERATION@#define S_CURVE_ACCELERATION@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define LIN_ADVANCE@#define LIN_ADVANCE@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define LIN_ADVANCE_K .*@  #define LIN_ADVANCE_K 0@g' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define LCD_SET_PROGRESS_MANUALLY@#define LCD_SET_PROGRESS_MANUALLY@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define DOGM_SD_PERCENT@  #define DOGM_SD_PERCENT@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define FILAMENT_LOAD_UNLOAD_GCODES@  #define FILAMENT_LOAD_UNLOAD_GCODES  @' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define SENSORLESS_HOMING@  #define SENSORLESS_HOMING@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# prevent bed demagnetization
sed -i 's@#define BED_MAXTEMP .*@#define BED_MAXTEMP      80@g' ${MARLIN_DIR}/Marlin/Configuration.h



# add a little more safety
sed -i 's@#define HEATER_0_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define HEATER_1_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define HEATER_2_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define HEATER_3_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define HEATER_4_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define HEATER_5_MAXTEMP 275@#define HEATER_0_MAXTEMP 265@g' ${MARLIN_DIR}/Marlin/Configuration.h



# modernize pla preset
sed -i 's@#define PREHEAT_1_TEMP_HOTEND .*@#define PREHEAT_1_TEMP_HOTEND 205@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@#define PREHEAT_1_TEMP_BED .*@#define PREHEAT_1_TEMP_BED     60@g' ${MARLIN_DIR}/Marlin/Configuration.h



# bltouch probe on probe connector
sed -i 's@/*#define BLTOUCH@#define BLTOUCH@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define LCD_BED_LEVELING@#define LCD_BED_LEVELING@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define AUTO_BED_LEVELING_BILINEAR@#define AUTO_BED_LEVELING_BILINEAR@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define NOZZLE_TO_PROBE_OFFSET .*@#define NOZZLE_TO_PROBE_OFFSET { -44, -6, 0 }@' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@/*#define MIN_PROBE_EDGE .*@#define MIN_PROBE_EDGE 44@g' ${MARLIN_DIR}/Marlin/Configuration.h
sed -i 's@.*#define BABYSTEP_MULTIPLICATOR_Z .*@  #define BABYSTEP_MULTIPLICATOR_Z 5@' ${MARLIN_DIR}/Marlin/Configuration_adv.h
sed -i 's@.*#define BABYSTEP_MULTIPLICATOR_XY .*@  #define BABYSTEP_MULTIPLICATOR_XY 5@' ${MARLIN_DIR}/Marlin/Configuration_adv.h



# bltouch probe on z-endstop connector
#sed -i 's@/*#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@#define Z_MIN_PROBE_USES_Z_MIN_ENDSTOP_PIN@' ${MARLIN_DIR}/Marlin/Configuration.h
#sed -i 's@/*#define Z_SAFE_HOMING@#define Z_SAFE_HOMING@' ${MARLIN_DIR}/Marlin/Configuration.h



# debugging
#sed -i 's@/*#define MIN_SOFTWARE_ENDSTOP_Z@//#define MIN_SOFTWARE_ENDSTOP_Z@' ${MARLIN_DIR}/Marlin/Configuration.h
#sed -i 's@/*#define DEBUG_LEVELING_FEATURE@#define DEBUG_LEVELING_FEATURE@g' ${MARLIN_DIR}/Marlin/Configuration.h


(cd ${MARLIN_DIR}; ../${VENV_DIR}/bin/platformio run)



ls -lh ${MARLIN_DIR}/.pio/build/*/firmware.bin
