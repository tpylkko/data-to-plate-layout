using ArgParse
s = ArgParseSettings()
@add_arg_table! s begin
    "arg1"
    arg_type = Int
    default = 5
    help = "Specify the column of the csv for input"
    required = true
    "arg2"
    arg_type = Int
    default = 96
    help = "Is the data from 96 or 384 well plate"
    required = true
    "arg3"
    arg_type = String
    default = "."
    help = "name of the file"
    required = true
end

parsed_args = parse_args(ARGS, s)

using NaturalSort, CSV, DataFrames

struct Plate
    row::Int
    column::Int
end

if parsed_args["arg2"] == 96
    plate = Plate(8,12)
end
if parsed_args["arg2"] == 384
    plate = Plate(16,24)
end


# which column are you interested in. Sort requires DataFrame
const interesting_column = parsed_args["arg1"]
data = CSV.File(string(parsed_args["arg3"])) |> DataFrame
sort!(data, [:well], lt=natural)

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
file_location = splitdir(parsed_args["arg3"])
output_filename = string(file_location[1], "/ped_data_plateformat.csv")
CSV.write(output_filename, df)
