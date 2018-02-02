FROM sostrader/mt5
MAINTAINER Emerson Pedrosos <emerson@sostrader.com.br>

USER xclient

RUN echo "WINEPREFIX=~/.wine64 wine ~/.wine64/drive_c/Program\ Files/MetaTrader\ 5/terminal64.exe" >> ~/mt5.sh
RUN echo "alias mt5='WINEPREFIX=~/.wine64 wine ~/.wine64/drive_c/Program\ Files/MetaTrader\ 5/terminal64.exe'" >> ~/.bashrc
CMD ~/mt5.sh

