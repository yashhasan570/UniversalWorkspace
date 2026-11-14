use crate::deps_resolve::MultiSourceVSTanvityImpl;
use crate::UniversalWorkspaceCoreConfig;
use arc_swap::{ArcSwap, ArcSwapOption};
use collab::entity::EncodedCollab;
use collab_entity::CollabType;
use collab_integrate::instant_indexed_data_provider::InstantIndexedDataWriter;
use dashmap::try_result::TryResult;
use dashmap::DashMap;
use uniflow_ai::local_ai::controller::LocalAIController;
use uniflow_ai_pub::entities::UnindexedCollab;
use uniflow_error::{UniflowError, UniflowResult};
use uniflow_search_pub::tantivy_state::DocumentTantivyState;
use uniflow_server::af_cloud::define::AIUserServiceImpl;
use uniflow_server::af_cloud::{define::LoggedUser, UniversalWorkspaceCloudServer};
use uniflow_server::local_server::LocalServer;
use uniflow_server::{UniversalWorkspaceEncryption, UniversalWorkspaceServer, EmbeddingWriter, EncryptionImpl};
use uniflow_server_pub::AuthenticatorType;
use uniflow_sqlite::kv::KVStorePreferences;
use uniflow_user_pub::entities::*;
use lib_infra::async_trait::async_trait;
use std::sync::atomic::{AtomicBool, Ordering};
use std::sync::{Arc, Weak};
use tokio::sync::RwLock;
use tracing::{error, info};
use uuid::Uuid;

pub struct ServerProvider {
  config: UniversalWorkspaceCoreConfig,
  providers: DashMap<AuthType, Arc<dyn UniversalWorkspaceServer>>,
  auth_type: ArcSwap<AuthType>,
  logged_user: Arc<dyn LoggedUser>,
  pub local_ai: Arc<LocalAIController>,
  pub uid: Arc<ArcSwapOption<i64>>,
  pub user_enable_sync: Arc<AtomicBool>,
  pub encryption: Arc<dyn UniversalWorkspaceEncryption>,
  pub indexed_data_writer: Option<Weak<InstantIndexedDataWriter>>,
}

// Our little guard wrapper:

/// Determine current server type from ENV
pub fn current_server_type() -> AuthType {
  match AuthenticatorType::from_env() {
    AuthenticatorType::Local => AuthType::Local,
    AuthenticatorType::UniversalWorkspaceCloud => AuthType::UniversalWorkspaceCloud,
  }
}

impl ServerProvider {
  pub fn new(
    config: UniversalWorkspaceCoreConfig,
    store_preferences: Weak<KVStorePreferences>,
    user_service: impl LoggedUser + 'static,
    indexed_data_writer: Option<Weak<InstantIndexedDataWriter>>,
  ) -> Self {
    let initial_auth = current_server_type();
    let logged_user = Arc::new(user_service) as Arc<dyn LoggedUser>;
    let auth_type = ArcSwap::from(Arc::new(initial_auth));
    let encryption = Arc::new(EncryptionImpl::new(None)) as Arc<dyn UniversalWorkspaceEncryption>;
    let ai_user = Arc::new(AIUserServiceImpl(Arc::downgrade(&logged_user)));
    let local_ai = Arc::new(LocalAIController::new(store_preferences, ai_user.clone()));

    ServerProvider {
      config,
      providers: DashMap::new(),
      encryption,
      user_enable_sync: Arc::new(AtomicBool::new(true)),
      auth_type,
      logged_user,
      uid: Default::default(),
      local_ai,
      indexed_data_writer,
    }
  }

  async fn set_tanvity_state(&self, tanvity_state: Option<Weak<RwLock<DocumentTantivyState>>>) {
    let tanvity_store = Arc::new(MultiSourceVSTanvityImpl::new(tanvity_state.clone()));

    self
      .local_ai
      .set_retriever_sources(vec![tanvity_store])
      .await;

    match self.providers.try_get(self.auth_type.load().as_ref()) {
      TryResult::Present(r) => {
        r.set_tanvity_state(tanvity_state).await;
      },
      TryResult::Absent => {},
      TryResult::Locked => {
        error!("ServerProvider: Failed to get server for auth type");
      },
    }
  }

  pub async fn on_launch_if_authenticated(
    &self,
    tanvity_state: Option<Weak<RwLock<DocumentTantivyState>>>,
  ) {
    self.set_tanvity_state(tanvity_state).await;
  }

  pub async fn on_sign_in(&self, tanvity_state: Option<Weak<RwLock<DocumentTantivyState>>>) {
    self.set_tanvity_state(tanvity_state).await;
  }

  pub async fn on_workspace_opened(
    &self,
    tanvity_state: Option<Weak<RwLock<DocumentTantivyState>>>,
  ) {
    self.set_tanvity_state(tanvity_state).await;
  }

  pub fn set_auth_type(&self, new_auth_type: AuthType) {
    let old_type = self.get_auth_type();
    if old_type != new_auth_type {
      info!(
        "ServerProvider: auth type from {:?} to {:?}",
        old_type, new_auth_type
      );

      self.auth_type.store(Arc::new(new_auth_type));
      if let Some((auth_type, _)) = self.providers.remove(&old_type) {
        info!("ServerProvider: remove old auth type: {:?}", auth_type);
      }
    }
  }

  pub fn get_auth_type(&self) -> AuthType {
    *self.auth_type.load_full().as_ref()
  }

  /// Lazily create or fetch an UniversalWorkspaceServer instance
  pub fn get_server(&self) -> UniflowResult<Arc<dyn UniversalWorkspaceServer>> {
    let auth_type = self.get_auth_type();
    if let Some(r) = self.providers.get(&auth_type) {
      return Ok(r.value().clone());
    }

    let server: Arc<dyn UniversalWorkspaceServer> = match auth_type {
      AuthType::Local => {
        let embedding_writer = self.indexed_data_writer.clone().map(|w| {
          Arc::new(EmbeddingWriterImpl {
            indexed_data_writer: w,
          }) as Arc<dyn EmbeddingWriter>
        });
        Arc::new(LocalServer::new(
          self.logged_user.clone(),
          self.local_ai.clone(),
          embedding_writer,
        ))
      },
      AuthType::UniversalWorkspaceCloud => {
        let cfg = self
          .config
          .cloud_config
          .clone()
          .ok_or_else(|| UniflowError::internal().with_context("Missing cloud config"))?;
        let ai_user_service = Arc::new(AIUserServiceImpl(Arc::downgrade(&self.logged_user)));
        Arc::new(UniversalWorkspaceCloudServer::new(
          cfg,
          self.user_enable_sync.load(Ordering::Acquire),
          self.config.device_id.clone(),
          self.config.app_version.clone(),
          Arc::downgrade(&self.logged_user),
          ai_user_service,
        ))
      },
    };

    self.providers.insert(auth_type, server);
    let guard = self.providers.get(&auth_type).unwrap();
    Ok(guard.clone())
  }
}

struct EmbeddingWriterImpl {
  indexed_data_writer: Weak<InstantIndexedDataWriter>,
}

#[async_trait]
impl EmbeddingWriter for EmbeddingWriterImpl {
  async fn index_encoded_collab(
    &self,
    workspace_id: Uuid,
    object_id: Uuid,
    data: EncodedCollab,
    collab_type: CollabType,
  ) -> UniflowResult<()> {
    let indexed_data_writer = self.indexed_data_writer.upgrade().ok_or_else(|| {
      UniflowError::internal().with_context("Failed to upgrade InstantIndexedDataWriter")
    })?;
    indexed_data_writer
      .index_encoded_collab(workspace_id, object_id, data, collab_type)
      .await?;
    Ok(())
  }

  async fn index_unindexed_collab(&self, data: UnindexedCollab) -> UniflowResult<()> {
    let indexed_data_writer = self.indexed_data_writer.upgrade().ok_or_else(|| {
      UniflowError::internal().with_context("Failed to upgrade InstantIndexedDataWriter")
    })?;
    indexed_data_writer.index_unindexed_collab(data).await?;
    Ok(())
  }
}
