modules:
	@$(MAKE) -C $(KERNEL_SRC) M=$$(readlink -f ../wireguard-linux-compat/src) modules

modules_install:
	@$(MAKE) -C $(KERNEL_SRC) M=$$(readlink -f ../wireguard-linux-compat/src) modules_install

.PHONY: modules modules_install
