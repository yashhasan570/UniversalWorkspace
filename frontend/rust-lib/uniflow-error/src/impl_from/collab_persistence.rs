use crate::{ErrorCode, UniflowError};
#[cfg(feature = "impl_from_collab_persistence")]
use collab_plugins::local_storage::kv::PersistenceError;

#[cfg(feature = "impl_from_collab_persistence")]
impl From<PersistenceError> for UniflowError {
  fn from(err: PersistenceError) -> Self {
    match err {
      PersistenceError::UnexpectedEmptyUpdates => UniflowError::new(ErrorCode::RecordNotFound, err),
      #[cfg(not(target_arch = "wasm32"))]
      PersistenceError::RocksdbCorruption(_) => UniflowError::new(ErrorCode::RocksdbCorruption, err),
      #[cfg(not(target_arch = "wasm32"))]
      PersistenceError::RocksdbIOError(_) => UniflowError::new(ErrorCode::RocksdbIOError, err),
      _ => UniflowError::new(ErrorCode::RocksdbInternal, err),
    }
  }
}
