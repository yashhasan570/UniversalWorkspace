use reqwest::Error;

use crate::UniflowError;

impl std::convert::From<reqwest::Error> for UniflowError {
  fn from(error: Error) -> Self {
    UniflowError::http().with_context(error)
  }
}
