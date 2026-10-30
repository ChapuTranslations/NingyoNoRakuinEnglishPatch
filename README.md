# "Ningyo no rakuin" English translation patch

This includes all the necessary code and assets to patch the game and translate it to English.
Patcher script is Linux only, but it should be *relatively* easy to replicate the same steps in a .bat in Windows.

## What you'll need:
*	Java, Wine, Xdelta3, Python >=3.11 and [MKPSXISO](https://github.com/Lameguy64/mkpsxiso) installed on your system.
*	A copy of the game ("Ningyo no Rakuin (Japan)"), with the .cue and .bin extracted in the "bin" folder.
*	MD5 for Ningyo no Rakuin (Japan).bin should be 021e7812bd5110ce09110e9ca4382946

##	You'll also need the following executables in the "tools" folder:
*	[armips](https://github.com/Kingcom/armips)
*	[jpsxdec.jar](https://github.com/m35/jpsxdec) and jpsxdec-lib.jar
*	psxinject.exe (part of the [psximager suite](https://github.com/cebix/psximager))

Simply give run permissions to patcher.py and execute. If everything's in order, it'll create a patched .bin of the game in the bin folder and you'll be able to play it in English.

##	About this patch:

I had wanted to translate this game for some time, but I was afraid of not being able to manage the custom character names. In the end, with some patience and a bunch of clever/dirty hacking tricks, I was able to pull it off. The dialogue referencing system was a bit of a pain for text reinsertion (lots of offset calculations), but once I had the technical side of things figured out I got in touch with vervalkon and whowasphone, who were both delighted to join the team, and then Layton hopped in for the RetroAchievements set and playtesting. With the Dream Team assembled, we set to work.

The game itself is clearly a "Final Fantasy Tactics" gameplay rip-off, but the story is dark and interesting. It has some fun hours in store for those willing to tackle the challenge (some of the last battles can be brutal, and getting the good ending is particularly tricky). I'm chuffed we were able to translate it, and I hope everyone who plays it has a great time.

The included "extras" ZIP file has the translated manual, inlay and promo ad scans. The manual and inlay in particular have two versions each: one intended for PC visualization, and one for printing.

As usual, feel free to do whatever the hell you want with this code: fork it, study it, change it, translate the game to other languages, whatever. Knowledge should be free. I was only able to learn ROM hacking thanks to the kindness of people who came before me and altruistically shared their knowledge. If you do something with this code, a wee "thank you" would be much appreciated, but is by no means mandatory.

No AI, LLM, MTL or other such nonsense was used in the production of this patch. Not for the translation, not for the graphics, not for the coding, not for anything.

### Credits
*	Chapu - Programming/hacking.
*	LaytonLoztew - Playtesting and QA.
*	vervalkon - Graphics and video editing, release trailer.
*	whowasphone404 - Translation and localisation.

Very special thanks to Lachrymal, for graciously providing the original manual scan.

## Changelog:
###	v1.0:
*	Initial commit. The game is fully translated and playable with the code as it stands. No *known* bugs at the moment.
