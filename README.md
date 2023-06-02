# General-UART
**1). Basic Description:** The "General UART" is an implementation of a soft UART module that can be deployed on Xilinx FPGAs and can be used to interface other soft-core microcontrollers or other computing module with outside devices. The UART provides transceiving capability at baud rates that are even integer divisibles of 11059200, for e.g. 11059200, 5529600, 921600, 115200, 19200, and 9600.

**2). Parameter Description:** These instantiation parameters are used to initalize the UART module based on the respective system clock signal and the required baudrate. The parameters are:

2.1). SYSTM_OPERN_FREQ: This parameter provides the information of the operation frequency of the microcontroller or any other device that is driving the UART to transmit/receive data serially.

2.2). REQD_BAUD_RATE: This parameter provides the information about the baudrate that is required for exchange of data betweeen the UART module driving device and the other device.

**3). Pin Description:** These are the pins required to interface the UART module with the device driving it, to provide the configuration as well as data input for transmission and data input from the external device. It also provides the data serial transmission output:

3.1). clock             : This is the clock signal from the system driving the UART module.

3.2). tx_no_bytes       : This is a 10-bit input array, used to configure the amount of bytes of data that has to be trasnmitted from the UART module. This is configured in real time by the driving device.

3.3). tx_data_byte      : This is the byte of data to be transmitted provided by the driving device.

3.4). tx_data_valid     : This input signal indicates whether the provided byte of data is valid for transmission. Any number of new bytes, even exceeding the determined amount of bytes, can be transmitted as long as this signal is HIGH. If this signal is pulled LOW before the transmission of all the bytes given by "tx_no_bytes" is completed, any further data transmission won't be completed.

3.5). tx_ser_data_out   : This is the serial data output of the transmitter.

3.6). rx_no_bytes       : This is a 10-bit input array, used to configure the amount of bytes of data that has to be received from the UART module. This is configured in real time by the driving device.

3.7). rx_ser_data_in    :  This is the serial data input to the receiver.

3.8). output       rx_data_valid: This output signal indicates whether the received byte of data is valid for processing by the driving device. Any number of new bytes.

3.9). rx_data_byte      : This is the byte of data to be received by the driving device.

    
