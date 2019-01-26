FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV UNAME my-env

# Update the system & install dependencies
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
	#build-essential \
    #ca-certificates \
    #curl \
    git \
    #libssl-dev \
    #tmux \
    vim-nox \
    make \
	zsh \
	wget \
	fontconfig \
	locales

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

# UPDATE vimrc
ADD vimrc $HOME/.vimrc
RUN mkdir -p $HOME/.vim/bundle                                                                  && \
    cd  $HOME/.vim/bundle                                                                       && \
    # Get vim plugins
    git clone https://github.com/gmarik/Vundle.vim.git                                      && \
    vim +PluginInstall +qall                                                                && \
    git config --global core.editor vim


# Update powerline fonts
RUN mkdir -p $HOME/.fonts $HOME/.config/fontconfig/conf.d && \
    wget -P $HOME/.fonts                     https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf && \
    wget -P $HOME/.config/fontconfig/conf.d/ https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf && \
    fc-cache -vf $HOME/.fonts/ && \
    echo "set guifont=Droid\\ Sans\\ Mono\\ 10"

