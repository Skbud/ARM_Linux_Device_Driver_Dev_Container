obj-m += my_module.o

# Point this to your compiled/prepared Linux kernel source tree headers
KDIR ?= ../dependency/linux

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean