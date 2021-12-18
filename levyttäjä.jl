using ArgParse
s = ArgParseSettings()
@add_arg_table! s begin
    "column"
        arg_type = Int
        default = 5
        help = "Specify the column of the csv for input"
        required = true
    "--384"
        help = "If the plate is 384-well use this flag. Otherwise
            presumed to be 96-well"
        action = :store_true
    "filename"
        arg_type = String
        default = "."
        help = "name of the file"
        required = true
end

parsed_args = parse_args(ARGS, s)
@info "Arguments parsed, loading libraries and file..."
using NaturalSort, CSV, DataFrames

struct Plate
    row::Int
    column::Int
end

if parsed_args["384"] == false
    plate = Plate(8,12)
end
if parsed_args["384"] == true
    plate = Plate(16,24)
end


# which column are you interested in. Sort requires DataFrame
const interesting_column = parsed_args["column"]
if isfile(parsed_args["filename"]) == false
    @error "The file does not exist"
    exit(86)
end
data = CSV.File(string(parsed_args["filename"])) |> DataFrame
sort!(data, [:well], lt=natural)
@info "File found, values sorted"

# a demonstratoin of how a dataframe can be transposed already at init
#data_t = CSV.File("trims.csv", transpose=true) |> DataFrame

df = DataFrame()

function hae(alku, kolumni)
    if alku > 1
        alku = 1 + (alku -1) * plate.column
    end
    loppu = alku + (plate.column -1)
    haettu = data[!,kolumni][alku:loppu]
    return haettu
end

function levymuotoon(kolumni)
    matrix = zeros(plate.row,plate.column)
    for i in (1:plate.row)
        matrix[i,1:plate.column] = hae(i, kolumni)
    end
    return matrix
end

df = levymuotoon(interesting_column)
df = DataFrame(df, :auto)
#scatter(data.Column1,data[5], xticks=4)
file_location = splitdir(parsed_args["filename"])
output_filename = string(file_location[1], "/ped_data_plateformat.csv")
CSV.write(output_filename, df)
@info "Done! The output has been written to file in the same path"
