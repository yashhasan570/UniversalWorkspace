#![allow(unused_variables)]
use collab::entity::EncodedCollab;
use uniflow_document_pub::cloud::*;
use uniflow_error::{ErrorCode, UniflowError};
use lib_infra::async_trait::async_trait;
use uuid::Uuid;

pub(crate) struct LocalServerDocumentCloudServiceImpl();

#[async_trait]
impl DocumentCloudService for LocalServerDocumentCloudServiceImpl {
  async fn get_document_doc_state(
    &self,
    document_id: &Uuid,
    workspace_id: &Uuid,
  ) -> Result<Vec<u8>, UniflowError> {
    let document_id = document_id.to_string();

    Err(UniflowError::new(
      ErrorCode::RecordNotFound,
      format!("Document {} not found", document_id),
    ))
  }

  async fn get_document_snapshots(
    &self,
    document_id: &Uuid,
    limit: usize,
    workspace_id: &str,
  ) -> Result<Vec<DocumentSnapshot>, UniflowError> {
    Ok(vec![])
  }

  async fn get_document_data(
    &self,
    document_id: &Uuid,
    workspace_id: &Uuid,
  ) -> Result<Option<DocumentData>, UniflowError> {
    Ok(None)
  }

  async fn create_document_collab(
    &self,
    workspace_id: &Uuid,
    document_id: &Uuid,
    encoded_collab: EncodedCollab,
  ) -> Result<(), UniflowError> {
    Ok(())
  }
}
