# Microsoft Developer Studio Project File - Name="milmex" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Dynamic-Link Library" 0x0102

CFG=milmex - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "milmex.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "milmex.mak" CFG="milmex - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "milmex - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "milmex - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "milmex - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MT /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "MILMEX_EXPORTS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GX /O2 /I "c:/program files/matrox imaging/mil/include" /I "c:/program files/matlabr11/extern/include" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "MILMEX_EXPORTS" /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG"
# ADD RSC /l 0x409 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /machine:I386
# Begin Special Build Tool
SOURCE="$(InputPath)"
PostBuild_Desc=install it
PostBuild_Cmds=copy Release\milmex.dll d:\msl\gb\misc\matlab\milmex.dll
# End Special Build Tool

!ELSEIF  "$(CFG)" == "milmex - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "MILMEX_EXPORTS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "c:/program files/matrox imaging/mil/include" /I "c:/program files/matlabr11/extern/include" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "_USRDLL" /D "MILMEX_EXPORTS" /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG"
# ADD RSC /l 0x409 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /dll /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "milmex - Win32 Release"
# Name "milmex - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\milmex.cpp
# End Source File
# Begin Source File

SOURCE=.\milmex.def
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE="C:\Program Files\MATLABR11\extern\include\mexversion.rc"
# End Source File
# End Group
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milvhook.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milblob.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milcal.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milcode.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milcor.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milgen.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milhost.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milim.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milmeas.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milmet.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milmet2.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milmet2d.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milocr.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milpat.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milpul.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\miltiff.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milvb.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milvcap.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\milvga.lib"
# End Source File
# Begin Source File

SOURCE="C:\Program Files\Matrox Imaging\mil\library\winnt\msc\dll\mil.lib"
# End Source File
# End Target
# End Project
