use uniflow_error::{UniflowError, UniflowResult};
use uniflow_sqlite::DBConnection;
use uniflow_user_pub::entities::WorkspaceType;
use lib_infra::async_trait::async_trait;
use std::path::PathBuf;
use uuid::Uuid;

#[async_trait]
pub trait AIUserService: Send + Sync + 'static {
  fn user_id(&self) -> Result<i64, UniflowError>;
  async fn is_local_model(&self) -> UniflowResult<bool>;
  fn workspace_id(&self) -> Result<Uuid, UniflowError>;

  fn workspace_type(&self) -> UniflowResult<WorkspaceType>;

  fn sqlite_connection(&self, uid: i64) -> Result<DBConnection, UniflowError>;
  fn application_root_dir(&self) -> Result<PathBuf, UniflowError>;
}
