use crate::{ErrorCode, UniflowError};

impl std::convert::From<url::ParseError> for UniflowError {
  fn from(error: url::ParseError) -> Self {
    UniflowError::new(ErrorCode::InvalidURL, "").with_context(error)
  }
}
