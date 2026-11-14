use crate::entities::UserFolderPB;
use uniflow_error::{ErrorCode, UniflowError};
use uuid::Uuid;

pub(crate) fn folder_not_init_error() -> UniflowError {
  UniflowError::internal().with_context("Folder not initialized")
}

pub(crate) fn workspace_data_not_sync_error(uid: i64, workspace_id: &Uuid) -> UniflowError {
  UniflowError::from(ErrorCode::WorkspaceDataNotSync).with_payload(UserFolderPB {
    uid,
    workspace_id: workspace_id.to_string(),
  })
}
