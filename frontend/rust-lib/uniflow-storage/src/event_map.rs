use crate::event_handler::{query_file_handler, register_stream_handler};
use crate::manager::StorageManager;
use uniflow_derive::{Uniflow_Event, ProtoBuf_Enum};
use lib_dispatch::prelude::*;
use std::sync::Weak;
use strum_macros::Display;

pub fn init(manager: Weak<StorageManager>) -> AFPlugin {
  AFPlugin::new()
    .name("file-storage")
    .state(manager)
    .event(FileStorageEvent::RegisterStream, register_stream_handler)
    .event(FileStorageEvent::QueryFile, query_file_handler)
}

#[derive(Clone, Copy, PartialEq, Eq, Debug, Display, Hash, ProtoBuf_Enum, Uniflow_Event)]
#[event_err = "UniflowError"]
pub enum FileStorageEvent {
  /// Create a new workspace
  #[event(input = "RegisterStreamPB")]
  RegisterStream = 0,

  #[event(input = "QueryFilePB", output = "FileStatePB")]
  QueryFile = 1,
}
