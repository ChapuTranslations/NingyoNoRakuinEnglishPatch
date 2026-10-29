#!/usr/bin/python3
import modules.script as script
import modules.visuals as visuals
import modules.build as build


def _clean_up():
	print('Cleaning up')
	build.clean_up()


def _patch_ending_fmv():
	print('Patching translated ending FMV')
	visuals.patch_ending_fmv()


def _insert_non_encoded_images():
	print('Inserting non-encoded translated images')
	visuals.insert_non_encoded_images()


def _insert_modified_game_binaries():
	print('Inserting new game binaries')
	build.insert_modified_game_bins()


def _insert_encoded_images():
	print('Inserting LZSS-encoded translated images')
	visuals.insert_encoded_images()


def _update_image_coordinates():
	print('Updating coordinate tables for new images')
	visuals.update_coordinate_tables()


def _insert_font():
	print('Inserting new font into data file')
	visuals.insert_main_font_and_glyphs()


def _compile_game_binaries():
	print('Compiling modified game binaries')
	build.compile_main_asm()


def _insert_translated_script():
	print('Creating ASM files to insert translated script')
	script.process_data_bin_text()
	script.process_data_bin_dialogues()
	script.process_exe_text()


def _extract_game_bins():
	print('Extracting game binaries')
	build.extract_game_bins()


def _create_game_idx():
	print('Creating new image index')
	build.create_game_idx()


def _copy_game_image():
	print('Copying game image for patching')
	build.copy_game_image()


def _check_game_image():
	print('Checking the game image for patching is correct')
	build.check_game_image()


def main():
	_check_game_image()
	_copy_game_image()
	_create_game_idx()
	_extract_game_bins()
	_insert_translated_script()
	_compile_game_binaries()
	_insert_font()
	_insert_encoded_images()
	_update_image_coordinates()
	_insert_modified_game_binaries()
	_insert_non_encoded_images()
	_patch_ending_fmv()
	_clean_up()


if __name__ == "__main__":
	main()