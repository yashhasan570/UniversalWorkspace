use std::sync::Weak;
use strum_macros::Display;

use uniflow_derive::{Uniflow_Event, ProtoBuf_Enum};
use lib_dispatch::prelude::*;

use crate::{event_handler::stream_search_handler, services::manager::SearchManager};

pub fn init(search_manager: Weak<SearchManager>) -> AFPlugin {
  AFPlugin::new()
    .state(search_manager)
    .name(env!("CARGO_PKG_NAME"))
    .event(SearchEvent::StreamSearch, stream_search_handler)
}

#[derive(Clone, Copy, PartialEq, Eq, Debug, Display, Hash, ProtoBuf_Enum, Uniflow_Event)]
#[event_err = "UniflowError"]
pub enum SearchEvent {
  #[event(input = "SearchQueryPB")]
  StreamSearch = 0,
}
