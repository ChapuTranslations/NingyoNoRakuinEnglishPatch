.Open "bin/src_DATA.BIN", "bin/DATA.BIN", 0x0

.include "src/DATA.BIN_code.asm"
.include "src/DATA.BIN_text.asm"
.include "src/DATA.BIN_dialogue.asm"
.include "src/DATA.BIN_extra_text.asm"

.Close