# 72-Bit-Extended-Hamming-Decoder-for-64-bit-data
This repository hosts the Vivado IP core for an Extended Hamming Code Decoder designed to correct and manage 64-bit data encapsulated in a 72-bit codeword. Ideal for FPGA implementations, this IP core ensures robust error correction and detection, tailored for high-reliability communication systems and data storage applications.

**Overview**

The Extended Hamming Code Decoder IP core is built in Verilog and optimized for integration with Xilinx FPGAs using the Vivado Design Suite. It uses Hamming code properties to efficiently correct single-bit errors and detect up to double-bit errors in each 72-bit codeword, which includes 64 data bits and 8 parity bits. The decoder processes data received serially, making it suitable for environments where data is transmitted or stored serially.



#### Key Features

- **Error Correction and Detection**: Automatically corrects single-bit errors and detects double-bit errors within each 72-bit codeword, enhancing data integrity.
- **Serial Input Compatibility**: Designed to receive data serially, fitting well with serial communication protocols or serial data storage applications.
- **Error Frequency Monitoring**: Includes logic to monitor and report on the frequency of errors, allowing for early detection of potential system failures or deteriorating conditions.
- **Configurable Parity Scheme**: Comes with a configurable parity check matrix, which can be tailored to specific application needs within the Vivado environment.
- **Comprehensive Simulation Test Bench**: Ships with a complete test bench for Vivado simulation, demonstrating how to encode data, simulate error scenarios, and verify decoder functionality.

#### Usage in Vivado

To integrate this IP core into your project:
1. **Add the IP to Your Project**: Import the IP core into your Vivado project using the IP Catalog.
2. **Configure the IP**: Customize the parameters, such as the parity check matrix, through the Vivado GUI to fit your specific needs.
3. **Instantiate the IP**: Place the IP in your design, connecting the clock, reset, and serial data inputs according to your system architecture.
4. **Simulation and Synthesis**: Run simulation to verify the IP’s functionality before synthesis and implementation on your target FPGA.

#### Vivado Simulation and Testing

The IP core includes a simulation environment with a test bench tailored for Vivado. This setup allows users to encode test data, introduce errors, and verify the correction capabilities of the decoder, ensuring the IP meets design specifications before deployment.

#### Contributing

We encourage contributions from the community! If you have suggestions for improvements or identify any issues, please fork the repository, make your changes, and submit a pull request. For significant modifications or new features, please start a discussion via GitHub issues.

#### License

This IP core is distributed under the MIT License, allowing easy integration and modification in both academic and commercial projects.
