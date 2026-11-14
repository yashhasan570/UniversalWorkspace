use strum_macros::Display;

use uniflow_derive::{Uniflow_Event, ProtoBuf_Enum};
use lib_dispatch::prelude::AFPlugin;

use crate::event_handler::query_date_handler;

pub fn init() -> AFPlugin {
  AFPlugin::new()
    .name(env!("CARGO_PKG_NAME"))
    .event(DateEvent::QueryDate, query_date_handler)
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, Display, ProtoBuf_Enum, Uniflow_Event)]
#[event_err = "UniflowError"]
pub enum DateEvent {
  #[event(input = "DateQueryPB", output = "DateResultPB")]
  QueryDate = 0,
}
