import struct
import re
import itertools
import modules.constants as const
from modules.common import get_bin_data


def _get_translated_lines(translation_filepath):
	with open(translation_filepath, 'r') as translation_fd:
		return translation_fd.readlines()[1:]


def _str_to_even_len(string):
	return string + ' ' if len(string) % 2 else string


def _sanitise_double_quotes(string):
	return string.replace('"', '\\"')


def process_data_bin_text():
	lines = _get_translated_lines(const.TRANS_DATA_TEXT)
	data = get_bin_data(const.SRC_DATA_BIN)
	placeholder_parser = re.compile(r'[^$]+|\$[a-z]')

	current_offset = 0
	current_block = None
	ram_pos = 0
	with open(const.DATA_TEXT_ASM, 'w') as output_file:
		print('; /// TEXTS ///', file=output_file)
		for number, line in enumerate(lines, start=1):
			_, block, pointer_locations, _, translation = line.split('|')
			translation = translation.rstrip()

			pointer_locations = [int(p, 16) for p in pointer_locations.split(',')]

			block = int(block, 16)
			if current_block != block:
				current_block = block
				file_pos = current_block
				if current_block < 0x18000:
					ram_pos = const.GLYPH_TEXTURE_START + current_block
				else:
					ram_pos = struct.unpack_from('<I', data, pointer_locations[0])[0]
				current_offset = 0

			print(const.NUMBER.format(str(number)), file=output_file)
			print('; ptrs', file=output_file)
			for loc in pointer_locations:
				print(const.ORG.format(hex(loc)), file=output_file)
				print(const.DW.format(hex(ram_pos + current_offset)), file=output_file)

			print('; msg', file=output_file)
			print(const.ORG.format(hex(file_pos + current_offset)), file=output_file)

			if len(translation):
				chunks = placeholder_parser.findall(translation)
				for chunk in chunks:
					if chunk.startswith('$'):
						print(const.DB.format(','.join([hex(ord(c)) for c in chunk])), file=output_file)
						current_offset += 2
					else:
						chunk = _str_to_even_len(chunk)
						current_offset += len(chunk)
						print(const.STRINGN.format(_sanitise_double_quotes(chunk)), file=output_file)
				print(const.DB0, file=output_file)
				current_offset += 1
			else:
				current_offset += 2
				print(const.DH0, file=output_file)

			print('', file=output_file)


def _param_bytes_to_hex_string(param):
	return ','.join(['0x'+''.join(pair) for pair in itertools.batched(param, 2)])


def _get_first_segment_offset(block, data):
	return struct.unpack_from('<I', data, block + 8)[0]


def _print_segment_offset(block, segment, offset, to_file):
	print('; SEGMENT OFFSET', file=to_file)
	print(const.ORG.format(hex(block + 8 + segment * 4)), file=to_file)
	print(const.DW.format(hex(offset)), file=to_file)
	print('', file=to_file)


def process_data_bin_dialogues():
	lines = _get_translated_lines(const.TRANS_DIALOGUES)
	data = get_bin_data(const.SRC_DATA_BIN)
	codes_parser = re.compile(r'\[[^]]+]|[^\[]+')

	with open(const.DATA_DIALOGUE_ASM, 'w') as output_file:
		for k, v in const.CODES_DICT.items():
			print(const.EQU.format(k, v), file=output_file)
		print('', file=output_file)
		print('; /// DIALOGUES ///', file=output_file)

		current_block = 0
		current_segment = 0
		current_offset = 0
		number = 1
		for line in lines:
			_, block, segment, original, translation = line.split('|')
			block = int(block, 16)
			segment = int(segment)
			translation = translation.rstrip()

			if block != current_block:
				# close last segment offset for current block
				if current_block:
					_print_segment_offset(current_block, current_segment + 1, current_offset, output_file)

				current_block = block
				current_segment = segment
				current_offset = _get_first_segment_offset(current_block, data)

				_print_segment_offset(current_block, current_segment, current_offset, output_file)
				print(const.ORG.format(hex(current_block + current_offset)), file=output_file)

			if segment != current_segment:
				current_segment = segment
				_print_segment_offset(current_block, current_segment, current_offset, output_file)

				print(const.ORG.format(hex(current_block + current_offset)), file=output_file)
				print('', file=output_file)

			if original.startswith('[RAW:'):
				print(const.NUMBER.format(str(number)), file=output_file)
				number += 1
				param = original[5:-1]
				param_hex_string = _param_bytes_to_hex_string(param)
				current_offset += len(param) // 2

				print(const.DB.format(param_hex_string), file=output_file)
			else:
				chunks = codes_parser.findall(translation)
				for chunk in chunks:
					if chunk.startswith('['):
						code_and_param = chunk[1:-1].split(':')
						current_offset += 1
						code_and_param_hex_string = const.CODE.format(code_and_param[0])

						if len(code_and_param) > 1:
							current_offset += len(code_and_param[1]) // 2
							code_and_param_hex_string += ',' + _param_bytes_to_hex_string(code_and_param[1])

						print(const.DB.format(code_and_param_hex_string), file=output_file)
					else:
						text = _str_to_even_len(chunk)
						current_offset += len(text)

						print(const.STRINGN.format(_sanitise_double_quotes(text)), file=output_file)
				print('', file=output_file)

		print('', file=output_file)
		_print_segment_offset(current_block, current_segment + 1, current_offset, output_file)


def process_exe_text():
	lines = _get_translated_lines(const.TRANS_EXE_TEXT)

	current_offset = 0
	current_block = None
	with open(const.EXE_TEXT_ASM, 'w') as output_file:
		print('; /// TEXTS ///', file=output_file)
		for line in lines:
			number, position, _, translation, pointer_locations, block = line.split('|')
			block = block.rstrip()

			if not block or current_block != block:
				current_block = block
				current_offset = int(position, 16)

			pointer_locations = pointer_locations.split(',') if pointer_locations else []
			translation = _str_to_even_len(translation)

			print(const.NUMBER.format(str(number)), file=output_file)
			print(const.ORG.format(hex(current_offset)), file=output_file)

			if translation:
				print(const.STRING.format(_sanitise_double_quotes(translation)), file=output_file)
			else:
				print(const.DH0, file=output_file)

			for loc in pointer_locations:
				print(const.ORG.format(loc), file=output_file)
				print(const.DW.format(hex(current_offset)), file=output_file)

			if translation:
				current_offset += len(translation) + 1
			else:
				current_offset += 2
			print('', file=output_file)