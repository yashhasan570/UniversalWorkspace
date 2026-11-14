use tantivy::{directory::error::OpenDirectoryError, query::QueryParserError, TantivyError};

use crate::{ErrorCode, UniflowError};

impl std::convert::From<TantivyError> for UniflowError {
  fn from(error: TantivyError) -> Self {
    UniflowError::new(ErrorCode::IndexWriterFailedCommit, error)
  }
}

impl std::convert::From<OpenDirectoryError> for UniflowError {
  fn from(error: OpenDirectoryError) -> Self {
    UniflowError::new(ErrorCode::FailedToOpenIndexDir, error)
  }
}

impl std::convert::From<QueryParserError> for UniflowError {
  fn from(error: QueryParserError) -> Self {
    UniflowError::new(ErrorCode::FailedToParseQuery, error)
  }
}
