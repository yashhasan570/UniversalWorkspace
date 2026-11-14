use collab_plugins::CollabKVDB;
use uniflow_ai_pub::user_service::AIUserService;
use uniflow_error::{UniflowError, UniflowResult};
use uniflow_sqlite::DBConnection;
use uniflow_user_pub::entities::WorkspaceType;
use lib_infra::async_trait::async_trait;
use std::path::PathBuf;
use std::sync::{Arc, Weak};
use uuid::Uuid;

pub const USER_SIGN_IN_URL: &str = "sign_in_url";
pub const USER_UUID: &str = "uuid";
pub const USER_EMAIL: &str = "email";
pub const USER_DEVICE_ID: &str = "device_id";

/// Represents a user that is currently using the server.
#[async_trait]
pub trait LoggedUser: Send + Sync {
  /// different user might return different workspace id.
  fn workspace_id(&self) -> UniflowResult<Uuid>;
  fn workspace_type(&self) -> UniflowResult<WorkspaceType>;

  fn user_id(&self) -> UniflowResult<i64>;
  async fn is_local_mode(&self) -> UniflowResult<bool>;

  fn get_sqlite_db(&self, uid: i64) -> Result<DBConnection, UniflowError>;

  fn get_collab_db(&self, uid: i64) -> Result<Weak<CollabKVDB>, UniflowError>;

  fn application_root_dir(&self) -> Result<PathBuf, UniflowError>;
}

//
pub struct AIUserServiceImpl(pub Weak<dyn LoggedUser>);

impl AIUserServiceImpl {
  fn logged_user(&self) -> UniflowResult<Arc<dyn LoggedUser>> {
    self
      .0
      .upgrade()
      .ok_or_else(|| UniflowError::internal().with_context("User is not logged in"))
  }
}

#[async_trait]
impl AIUserService for AIUserServiceImpl {
  fn user_id(&self) -> Result<i64, UniflowError> {
    self.logged_user()?.user_id()
  }

  async fn is_local_model(&self) -> UniflowResult<bool> {
    self.logged_user()?.is_local_mode().await
  }

  fn workspace_id(&self) -> Result<Uuid, UniflowError> {
    self.logged_user()?.workspace_id()
  }

  fn workspace_type(&self) -> UniflowResult<WorkspaceType> {
    self.logged_user()?.workspace_type()
  }

  fn sqlite_connection(&self, uid: i64) -> Result<DBConnection, UniflowError> {
    self.logged_user()?.get_sqlite_db(uid)
  }

  fn application_root_dir(&self) -> Result<PathBuf, UniflowError> {
    self.logged_user()?.application_root_dir()
  }
}
