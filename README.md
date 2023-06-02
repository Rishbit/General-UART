# General-UART
**1). Basic Description:** The "General UART" is an implementation of a soft-computing UART module that can be deployed on Xilinx FPGAs and can be used for interfacing other sotf-core microcontrollers and other computing module with outside devices. The UART provides transceiving capability at integer divisibles of 11059200 baudrate, for e.g. 11059200, 5529600, 921600, 115200, 19200, and 9600.

**2). Parameter Description:** These instantiation parameters are used to initalize the UART module based on the respective system clock signal and the required baudrate. The parameters are:

**2.1). SYSTM_OPERN_FREQ:** This parameter provides the information of the operation frequency of the microcontroller or any other device that is driving the UART to transmit/receive data serially.

**2.2). REQD_BAUD_RATE:** This parameter provides the information of the baudrate required for data transmission/reception between the driving device and the module with which data has to be exchanged.
