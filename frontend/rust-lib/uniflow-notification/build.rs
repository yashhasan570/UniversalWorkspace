fn main() {
  #[cfg(feature = "dart")]
  uniflow_codegen::protobuf_file::dart_gen(env!("CARGO_PKG_NAME"));
}
