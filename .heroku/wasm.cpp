#include <tox/tox.h>

#include <emscripten/bind.h>

#include <array>
#include <cstdint>

using namespace emscripten;

void to_hex(char *out, uint8_t const *in, int size) {
    while (size--) {
        if (*in >> 4 < 0xA) {
            *out++ = '0' + (*in >> 4);
        } else {
            *out++ = 'A' + (*in >> 4) - 0xA;
        }

        if ((*in & 0xf) < 0xA) {
            *out++ = '0' + (*in & 0xF);
        } else {
            *out++ = 'A' + (*in & 0xF) - 0xA;
        }
        in++;
    }
}

static uint8_t const key1[] = {
    0x02, 0x80, 0x7C, 0xF4, 0xF8, 0xBB, 0x8F, 0xB3,
    0x90, 0xCC, 0x37, 0x94, 0xBD, 0xF1, 0xE8, 0x44,
    0x9E, 0x9A, 0x83, 0x92, 0xC5, 0xD3, 0xF2, 0x20,
    0x00, 0x19, 0xDA, 0x9F, 0x1E, 0x81, 0x2E, 0x46,
};

static uint8_t const key2[] = {
    0x3F, 0x0A, 0x45, 0xA2, 0x68, 0x36, 0x7C, 0x1B,
    0xEA, 0x65, 0x2F, 0x25, 0x8C, 0x85, 0xF4, 0xA6,
    0x6D, 0xA7, 0x6B, 0xCA, 0xA6, 0x67, 0xA4, 0x9E,
    0x77, 0x0B, 0xCC, 0x49, 0x17, 0xAB, 0x6A, 0x25,
};

class ToxWrapper {
public:
    std::string address() const {
        std::array<std::uint8_t, TOX_ADDRESS_SIZE> hex_address;
        tox_self_get_address(tox_, hex_address.data());
        std::string address{TOX_ADDRESS_SIZE, '\0'};
        to_hex(address.data(), hex_address.data(), TOX_ADDRESS_SIZE);
        return address;
    }

    void iterate() {
        tox_iterate(tox_, nullptr);
    }

    int connection_status() const {
        return tox_self_get_connection_status(tox_);
    }

    void bootstrap() {
        tox_bootstrap(tox_, "78.46.73.141", 33445, key1, nullptr);
        tox_bootstrap(tox_, "tox.initramfs.io", 33445, key2, nullptr);
        tox_add_tcp_relay(tox_, "78.46.73.141", 33445, key1, nullptr);
        tox_add_tcp_relay(tox_, "tox.initramfs.io", 33445, key2, nullptr);
    }

private:
    Tox *tox_{[] {
        Tox_Options *opts = tox_options_new(nullptr);
        tox_options_set_udp_enabled(opts, false);
        return tox_new(opts, nullptr);
    }()};
};

EMSCRIPTEN_BINDINGS(tox) {
    function("version_major", &tox_version_major);
    function("version_minor", &tox_version_minor);
    function("version_patch", &tox_version_patch);
    class_<ToxWrapper>("Tox")
        .constructor()
        .function("address", &ToxWrapper::address)
        .function("bootstrap", &ToxWrapper::bootstrap)
        .function("connection_status", &ToxWrapper::connection_status)
        .function("iterate", &ToxWrapper::iterate)
        ;
}
