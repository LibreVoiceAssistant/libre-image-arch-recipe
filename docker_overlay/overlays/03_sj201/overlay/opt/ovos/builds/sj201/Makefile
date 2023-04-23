BUILDDIR ?= build

all: sj201-rev10-pwm-fan.dtbo sj201-buttons.dtbo

build-dir:
	mkdir -p $(BUILDDIR)

sj201-rev10-pwm-fan.dtbo: build-dir sj201-rev10-pwm-fan-overlay.dts
	dtc -@ -Hepapr -I dts -O dtb -o build/sj201-rev10-pwm-fan.dtbo sj201-rev10-pwm-fan-overlay.dts

sj201-buttons.dtbo: build-dir sj201-buttons-overlay.dts
	dtc -@ -Hepapr -I dts -O dtb -o build/sj201-buttons.dtbo sj201-buttons-overlay.dts

install: $(BUILDDIR)/sj201-rev10-pwm-fan.dtbo $(BUILDDIR)/sj201-buttons.dtbo
	install $(BUILDDIR)/sj201-rev10-pwm-fan.dtbo /boot/overlays/
	install $(BUILDDIR)/sj201-buttons.dtbo /boot/overlays/

uninstall:
	rm -f /boot/overlays/sj201-rev10-pwm-fan.dtbo
	rm -f /boot/overlays/sj201-buttons.dtbo

clean:
	rm -rf $(BUILDDIR)