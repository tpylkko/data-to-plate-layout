# data-to-plate-layout
A script to convert plate reader data from so called narrow format to a matrix corresponding to the plate layout. Many readers store and output data using an Entity–attribute–value model, which is nice for analysis, but sometimes you want to see the values in the same layout as the actual plate, for example to estiamte if there are "area effects".

Inputs are column number, a value of 96 or 384 depending on which kind of plate the data came from, and the file name. Outputs the matrix into the same folder as where the data came from.

Julia is not really designed to be doing light work such as manipulation to dataframes, due to the just-in-time compiling. So there can be a quite significant lag time when any function is called for the first time. One solution is to full compile binaries of the scripts. Another solution is to run with the flags and options: -o0 --compile=min -startup=no. This significantly decrease the initial lag.
