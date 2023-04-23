# ovos-image-arch-recipe
Manjaro arch based recipe for building OVOS images

## Docker Automated Image Building
The included Dockerfile can be used to build a default image in a Docker environment.
The following dependencies must be installed on the build system before running the
container:

* [chroot](https://wiki.debian.org/chroot)
* [qemu-user-static](https://wiki.debian.org/QemuUserEmulation)

First, create the Docker container:
```shell
docker build . -t ovos-image-builder
```

Then, run the container to create a OVOS Image. Set `CORE_REF` to the branch of
`ovos-core` that you want to build and `RECIPE_REF` to the branch of `ovos-image-recipe`
you want to use. Set `MAKE_THREADS` to the number of threads to use for `make` processes.
Set `BUILD_TYPE` for hardware target.

Manjaro arch image recipe has support for building images for two different hardware targets.

1. Respeaker Hardware Target:

``` shell
docker run --privileged \
-v ${PWD}/output/:/output:rw \
-v /run/systemd/resolve:/run/systemd/resolve \
-e CORE_REF=${CORE_REF:-dev} \
-e RECIPE_REF=${RECIPE_REF:-master} \
-e MAKE_THREADS=${MAKE_THREADS:-4} \
-e BUILD_TYPE=respeaker \
--network=host \
--name=ovos-image-builder \
ovos-image-builder
```

2. Mycroft Mark-2 and Mark-2 Dev Kit Hardware Target:

``` shell
docker run --privileged \
-v ${PWD}/output/:/output:rw \
-v /run/systemd/resolve:/run/systemd/resolve \
-e CORE_REF=${CORE_REF:-dev} \
-e RECIPE_REF=${RECIPE_REF:-master} \
-e MAKE_THREADS=${MAKE_THREADS:-4} \
-e BUILD_TYPE=mark2 \
--network=host \
--name=ovos-image-builder \
ovos-image-builder
```
