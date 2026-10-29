import subprocess
import shutil
import hashlib
import pathlib
import modules.constants as const


class WrongGameImageError(Exception):
    pass


def compile_main_asm():
    subprocess.run(
        [const.ARMIPS, const.MAIN_ASM],
        check=True,
        capture_output=True,
    )


def insert_modified_game_bins():
    for bin_name in const.MODIFIED_GAME_BINS:
        subprocess.run(
            ['wine', const.PSXINJECT, '-v', const.PATCHED_GAME_IMAGE, bin_name, const.BIN_DIR / bin_name],
            check=True,
            capture_output=True,
        )


def clean_up():
    to_delete = list(const.PROJECT_ROOT.glob('*.log'))
    for bin_name in const.MODIFIED_GAME_BINS + const.GAME_BINS:
        to_delete.append(pathlib.Path(const.BIN_DIR / bin_name))
    to_delete += const.GENERATED_SCRIPT_ASM
    to_delete.append(pathlib.Path(const.GAME_BIN_IDX))
    for f in to_delete:
        f.unlink()
    shutil.rmtree(const.DUMP_DIR)


def copy_game_image():
    shutil.copy(const.GAME_IMAGE, const.PATCHED_GAME_IMAGE)


def create_game_idx():
    subprocess.run(
        [
            'java', '-jar', const.JPSXDEC_JAR,
            '-f', const.PATCHED_GAME_IMAGE,
            '-x', const.GAME_BIN_IDX,
        ],
        check=True,
        capture_output=True,
    )


def extract_game_bins():
    for idx, bin_name in enumerate(const.MODIFIED_GAME_BINS, start=1):
        subprocess.run(
            [
                'java', '-jar', const.JPSXDEC_JAR,
                '-x', const.GAME_BIN_IDX,
                '-i', str(idx),
            ],
            check=True,
            capture_output=True,
        )
    for orig_bin_name, new_bin_name in zip(const.MODIFIED_GAME_BINS, const.GAME_BINS):
        shutil.move(orig_bin_name, const.BIN_DIR / new_bin_name)


def check_game_image():
    try:
        with open(const.GAME_IMAGE, 'br') as image_fd:
            md5_digest = hashlib.file_digest(image_fd, 'md5').hexdigest()
    except FileNotFoundError:
        raise FileNotFoundError(
            f'Could not find original game image {const.GAME_IMAGE.name} in {const.GAME_IMAGE.parent}'
        ) from None

    if md5_digest != const.GAME_IMAGE_MD5:
        raise WrongGameImageError('Game image does not have the expected MD5 hash, check README.md')