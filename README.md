# bTox

A work-in-progress cross-platform Tox client.

## Setting up Flutter

Follow the instructions on https://docs.flutter.dev/get-started/

## Building

Run the `tools/prepare-web` setup script to generate the database bindings that need to be generated
and download the 3rd-party libraries used in the web build.

```sh
./tools/prepare-web # or ./tools/prepare if you don't want to download the web-build 3rd-party libraries.
```

After the above is done, just build as you normally would for whatever platform you want to target.

If you run into issues, consulting [our CI](.github/workflows/ci.yml) might be helpful as it
contains working build instructions for all platforms.
