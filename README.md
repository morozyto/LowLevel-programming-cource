# LowLevel-programming-cource in BMSTU

* CALC.asm  – Add, substract and multiply two numbers from zero to 2 in power 512. Each number occupies the sector (512 bytes), so the result of addition and substraction will be 512 bytes too (by module of 2 in power 512) and the result of multiplication will be 1024 bytes. Tested in emu8086.

* modifiedMBR.asm - Your basic MBR should be replaced in the second sector of your boor drive (if there is no important data :simple_smile:), and this file should put in the first sector. This MBR checks password: if password is correct, control is transferred to the native MBR and your Operating System is loaded, otherwise the program enters the eternal cycle. It will work everywhere, where MBR is used and the second (or some other) sector is does not contain important information. Tested on WindowsXP.
