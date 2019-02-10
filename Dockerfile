FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV UNAME my-docker-vim

# Update the system & install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
	build-essential \
    git tig \
    libssl-dev \
	libncurses5-dev libgnome2-dev libgnomeui-dev \
	libgtk2.0-dev libatk1.0-dev libbonoboui2-dev \
	libcairo2-dev libx11-dev libxpm-dev libxt-dev python-dev \
	python3-dev ruby-dev lua5.1 liblua5.1-dev libperl-dev \
    make \
	wget curl file \
	fontconfig locales \
	silversearcher-ag \
	zsh

RUN apt-get install -y python-setuptools python-pip && pip install wheel

# Update user $UNAME
RUN useradd $UNAME && \
    echo "ALL ALL = (ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    #cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    dpkg-reconfigure locales && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8

WORKDIR /home/$UNAME
ENV HOME /home/$UNAME
ENV LC_ALL en_US.UTF-8
RUN chown -R $UNAME:$UNAME $HOME
USER $UNAME

# Update zshrc
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
ADD zshrc $HOME/.zshrc

# Update powerline fonts
RUN mkdir -p $HOME/.fonts $HOME/.config/fontconfig/conf.d && \
    wget -P $HOME/.fonts                     https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf && \
    wget -P $HOME/.config/fontconfig/conf.d/ https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf && \
    fc-cache -vf $HOME/.fonts/ && \
    echo "set guifont=Droid\\ Sans\\ Mono\\ 10"

USER root
# Update fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
	~/.fzf/install
USER $UNAME

# Build vim
RUN git clone https://github.com/vim/vim.git
RUN cd vim && \
	./configure --with-features=huge \
        --enable-multibyte \
	    --enable-rubyinterp=yes \
	    --enable-pythoninterp=yes \
	    --with-python-config-dir=/usr/lib/python2.7/config \ 
	    --enable-perlinterp=yes \
	    --enable-luainterp=yes \
        --enable-cscope \
	    --prefix=/usr/local \
		--enable-gui=auto --enable-gtk2-check --with-x && \
	make VIMRUNTIMEDIR=/usr/local/share/vim/vim81

# Install vim
USER root
RUN cd vim && make install
USER $UNAME

## Install geeknote
RUN git clone git://github.com/jeffkowalski/geeknote.git
USER root
RUN cd geeknote && \
	python setup.py build && \
	pip install --upgrade .
USER $UNAME

# UPDATE vimrc
ADD vimrc $HOME/.vimrc
RUN mkdir -p $HOME/.vim/bundle && \
    cd  $HOME/.vim/bundle && \
    # Get vim plugins
    git clone https://github.com/gmarik/Vundle.vim.git && \
    vim +PluginInstall +qall && \
	rm -rf vim-geeknote && \
	git clone https://github.com/neilagabriel/vim-geeknote.git && \
    git config --global core.editor vim

USER root
ENV NODE_VERSION 11.4.0
RUN wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash && \
 	. $HOME/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

USER $UNAME

ENV EVERNOTE_DEV_TOKEN dummy
RUN geeknote login

