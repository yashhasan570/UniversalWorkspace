use collab_integrate::collab_builder::UniversalWorkspaceCollabBuilder;
use collab_integrate::CollabKVDB;
use uniflow_ai::ai_manager::AIManager;
use uniflow_database2::{DatabaseManager, DatabaseUser};
use uniflow_database_pub::cloud::{
  DatabaseAIService, DatabaseCloudService, SummaryRowContent, TranslateRowContent,
  TranslateRowResponse,
};
use uniflow_error::UniflowError;
use uniflow_user::services::authenticate_user::AuthenticateUser;
use lib_infra::async_trait::async_trait;
use lib_infra::priority_task::TaskDispatcher;
use std::sync::{Arc, Weak};
use tokio::sync::RwLock;
use uuid::Uuid;

pub struct DatabaseDepsResolver();

impl DatabaseDepsResolver {
  pub async fn resolve(
    authenticate_user: Weak<AuthenticateUser>,
    task_scheduler: Arc<RwLock<TaskDispatcher>>,
    collab_builder: Weak<UniversalWorkspaceCollabBuilder>,
    cloud_service: Arc<dyn DatabaseCloudService>,
    ai_service: Arc<dyn DatabaseAIService>,
    ai_manager: Arc<AIManager>,
  ) -> Arc<DatabaseManager> {
    let user = Arc::new(DatabaseUserImpl(authenticate_user));
    Arc::new(DatabaseManager::new(
      user,
      task_scheduler,
      collab_builder,
      cloud_service,
      Arc::new(DatabaseAIServiceMiddleware {
        ai_manager,
        ai_service,
      }),
    ))
  }
}

struct DatabaseAIServiceMiddleware {
  ai_manager: Arc<AIManager>,
  ai_service: Arc<dyn DatabaseAIService>,
}
#[async_trait]
impl DatabaseAIService for DatabaseAIServiceMiddleware {
  async fn summary_database_row(
    &self,
    workspace_id: &Uuid,
    object_id: &Uuid,
    summary_row: SummaryRowContent,
  ) -> Result<String, UniflowError> {
    if self
      .ai_manager
      .local_ai
      .is_enabled_on_workspace(&workspace_id.to_string())
    {
      let model = self
        .ai_manager
        .get_active_model(&object_id.to_string())
        .await;
      self
        .ai_manager
        .local_ai
        .summarize_database_row(&model.name, summary_row)
        .await
    } else {
      self
        .ai_service
        .summary_database_row(workspace_id, object_id, summary_row)
        .await
    }
  }

  async fn translate_database_row(
    &self,
    workspace_id: &Uuid,
    translate_row: TranslateRowContent,
    language: &str,
  ) -> Result<TranslateRowResponse, UniflowError> {
    if self
      .ai_manager
      .local_ai
      .is_enabled_on_workspace(&workspace_id.to_string())
    {
      let model = self
        .ai_manager
        .get_active_model(&workspace_id.to_string())
        .await;
      self
        .ai_manager
        .local_ai
        .translate_database_row(&model.name, translate_row, language)
        .await
    } else {
      self
        .ai_service
        .translate_database_row(workspace_id, translate_row, language)
        .await
    }
  }
}

struct DatabaseUserImpl(Weak<AuthenticateUser>);
impl DatabaseUserImpl {
  fn upgrade_user(&self) -> Result<Arc<AuthenticateUser>, UniflowError> {
    let user = self
      .0
      .upgrade()
      .ok_or(UniflowError::internal().with_context("Unexpected error: UserSession is None"))?;
    Ok(user)
  }
}

impl DatabaseUser for DatabaseUserImpl {
  fn user_id(&self) -> Result<i64, UniflowError> {
    self.upgrade_user()?.user_id()
  }

  fn collab_db(&self, uid: i64) -> Result<Weak<CollabKVDB>, UniflowError> {
    self.upgrade_user()?.get_collab_db(uid)
  }

  fn workspace_id(&self) -> Result<Uuid, UniflowError> {
    self.upgrade_user()?.workspace_id()
  }

  fn workspace_database_object_id(&self) -> Result<Uuid, UniflowError> {
    self.upgrade_user()?.workspace_database_object_id()
  }
}
