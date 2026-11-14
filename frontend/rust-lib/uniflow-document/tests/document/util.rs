use std::ops::Deref;
use std::sync::{Arc, OnceLock};

use collab::entity::EncodedCollab;
use collab::preclude::CollabPlugin;
use collab_document::blocks::DocumentData;
use collab_document::document::Document;
use collab_document::document_data::default_document_data;
use collab_integrate::CollabKVDB;
use collab_integrate::collab_builder::{
  UniversalWorkspaceCollabBuilder, CollabCloudPluginProvider, CollabPluginProviderContext,
  CollabPluginProviderType, WorkspaceCollabIntegrate,
};
use uniflow_document::entities::{DocumentSnapshotData, DocumentSnapshotMeta};
use uniflow_document::manager::{DocumentManager, DocumentSnapshotService, DocumentUserService};
use uniflow_document_pub::cloud::*;
use uniflow_error::{ErrorCode, UniflowError, UniflowResult};
use uniflow_storage_pub::storage::{CreatedUpload, FileProgressReceiver, StorageService};
use lib_infra::async_trait::async_trait;
use lib_infra::box_any::BoxAny;
use nanoid::nanoid;
use tempfile::TempDir;
use tokio::sync::RwLock;
use tracing_subscriber::{EnvFilter, fmt::Subscriber, util::SubscriberInitExt};
use uuid::Uuid;

pub struct DocumentTest {
  #[allow(dead_code)]
  builder: Arc<UniversalWorkspaceCollabBuilder>,
  inner: DocumentManager,
}

impl DocumentTest {
  pub fn new() -> Self {
    let user = FakeUser::new();
    let cloud_service = Arc::new(LocalTestDocumentCloudServiceImpl());
    let file_storage = Arc::new(DocumentTestFileStorageService) as Arc<dyn StorageService>;
    let document_snapshot = Arc::new(DocumentTestSnapshot);

    let builder = Arc::new(UniversalWorkspaceCollabBuilder::new(
      DefaultCollabStorageProvider(),
      WorkspaceCollabIntegrateImpl {
        workspace_id: user.workspace_id,
      },
      None,
    ));

    let manager = DocumentManager::new(
      Arc::new(user),
      Arc::downgrade(&builder),
      cloud_service,
      Arc::downgrade(&file_storage),
      document_snapshot,
    );
    Self {
      inner: manager,
      builder,
    }
  }
}

impl Deref for DocumentTest {
  type Target = DocumentManager;

  fn deref(&self) -> &Self::Target {
    &self.inner
  }
}

pub struct FakeUser {
  workspace_id: Uuid,
  collab_db: Arc<CollabKVDB>,
}

impl FakeUser {
  pub fn new() -> Self {
    setup_log();

    let tempdir = TempDir::new().unwrap();
    let path = tempdir.into_path();
    let collab_db = Arc::new(CollabKVDB::open(path).unwrap());
    let workspace_id = uuid::Uuid::new_v4();

    Self {
      collab_db,
      workspace_id,
    }
  }
}

impl DocumentUserService for FakeUser {
  fn user_id(&self) -> Result<i64, UniflowError> {
    Ok(1)
  }

  fn workspace_id(&self) -> Result<Uuid, UniflowError> {
    Ok(self.workspace_id)
  }

  fn collab_db(&self, _uid: i64) -> Result<std::sync::Weak<CollabKVDB>, UniflowError> {
    Ok(Arc::downgrade(&self.collab_db))
  }

  fn device_id(&self) -> Result<String, UniflowError> {
    Ok("".to_string())
  }
}

pub fn setup_log() {
  static START: OnceLock<()> = OnceLock::new();
  START.get_or_init(|| {
    unsafe {
      std::env::set_var("RUST_LOG", "collab_persistence=trace");
    }
    let subscriber = Subscriber::builder()
      .with_env_filter(EnvFilter::from_default_env())
      .with_ansi(true)
      .finish();
    subscriber.try_init().unwrap();
  });
}

pub async fn create_and_open_empty_document() -> (DocumentTest, Arc<RwLock<Document>>, String) {
  let test = DocumentTest::new();
  let doc_id = gen_document_id();
  let data = default_document_data(&doc_id.to_string());
  let uid = test.user_service.user_id().unwrap();
  // create a document
  test
    .create_document(uid, &doc_id, Some(data.clone()))
    .await
    .unwrap();

  test.open_document(&doc_id).await.unwrap();
  let document = test.editable_document(&doc_id).await.unwrap();

  (test, document, data.page_id)
}

pub fn gen_document_id() -> Uuid {
  uuid::Uuid::new_v4()
}

pub fn gen_id() -> String {
  nanoid!(10)
}

pub struct LocalTestDocumentCloudServiceImpl();

#[async_trait]
impl DocumentCloudService for LocalTestDocumentCloudServiceImpl {
  async fn get_document_doc_state(
    &self,
    document_id: &Uuid,
    _workspace_id: &Uuid,
  ) -> Result<Vec<u8>, UniflowError> {
    let document_id = document_id.to_string();
    Err(UniflowError::new(
      ErrorCode::RecordNotFound,
      format!("Document {} not found", document_id),
    ))
  }

  async fn get_document_snapshots(
    &self,
    _document_id: &Uuid,
    _limit: usize,
    _workspace_id: &str,
  ) -> Result<Vec<DocumentSnapshot>, UniflowError> {
    Ok(vec![])
  }

  async fn get_document_data(
    &self,
    _document_id: &Uuid,
    _workspace_id: &Uuid,
  ) -> Result<Option<DocumentData>, UniflowError> {
    Ok(None)
  }

  async fn create_document_collab(
    &self,
    _workspace_id: &Uuid,
    _document_id: &Uuid,
    _encoded_collab: EncodedCollab,
  ) -> Result<(), UniflowError> {
    Ok(())
  }
}

pub struct DocumentTestFileStorageService;

#[async_trait]
impl StorageService for DocumentTestFileStorageService {
  async fn delete_object(&self, _url: String) -> UniflowResult<()> {
    todo!()
  }

  fn download_object(&self, _url: String, _local_file_path: String) -> UniflowResult<()> {
    todo!()
  }

  async fn create_upload(
    &self,
    _workspace_id: &str,
    _parent_dir: &str,
    _local_file_path: &str,
  ) -> Result<(CreatedUpload, Option<FileProgressReceiver>), uniflow_error::UniflowError> {
    todo!()
  }

  async fn start_upload(&self, _record: &BoxAny) -> Result<(), UniflowError> {
    todo!()
  }

  async fn resume_upload(
    &self,
    _workspace_id: &str,
    _parent_dir: &str,
    _file_id: &str,
  ) -> Result<(), UniflowError> {
    todo!()
  }

  async fn subscribe_file_progress(
    &self,
    _parent_idr: &str,
    _url: &str,
  ) -> Result<Option<FileProgressReceiver>, UniflowError> {
    todo!()
  }
}

struct DefaultCollabStorageProvider();

#[async_trait]
impl CollabCloudPluginProvider for DefaultCollabStorageProvider {
  fn provider_type(&self) -> CollabPluginProviderType {
    CollabPluginProviderType::Local
  }

  fn get_plugins(&self, _context: CollabPluginProviderContext) -> Vec<Box<dyn CollabPlugin>> {
    vec![]
  }

  fn is_sync_enabled(&self) -> bool {
    false
  }
}

struct DocumentTestSnapshot;
impl DocumentSnapshotService for DocumentTestSnapshot {
  fn get_document_snapshot_metas(
    &self,
    _document_id: &str,
  ) -> UniflowResult<Vec<DocumentSnapshotMeta>> {
    todo!()
  }

  fn get_document_snapshot(&self, _snapshot_id: &str) -> UniflowResult<DocumentSnapshotData> {
    todo!()
  }
}

struct WorkspaceCollabIntegrateImpl {
  workspace_id: Uuid,
}
impl WorkspaceCollabIntegrate for WorkspaceCollabIntegrateImpl {
  fn workspace_id(&self) -> Result<Uuid, UniflowError> {
    Ok(self.workspace_id)
  }

  fn device_id(&self) -> Result<String, UniflowError> {
    Ok("fake_device_id".to_string())
  }
}
