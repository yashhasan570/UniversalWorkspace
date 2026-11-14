use collab::entity::EncodedCollab;
pub use collab_document::blocks::DocumentData;
use uniflow_error::UniflowError;
use lib_infra::async_trait::async_trait;
use uuid::Uuid;

/// A trait for document cloud service.
/// Each kind of server should implement this trait. Check out the [UniversalWorkspaceServerProvider] of
/// [uniflow-server] crate for more information.
#[async_trait]
pub trait DocumentCloudService: Send + Sync + 'static {
  async fn get_document_doc_state(
    &self,
    document_id: &Uuid,
    workspace_id: &Uuid,
  ) -> Result<Vec<u8>, UniflowError>;

  async fn get_document_snapshots(
    &self,
    document_id: &Uuid,
    limit: usize,
    workspace_id: &str,
  ) -> Result<Vec<DocumentSnapshot>, UniflowError>;

  async fn get_document_data(
    &self,
    document_id: &Uuid,
    workspace_id: &Uuid,
  ) -> Result<Option<DocumentData>, UniflowError>;

  async fn create_document_collab(
    &self,
    workspace_id: &Uuid,
    document_id: &Uuid,
    encoded_collab: EncodedCollab,
  ) -> Result<(), UniflowError>;
}

pub struct DocumentSnapshot {
  pub snapshot_id: i64,
  pub document_id: String,
  pub data: Vec<u8>,
  pub created_at: i64,
}
