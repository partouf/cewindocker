FROM mcr.microsoft.com/windows/servercore:10.0.18362.959-amd64

LABEL Description="CE for Windows" Vendor="compilerexplorer" Version="0.0.1"

WORKDIR /tmp

RUN powershell -Command Invoke-WebRequest -Uri "https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe" -OutFile "git-installer.exe" -UseBasicParsing
RUN git-installer.exe /silent /verysilent
RUN del /q git-installer.exe

RUN powershell -Command Invoke-WebRequest -Uri "https://nodejs.org/dist/v12.18.3/node-v12.18.3-x64.msi" -OutFile "node-installer.msi" -UseBasicParsing
RUN msiexec /quiet /i node-installer.msi
RUN del /q node-installer.msi

RUN powershell -Command Invoke-WebRequest -Uri "https://download.microsoft.com/download/1/c/3/1c3d5161-d9e9-4e4b-9b43-b70fe8be268c/windowssdk/winsdksetup.exe" -OutFile "winsdksetup.exe" -UseBasicParsing
RUN winsdksetup.exe /silent
RUN del /q winsdksetup.exe

RUN powershell -Command Invoke-WebRequest -Uri "https://kumisystems.dl.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v7.0.0.zip" -OutFile "mingw.zip"
RUN powershell -Command Expand-Archive -LiteralPath "/tmp/mingw.zip" -DestinationPath "/opt/compiler-explorer/mingw-7"

RUN git clone https://github.com/compiler-explorer/compiler-explorer /compilerexplorer

WORKDIR /compilerexplorer

RUN npm i

CMD ["node", "app.js"]
