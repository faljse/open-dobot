rem Replace with were Arduino is installed in your system.
SET AVR_DIR=C:\Program Files (x86)\Arduino\hardware\tools\avr
SET SERIAL_PORT=COM5

SET SRC_MAIN=..\src\main
SET SRC_FPGA=..\src\fpga
SET BUILD=..\build

"%AVR_DIR%\bin\avr-g++" -O -DF_CPU=16000000UL -mmcu=atmega2560 -c -o %BUILD%\dobot.o %SRC_MAIN%\dobot.cpp 
"%AVR_DIR%\bin\avr-g++" -O -DF_CPU=16000000UL -DRAMPS -mmcu=atmega2560 -c -o %BUILD%\calibrator.o %SRC_MAIN%\misc\calibrator.cpp 
"%AVR_DIR%\bin\avr-g++" -O -DF_CPU=16000000UL -DRAMPS -mmcu=atmega2560 -c -o %BUILD%\queue.o %SRC_MAIN%\misc\queue.cpp 
"%AVR_DIR%\bin\avr-g++" -O -DF_CPU=16000000UL -mmcu=atmega2560 -c -o %BUILD%\fpga.o %SRC_FPGA%\fpga.cpp 
"%AVR_DIR%\bin\avr-g++" -mmcu=atmega2560 %BUILD%\dobot.o %BUILD%\fpga.o %BUILD%\calibrator.o %BUILD%\queue.o -o %BUILD%\dobot 
"%AVR_DIR%\bin\avr-objcopy" -O ihex -R .eeprom %BUILD%\dobot %BUILD%\dobot-fpga.hex 
"%AVR_DIR%\bin\avrdude" -C"%AVR_DIR%\etc\avrdude.conf" -patmega2560 -cwiring -P%SERIAL_PORT% -b115200 -D -Uflash:w:%BUILD%\dobot-fpga.hex:i
