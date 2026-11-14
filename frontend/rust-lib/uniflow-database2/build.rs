fn main() {
  #[cfg(feature = "dart")]
  {
    uniflow_codegen::protobuf_file::dart_gen(env!("CARGO_PKG_NAME"));
    uniflow_codegen::dart_event::r#gen(env!("CARGO_PKG_NAME"));
  }

  // #[cfg(feature = "ts")]
  // {
  //   uniflow_codegen::ts_event::gen(env!("CARGO_PKG_NAME"), uniflow_codegen::Project::Tauri);
  //   uniflow_codegen::protobuf_file::ts_gen(
  //     env!("CARGO_PKG_NAME"),
  //     env!("CARGO_PKG_NAME"),
  //     uniflow_codegen::Project::Tauri,
  //   );
  //   uniflow_codegen::ts_event::gen(env!("CARGO_PKG_NAME"), uniflow_codegen::Project::TauriApp);
  //   uniflow_codegen::protobuf_file::ts_gen(
  //     env!("CARGO_PKG_NAME"),
  //     env!("CARGO_PKG_NAME"),
  //     uniflow_codegen::Project::TauriApp,
  //   );
  // }
}
