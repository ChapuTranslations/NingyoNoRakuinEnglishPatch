import subprocess
import struct
import re
import pathlib
import modules.constants as const
from modules.common import get_bin_data


def insert_main_font_and_glyphs():
	with open(const.DATA_BIN, 'br+') as data_fd:
		data_fd.seek(const.FONT_INSERTION_ADDRESS)

		data_fd.write(get_bin_data(const.EXTRA_GLYPHS))
		data_fd.write(get_bin_data(const.MAIN_FONT))


def _custom_lzss_encode(data):
	output = bytearray()
	output.extend(struct.pack('<I', len(data)))

	cursor = 0
	literal_buffer = bytearray()

	def flush_literals():
		if not literal_buffer:
			return

		length_code = len(literal_buffer) - 1
		output.append(length_code)
		output.extend(literal_buffer)
		literal_buffer.clear()

	while cursor < len(data):
		best_match_len = 0
		best_match_dist = 0

		bytes_available = min(len(data) - cursor, const.MAX_MATCH)

		if bytes_available >= const.MIN_MATCH:
			for dist in range(1, min(cursor, const.WINDOW_SIZE) + 1):
				match_src = cursor - dist

				current_len = 0
				for i in range(bytes_available):
					if data[cursor + i] == data[match_src + i]:
						current_len += 1
					else:
						break

				if current_len > best_match_len:
					best_match_len = current_len
					best_match_dist = dist

					if best_match_len == const.MAX_MATCH:
						break

		if best_match_len >= const.MIN_MATCH:
			flush_literals()

			dist_bits = (best_match_dist << 4)
			len_bits = (best_match_len - 3)
			code_val = const.MATCH_FLAG | dist_bits | len_bits

			output.extend(struct.pack('>H', code_val))

			cursor += best_match_len
		else:
			literal_buffer.append(data[cursor])
			cursor += 1

			if len(literal_buffer) == const.MAX_LITERAL_RUN:
				flush_literals()

	flush_literals()

	return bytes(output)


def _update_terrified_pos():
	# Status ailment images are LZSS compressed.
	# The streams are stored in DATA.BIN and spaced every 0x800 bytes (one CD sector).
	# The translated image for "poisoned" is far larger than the original Japanese one,
	# so the compressed stream ends up taking more than the one sector originally planned.
	# This overwrites the compressed data for the *next* status ailment image, "terrified"
	# So, modify the absolute sector position for "terrified" in here and reinsert it one
	# sector farther to make room for "poisoned".
	with open(const.DATA_BIN, 'br+') as data_fd:
		data_fd.seek(const.TERRIFIFED_POS_OFFSET)
		data_fd.write(struct.pack('<I', const.TERRIFIED_POS))


def _update_ailments_size_table():
	# In order to create the zoom out effect for status ailments during battle,
	# the game has a table with the image width/height for each ailment.
	# The translated images are all the same size, so we update the table.
	with open(const.DATA_BIN, 'br+') as data_fd:
		for pos in range(const.AILMENT_SIZE_TABLE_START, const.AILMENT_SIZE_TABLE_END, const.AILMENT_SIZE_TABLE_STEP_SIZE):
			data_fd.seek(pos)
			data_fd.write(struct.pack('<I', const.STATUS_AILMENT_WIDTH))
			data_fd.write(struct.pack('<I', const.STATUS_AILMENT_HEIGHT))


def _insert(data_by_offset):
	with open(const.DATA_BIN, 'br+') as data_fd:
		for offset, data in data_by_offset.items():
			data_fd.seek(offset)
			data_fd.write(data)


def _get_encoded_data_by_offset(images):
	data_by_offset = dict()

	for im_filepath in images:
		im_data = get_bin_data(im_filepath)
		im_offset = int(im_filepath.name.split('_')[0], 16)
		encoded_data = _custom_lzss_encode(im_data)
		data_by_offset[im_offset] = encoded_data

	return data_by_offset


def _get_tim_images(directory):
	return list(pathlib.Path(directory).glob('*.tim'))


def insert_encoded_images():
	images = _get_tim_images(const.DECOMPRESSED_IMAGES_DIR)
	encoded_data = _get_encoded_data_by_offset(images)
	_insert(encoded_data)
	_update_ailments_size_table()
	_update_terrified_pos()


def update_coordinate_tables():
	with open(const.DATA_BIN, 'br+') as data_fd:
		data_fd.seek(const.SHADOW_VRAM_X_COORD_OFFSET)
		data_fd.write(struct.pack('<H', const.SHADOW_VRAM_X_COORD))

		for table in pathlib.Path(const.COORDS_DIR).glob('*.txt'):
			table_entries = table.read_text()
			table_pos = int(table.name.split('_')[0], 16)
			data_fd.seek(table_pos)
			for entry in table_entries.split():
				data_fd.write(struct.pack('>H', int(entry, 16)))


def _extract_fmv():
	subprocess.run(
		[
			'dumpsxiso', '-x', const.DUMP_DIR, '-s', const.DUMP_XML, const.GAME_IMAGE,
		],
		check=True,
		capture_output=True,
	)


def _patch_fmv():
	subprocess.run(
		[
			'xdelta3', '-d', '-f',
			'-s', const.ORIG_FMV, const.FMV_DIFF, const.PATCHED_FMV,
		],
		check=True,
		capture_output=True,
	)


def _reinsert_fmv():
	subprocess.run(
		[
			'wine', const.PSXINJECT, '-v', const.PATCHED_GAME_IMAGE,'STR/ENDING.STR', const.PATCHED_FMV,
		],
		check=True,
		capture_output=True,
	)


def patch_ending_fmv():
	_extract_fmv()
	_patch_fmv()
	_reinsert_fmv()


def insert_non_encoded_images():
	image_idx_parser = re.compile(r'[0-9]+')
	images =_get_tim_images(const.NON_ENCODED_IMAGES_DIR)
	for im_filepath in images:
		im_idx = image_idx_parser.findall(im_filepath.name)[0]
		subprocess.run(
			[
				'java', '-jar', const.JPSXDEC_JAR,
				'-x', const.GAME_BIN_IDX,
				'-i', str(int(im_idx) + 3),
				'-replacetim', im_filepath
			],
			check=True,
			capture_output=True,
		)