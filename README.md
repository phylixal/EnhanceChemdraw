# EnhanceChemdraw

I try to add more hotkey and functions for ChemBioDraw using Autohotkey.

## Hotkeys


  * F2,　　　　 open or close the Analysis Window.
  * F6,　　　　 convert selected structure to CAS number, only get the first one in synonyms
  * Ctrl+F6,　　convert selected text to structure (CAS number, or names), only get the most matched one
  * Shift+F6　　convert selected text to structure (CAS number, or names), get all the matched ones


## How does it work?

This simple script uses Wget to fetch chemical data from [PubChem](http://pubchem.ncbi.nlm.nih.gov/). Most jobs can be done by [PUG_REST](https://pubchem.ncbi.nlm.nih.gov/pug_rest/PUG_REST_Tutorial.html) web api. It is a little wired that wget is faster than python requests.get method.

## Tips

I use `chemdraw Professional Version 15.0.0.106`. Maybe it is necessary to modify the source code to detect the chemdraw window correctly, if another version of chemdraw is used.
```
#ifWinActive ChemDraw ahk_class CSWFrame
```

## Usage

Run the EnhanceChemdraw.ahk or the binary file [EnhanceChemdraw.exe](https://github.com/phylixal/EnhanceChemdraw/releases/download/0.1/enhanceChemdraw.exe), keep it in system tray. Then open Chemdraw and enjoy it!!

![](https://raw.githubusercontent.com/phylixal/EnhanceChemdraw/master/IM1.png)
![](https://raw.githubusercontent.com/phylixal/EnhanceChemdraw/master/IM2.png)
![](https://raw.githubusercontent.com/phylixal/EnhanceChemdraw/master/IM3.png)
![](https://raw.githubusercontent.com/phylixal/EnhanceChemdraw/master/IM4.png)
