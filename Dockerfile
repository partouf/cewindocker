FROM mcr.microsoft.com/windows/servercore:10.0.18362.959-amd64

LABEL Description="CE for Windows" Vendor="compilerexplorer" Version="0.0.1"

WORKDIR /tmp

RUN powershell -Command Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe" -OutFile "git-installer.exe" -UseBasicParsing && \
    git-installer.exe /silent /verysilent && \
    del /q git-installer.exe

RUN powershell -Command Invoke-WebRequest -Uri "https://www.7-zip.org/a/7z1900-x64.msi" -OutFile "7zsetup.msi" -UseBasicParsing && \
    msiexec /quiet /i 7zsetup.msi && \
    del /q 7zsetup.msi

RUN powershell -Command Invoke-WebRequest -Uri "https://nodejs.org/dist/v12.18.3/node-v12.18.3-x64.msi" -OutFile "node-installer.msi" -UseBasicParsing && \
    msiexec /quiet /i node-installer.msi && \
    del /q node-installer.msi

RUN powershell -Command Invoke-WebRequest -Uri "https://download.microsoft.com/download/1/c/3/1c3d5161-d9e9-4e4b-9b43-b70fe8be268c/windowssdk/winsdksetup.exe" -OutFile "winsdksetup.exe" -UseBasicParsing && \
    winsdksetup.exe /silent && \
    del /q winsdksetup.exe

RUN powershell -Command Invoke-WebRequest -Uri "https://netcologne.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-win32/seh/x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z" -OutFile "mingw.7z" && \
    "C:\Program Files\7-Zip\7z.exe" x "-o/opt/compiler-explorer/mingw-8.1.0" mingw.7z && \
    del /q mingw.7z

RUN git clone https://github.com/compiler-explorer/compiler-explorer /compilerexplorer

WORKDIR /compilerexplorer

RUN npm i

ADD c++.win32.properties etc/config/c++.win32.properties
ADD python.win32.properties etc/config/python.win32.properties

CMD ["node", "app.js"]
