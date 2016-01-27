.PHONY: all link bundle

all: link bundle

link: .bash_aliases .bashrc .gitconfig global_gitignore .tmux.conf .vimrc
	-$(foreach file, $^, mv -n ~/$(file) ~/$(file).local; )
	-$(foreach file, $^, ln -s $(CURDIR)/$(file) ~/$(file); )

bundle:
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim || :
	vim +BundleInstall +qall
