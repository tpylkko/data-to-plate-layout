# data-to-plate-layout
A script to convert plate reader data from so called narrow format to a matrix corresponding to the plate layout. Many readers store and output data using an Entity–attribute–value model, which is nice for analysis, but sometimes you want to see the values in the same layout as the actual plate, for example to estiamte if there are "area effects".

Inputs are column number, a value of 96 or 384 depending on which kind of plate the data came from, and the file name. Outputs the matrix into the same folder as where the data came from.
