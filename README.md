# DirectDraw API Hooking
Hooking DirectX's DirectDraw API to draw an overlay using Windows GDI

Just some code I had lying around. Not many people still code in Delphi/Pascal, so I decided to just release this snippet. This project uses the DirectDraw API to find a pointer to the [IDirectDrawSurface7 Blt()](https://msdn.microsoft.com/en-us/library/windows/desktop/gg426181(v=vs.85).aspx) method, then uses CreateBackup() to dynamically allocate memory and create a backup of the method. Then it creates an API hook on the Blt() method and forwards all calls to myBlt(). This let's you access all device contexts for DirectDraw surfaces.

## Usage
1. Compile as a .dll file
2. Use [DLL Injection](https://en.wikipedia.org/wiki/DLL_injection) onto a process that uses the DirectDraw API

## Notes
* This code was tested on Windows XP x86
* It was tested to compile on Delphi 7
* If you encounter ANY errors, feel free to contact me!

## Credits
* Brandon Asuncion - me@brandonasuncion.tech
* Aphex - for afxCodeHook library

## License
[MIT License](https://choosealicense.com/licenses/mit/)