use crate::UniflowError;

impl std::convert::From<serde_json::Error> for UniflowError {
  fn from(error: serde_json::Error) -> Self {
    UniflowError::serde().with_context(error)
  }
}
