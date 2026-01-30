# assembly-chess
An application I wrote as a 10th-grade final school project, after a year of learning 8086 assembly.<div>
<img width="500" height="312" alt="image" src="https://github.com/user-attachments/assets/a6d321b0-c926-47cb-93d5-202b6c0e85c5" /><div>


## Special Moves

### Castle
#### Short Castle
<img width="500" height="239" alt="image" src="https://github.com/user-attachments/assets/02f4769b-de4c-4659-b7b2-4a30851cc72a" /><div>
#### Long Castle
<img width="500" height="233" alt="image" src="https://github.com/user-attachments/assets/ff715523-5543-4197-ba33-a5a92baef80f" /><div>

### Promotion
<img width="500" height="165" alt="image" src="https://github.com/user-attachments/assets/f0533d49-8e26-40f7-af80-49e4f14b85e0" /><div>

### En-Passant
<img width="500" height="246" alt="image" src="https://github.com/user-attachments/assets/95a4528a-ba88-49ea-8c21-5034e1d76bca" /><div>


## User's Guide

### Environment
On modern systems, please use an emulator that allows executing 16-bit applications. I suggest DOSBox.

Please create a new folder (e.g., `C:\TASM\bin`) and place the files from the `TASM Files` and `Images` folders, along with `print.asm`.

Please execute the following commands:
```bat
mount C: C:\
C:
cd TASM\bin
cycles = max
that print
```

### Game
To make a move, click the piece you would like to move. Then click one of the available squares displayed.

To cancel the piece choice - click anywhere outside the available squares displayed (no touch-move rule :))

To flip the board once, click the button on the left (its color matches the current side).

For auto-flip, click the button on the right (it's green when activated).


## Architecture
### General Architecture
<img width="819" height="1102" alt="image" src="https://github.com/user-attachments/assets/f2472dcd-1509-41b6-bd0a-25d23b7b8fe5" /><div>
### Attacked Squares
<img width="741" height="528" alt="image" src="https://github.com/user-attachments/assets/20dc2635-3554-41b6-a7b2-db81792c6c19" /><div>
### Available Squares
<img width="624" height="506" alt="image" src="https://github.com/user-attachments/assets/b9cac41b-31ac-4936-8827-ac6eb4e27e7b" /><div>


## Thanks
- Izabella, my Assembly teacher, for teaching us from zero and always believing in us :heart:
- The local chess school and my coaches, for helping me get where I am
- My friends and colleagues from the Assembly classroom, for endless support and for the soccer ;)
- Intel, for the 8086!
- The writers of the various interrupt documentations on the web, for the tremendous help
- My dear family
- My dear sister, Nika, for drawing a perfect mouse cursor for the application
