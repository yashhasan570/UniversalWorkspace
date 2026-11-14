use crate::UniflowError;
use uniflow_sqlite::Error;

impl std::convert::From<uniflow_sqlite::Error> for UniflowError {
  fn from(error: uniflow_sqlite::Error) -> Self {
    match error {
      Error::NotFound => UniflowError::record_not_found(),
      _ => UniflowError::internal().with_context(error),
    }
  }
}

impl std::convert::From<::r2d2::Error> for UniflowError {
  fn from(error: r2d2::Error) -> Self {
    UniflowError::internal().with_context(error)
  }
}
