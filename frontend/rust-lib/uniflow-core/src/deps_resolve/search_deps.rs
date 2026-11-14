use uniflow_folder::manager::FolderManager;
use uniflow_search::document::cloud_search_handler::DocumentCloudSearchHandler;
use uniflow_search::services::manager::SearchManager;
use uniflow_search_pub::cloud::SearchCloudService;
use std::sync::Arc;

pub struct SearchDepsResolver();
impl SearchDepsResolver {
  pub async fn resolve(
    cloud_service: Arc<dyn SearchCloudService>,
    folder_manager: Arc<FolderManager>,
  ) -> Arc<SearchManager> {
    // let folder_handler = Arc::new(FolderSearchHandler::new(folder_indexer));
    let document_handler = Arc::new(DocumentCloudSearchHandler::new(
      cloud_service,
      folder_manager,
    ));
    Arc::new(SearchManager::new(vec![document_handler]))
  }
}
