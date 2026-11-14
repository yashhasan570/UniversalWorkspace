use crate::server_layer::ServerProvider;
use collab_folder::hierarchy_builder::ParentChildViews;
use collab_integrate::collab_builder::UniversalWorkspaceCollabBuilder;
use uniflow_database2::DatabaseManager;
use uniflow_error::{UniflowError, UniflowResult};
use uniflow_folder::manager::FolderManager;
use uniflow_folder_pub::entities::ImportFrom;
use uniflow_sqlite::kv::KVStorePreferences;
use uniflow_user::services::authenticate_user::AuthenticateUser;
use uniflow_user::user_manager::UserManager;
use uniflow_user_pub::workspace_service::UserWorkspaceService;
use lib_infra::async_trait::async_trait;
use std::collections::HashMap;
use std::sync::{Arc, Weak};

pub struct UserDepsResolver();

impl UserDepsResolver {
  pub async fn resolve(
    authenticate_user: Arc<AuthenticateUser>,
    collab_builder: Weak<UniversalWorkspaceCollabBuilder>,
    server_provider: Weak<ServerProvider>,
    store_preference: Arc<KVStorePreferences>,
    database_manager: Weak<DatabaseManager>,
    folder_manager: Weak<FolderManager>,
  ) -> Arc<UserManager> {
    let workspace_service_impl = Arc::new(UserWorkspaceServiceImpl {
      database_manager,
      folder_manager,
    });
    UserManager::new(
      server_provider,
      store_preference,
      collab_builder,
      authenticate_user,
      workspace_service_impl,
    )
  }
}

pub struct UserWorkspaceServiceImpl {
  pub database_manager: Weak<DatabaseManager>,
  pub folder_manager: Weak<FolderManager>,
}

#[async_trait]
impl UserWorkspaceService for UserWorkspaceServiceImpl {
  async fn import_views(
    &self,
    source: &ImportFrom,
    views: Vec<ParentChildViews>,
    orphan_views: Vec<ParentChildViews>,
    parent_view_id: Option<String>,
  ) -> UniflowResult<()> {
    match source {
      ImportFrom::AnonUser => {
        self
          .folder_manager
          .upgrade()
          .ok_or_else(UniflowError::ref_drop)?
          .insert_views_as_spaces(views, orphan_views)
          .await?;
      },
      ImportFrom::UniversalWorkspaceDataFolder => {
        self
          .folder_manager
          .upgrade()
          .ok_or_else(UniflowError::ref_drop)?
          .insert_views_with_parent(views, orphan_views, parent_view_id)
          .await?;
      },
    }
    Ok(())
  }

  async fn import_database_views(
    &self,
    ids_by_database_id: HashMap<String, Vec<String>>,
  ) -> UniflowResult<()> {
    self
      .database_manager
      .upgrade()
      .ok_or_else(UniflowError::ref_drop)?
      .update_database_indexing(ids_by_database_id)
      .await?;
    Ok(())
  }
}
