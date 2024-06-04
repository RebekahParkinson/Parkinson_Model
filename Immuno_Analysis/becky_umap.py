import pandas as pd
import numpy as np
from cuml import UMAP
import cupy as cp
from sklearn.preprocessing import StandardScaler
import argparse
import fcsparser

parser = argparse.ArgumentParser()

def add_arg(var_name, type, required, parser_obj, default = None):
	return parser_obj.add_argument(
		var_name,
		type = type, 
		required = required, 
		default = default
	)

parser.add_argument( 
	"--source_file", 
	required = True
)

parser.add_argument(
	"--export_name", 
	required = True
)

parser.add_argument(
	"--scaler_group",
	type = tuple, 
	default  = None, 
	required = False 
)

parser.add_argument(
	"--use_channels",
	type = str, 
	default  = None, 
	required = False 
)

parser.add_argument(
	"--remove_channels",
	type = str, 
	default  = None, 
	required = False 
)

parser.add_argument(
	"--n_neighbours",
	type = int, 
	default  = 15, 
	required = False 
)

parser.add_argument(
	"--distance_metric",
	type = str, 
	default  = "Euclidean", 
	required = False 
)

parser.add_argument(
	"--min_dist",
	type = float, 
	default  = 0.1, 
	required = False 
)

args = parser.parse_args()
print(f"args are {args}")

source_file = args.source_file
export_name = args.export_name 
scaler_group = args.scaler_group 
n_neighbours = args.n_neighbours
distance_metric = args.distance_metric
min_dist = args.min_dist

use_channels = list(map(int, args.use_channels.split(',')))

assert type(use_channels) is list, 'use_channels must be a list'

remove_channels = args.remove_channels
if remove_channels is not None: 
	remove_channels = list(map(int, args.remove_channels.split(',')))

if not scaler_group: 
	pass 
else: 
	scaler = scaler_group[1]
	control_val = scaler_group[2]

if len(use_channels) == 4:
	fsc_channel = use_channels[0]
	ssc_channel = use_channels[1]
	start_main_channel = use_channels[2]
	end_main_channel = use_channels[3]+1
	input_channels = np.r_[fsc_channel, ssc_channel, start_main_channel:end_main_channel]

# elif len(use_channels) == 5: 
# 	fsc_channel = use_channels[0]
# 	ssc_channel = use_channels[1]
# 	inclusion_channel = use_channels[2]
# 	start_main_channel = use_channels[3]
# 	end_main_channel = use_channels[4]
# 	input_channels = np.r_[fsc_channel, ssc_channel, inclusion_channel, start_main_channel:end_main_channel]

if remove_channels is not None: 
	for channel in remove_channels: 
		input_channels = np.delete(
			input_channels, 
			np.where(input_channels == channel)
		)

def scale_within_batch(batched_input, control_val):
	controls = batched_input[batched_input[scaler_group] == control_val]
	usedat = batched_input.iloc[:, input_channels]
	# with open(f'{source_file}.txt', 'w') as f:
	# 	f.write(
	# 		f"""Columns being used are {usedat.columns} 
	# 		The total available columns are {batched_input.columns}""")
	control_dat = controls.iloc[:, input_channels]
	scaler = StandardScaler()
	scaler.fit(X = control_dat)
	return scaler.transform(usedat)

def scale_by_batch(full_input):
	if not scaler_group: 
		scaler = StandardScaler()
		full_input = full_input.iloc[:, input_channels]
		return scaler.fit_transform(full_input)
	else: 
		all_batched = full_input.groupby(by = scaler)
		batch_keys = all_batched.groups.keys()
		return [scale_within_batch(all_batched.get_group(key), control_val=control_val) for key in batch_keys]

def UMAPPER(data, exportname):
	print(f"Mapping out now for sample {source_file}")
	if "fcs" in data: 
		file = fcsparser.parse(data)[1]
	elif "csv" in data: 
		file = pd.read_csv(data)
	else: 
		raise "Invalid file type, must be CSV or FCS"
	scaled_dat = np.vstack(scale_by_batch(file))
	print(f"These are the input channels for {source_file}: {file.columns[input_channels]}")
	print(f"Scaling sample {source_file}")
	dim_redder = UMAP(n_neighbors = n_neighbours, metric = distance_metric, min_dist = min_dist, output_type = "pandas") 
	print(f"UMAPing sample {source_file}")
	scaled_dat = cp.asarray(scaled_dat)
	X_transformed = dim_redder.fit_transform(scaled_dat)
	print(f"UMAP-ed sample {source_file}")
	X_transformed.columns = ["UMAP_X", "UMAP_Y"]
	pd.concat([file, X_transformed], axis = 1).to_csv(exportname, index = False, sep = ',')
	print(f"Completed sample {source_file}")

UMAPPER(source_file, export_name)