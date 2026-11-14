use collab_folder::hierarchy_builder::ParentChildViews;
use uniflow_error::UniflowResult;
use uniflow_folder_pub::entities::ImportFrom;
use lib_infra::async_trait::async_trait;
use std::collections::HashMap;

#[async_trait]
pub trait UserWorkspaceService: Send + Sync {
  async fn import_views(
    &self,
    source: &ImportFrom,
    views: Vec<ParentChildViews>,
    orphan_views: Vec<ParentChildViews>,
    parent_view_id: Option<String>,
  ) -> UniflowResult<()>;
  async fn import_database_views(
    &self,
    ids_by_database_id: HashMap<String, Vec<String>>,
  ) -> UniflowResult<()>;
}
