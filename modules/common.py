def get_bin_data(bin_filepath):
	with open(bin_filepath, 'br') as bin_fd:
		return bin_fd.read()