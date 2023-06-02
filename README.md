# General-UART
**1). Basic Description:** The "General UART" is an implementation of a soft-computing UART module that can be deployed on Xilinx FPGAs and can be used for interfacing other sotf-core microcontrollers and other computing module with outside devices. The UART provides transceiving capability at integer divisibles of 11059200 baudrate, for e.g. 11059200, 5529600, 921600, 115200, 19200, and 9600.

**2). Parameter Description:** These instantiation parameters are used to initalize the UART module based on the respective system clock signal and the required baudrate. The parameters are:

2.1). SYSTM_OPERN_FREQ: This parameter provides the information of the operation frequency of the microcontroller or any other device that is driving the UART to transmit/receive data serially.

2.2). REQD_BAUD_RATE: This parameter provides the information about the baudrate that is required for exchange of data betweeen the UART module driving device and the other device.

**3). Pin Description:** These are the pins required to interface the UART module with the device driving it, to provide the configuration as well as data input for transmission and data input from the external device. It also provides the data serial transmission output:

3.1). clock       :   This is the clock signal from the system driving the UART module.
3.2). tx_no_bytes :   This is a 10-bit input array, used to configure the amount of bytes of data that has to be trasnmitted from the UART module. This can                     be configured in real time by the driving device.
3.3). input  [7:0] tx_data_byte: 
3.4). input        tx_data_valid;
3.5). output       tx_ser_data_out;
3.6). input  [9:0] rx_no_bytes;
3.7). input        rx_ser_data_in;
3.8). output       rx_data_valid;
3.9). output [7:0] rx_data_byte;
    
