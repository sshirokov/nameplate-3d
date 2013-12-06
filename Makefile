all:
	git submodule sync
	git submodule update --init --recursive
	make -C stltwalker all
	make -C csgtool all
