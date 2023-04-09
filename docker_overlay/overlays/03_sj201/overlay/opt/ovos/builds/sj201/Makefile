BUILDDIR ?= build

all: sj201-pwm-fan.dtbo

build-dir:
	mkdir -p $(BUILDDIR)

sj201-pwm-fan.dtbo: build-dir sj201-pwm-fan-overlay.dts
	dtc -@ -Hepapr -I dts -O dtb -o build/sj201-pwm-fan.dtbo sj201-pwm-fan-overlay.dts

install: $(BUILDDIR)/sj201-pwm-fan.dtbo
	install $(BUILDDIR)/sj201-pwm-fan.dtbo /boot/overlays/

uninstall:
	rm -f /boot/overlays/sj201-pwm-fan.dtbo

clean:
	rm -rf $(BUILDDIR)