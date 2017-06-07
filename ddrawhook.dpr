// DirectDraw Overlay via DirectX API hooking
// Brandon Asuncion (me@brandonasuncion.tech)

library ddrawhook;

uses
  SysUtils,
  Windows,
  DirectDraw,
  GDI,
  afxCodeHook;


var
  hhBlt:function(lpDestRect: pointer; lpDDSrcSurface: pointer; lpSrcRect: pointer; dwFlags: DWORD; lpDDBltFx: pointer): HResult; stdcall;
  plpDDSrcSurface:dword;
  DC:hDC;

// This part uses Windows' GDI API
procedure Drawer;
begin
  SetBkMode(DC, TRANSPARENT);
  TextOut(DC, 10, 10, 'DirectDraw Overlay via API Hooks Example', 11);
  TextOut(DC, 10, 20, 'by Brandon Asuncion', 11);
end;


procedure myBlt;
begin
  asm
    mov eax, DWORD PTR SS:[esp + 12]
    mov plpDDSrcSurface, eax

    pushad
  end;

  if (plpDDSrcSurface <> 0) then
    begin
      Surface:=@plpDDSrcSurface;
      if Surface.GetDC(DC) = DD_OK then
        begin
          drawer;
          Surface.ReleaseDC(DC);
        end;
    end;

  asm
    popad
    jmp hhBlt
  end;
end;


var
  DD:IDirectDraw7;
  surface:IDirectDrawSurface7;
  surfaceDesc:_DDSURFACEDESC2;
begin
  if DirectDrawCreateEx(nil, DD, IDirectDraw7, nil) <> DD_OK then
  begin
    MessageBox(0, 'DirectDrawCreateEx() failed!', '', MB_OK);
    exit;
  end;

  if DD.SetCooperativeLevel(0, ddscl_normal) <> DD_OK then
  begin
    MessageBox(0, 'DD_SetCooperativeLevel() failed!', '', MB_OK);
    exit;
  end;
	
  fillchar(SurfaceDesc, sizeof(surfaceDesc), 0);
  surfaceDesc.dwSize:=sizeof(surfaceDesc);
  surfaceDesc.dwFlags:=ddsd_caps;
  surfaceDesc.ddsCaps.dwCaps:=ddscaps_primarysurface;

  if DD.CreateSurface(surfaceDesc, surface, nil) <> DD_OK then
  begin
    MessageBox(0, 'DD_CreateSurface() failed!', '', MB_OK);
    ExitProcess(0);
  end;

  addrBlt:=pdword(pdword(pdword(@surface)^)^ + $14)^;
  
  CreateBackup(addrBlt, @hhBlt);
  hook(addrBlt, @myBlt);
  FlushInstructionCache(GetCurrentProcess, addrBlt, 10);
	  
  MessageBox(0, 'Injected into process', '', 0);
end.
