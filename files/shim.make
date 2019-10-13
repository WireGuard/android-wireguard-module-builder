modules:
	@$(MAKE) -C $(KERNEL_SRC) M=$$(readlink -f ../WireGuard/src) modules

modules_install:
	@$(MAKE) -C $(KERNEL_SRC) M=$$(readlink -f ../WireGuard/src) modules_install

.PHONY: modules modules_install
