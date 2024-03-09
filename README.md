# Simple CNN Verilog Project
simple Convolutional_neural_network project on verilog
This project implements a small neural network in Verilog with 2 Conv2D layers and 3 Fully connected layers.

## Project Structure

- **src:** Contains Verilog source code files.
  - **CONV.v:**  convolutional layer.
  - **MAX_POOL.v:**  max pooling layer.
  - **conv_main.v:**  the main convolutional neural network.
  - **mxpooltester.v:**   testbench for the max pooling layer.
  - **top.v:** Top-level  input and output.
  - **CONV2D.v:**  2D convolution.
  - **ROM.v:**  ROM.
  - **maxpool.v:**  max pooling.
  - **pixel_generator.v:**  pixel generation.
  - **FullyConnected.v:**  fully connected layer.
  - **Relu.v:**  Rectified Linear Unit (ReLU).
  - **mixer_pixel.v:**  pixel mixer.
  - **processing_element.v:**  processing element.

## How to Use

1. Clone the repository: `git clone https://github.com/itsMorteza/simple_CNN_verilog.git`
2. Navigate to the project directory: `cd simple_CNN_verilog`
3. importing modules in src foleder to the ISE.
4. Simulate the neural network using the processing_element.

## License

This project is licensed under the [MIT License](LICENSE).