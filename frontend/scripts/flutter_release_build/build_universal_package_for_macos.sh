# build the universal binary for UniversalWorkspace on macOS

echo '🚀 ---------------------------------------------------'
echo '🚀 building libdart_ffi.a(x86_64) for UniversalWorkspace on macOS'
cargo make --profile production-mac-x86_64 universalworkspace-core-release

echo '🚀 ---------------------------------------------------'
echo '🚀 building libdart_ffi.a(arm64) for UniversalWorkspace on macOS'
cargo make --profile production-mac-arm64 universalworkspace-core-release

echo '🚀 -------------------------------------------------------'
echo '🚀 building libdart_ffi.a(universal) for UniversalWorkspace on macOS'
lipo -create \
    rust-lib/target/x86_64-apple-darwin/release/libdart_ffi.a \
    rust-lib/target/aarch64-apple-darwin/release/libdart_ffi.a \
    -output rust-lib/target/libdart_ffi.a

lipo -archs rust-lib/target/libdart_ffi.a

echo '🚀 ------------------------------------------------------------'
echo '🚀 moving libdart_ffi.a(universal) for UniversalWorkspace Backend Package'
cp -rf rust-lib/target/libdart_ffi.a \
    universalworkspace_flutter/packages/universalworkspace_backend/macos/

echo '🚀 ---------------------------------------------------'
echo '🚀 building the flutter application for macOS'
cargo make --env APP_VERSION=$1 --profile production-mac-universal universalworkspace-macos-universal
