use collab::error::CollabError;
use protobuf::ProtobufError;
use std::convert::TryInto;
use std::fmt::{Debug, Display};
use thiserror::Error;
use tokio::task::JoinError;
use validator::{ValidationError, ValidationErrors};

use uniflow_derive::ProtoBuf;

use crate::code::ErrorCode;

pub type UniflowResult<T> = anyhow::Result<T, UniflowError>;

#[derive(Debug, Default, Clone, ProtoBuf, Error)]
#[error("code:{code}, message:{msg}")]
pub struct UniflowError {
  #[pb(index = 1)]
  pub code: ErrorCode,

  #[pb(index = 2)]
  pub msg: String,

  #[pb(index = 3)]
  pub payload: Vec<u8>,
}

macro_rules! static_uniflow_error {
  ($name:ident, $code:expr) => {
    #[allow(non_snake_case, missing_docs)]
    pub fn $name() -> UniflowError {
      $code.into()
    }
  };
}

impl UniflowError {
  pub fn new<T: ToString>(code: ErrorCode, msg: T) -> Self {
    Self {
      code,
      msg: msg.to_string(),
      payload: vec![],
    }
  }
  pub fn with_context<T: Display>(mut self, error: T) -> Self {
    self.msg = format!("{}", error);
    self
  }

  pub fn with_payload<T: TryInto<Vec<u8>, Error = ProtobufError>>(mut self, payload: T) -> Self {
    self.payload = payload.try_into().unwrap_or_default();
    self
  }

  pub fn is_record_not_found(&self) -> bool {
    self.code == ErrorCode::RecordNotFound
  }

  pub fn is_already_exists(&self) -> bool {
    self.code == ErrorCode::RecordAlreadyExists
  }

  pub fn is_unauthorized(&self) -> bool {
    self.code == ErrorCode::UserUnauthorized || self.code == ErrorCode::RecordNotFound
  }

  pub fn is_invalid_data(&self) -> bool {
    self.code == ErrorCode::InvalidParams
  }

  pub fn is_local_version_not_support(&self) -> bool {
    self.code == ErrorCode::LocalVersionNotSupport
  }

  pub fn is_file_limit_exceeded(&self) -> bool {
    self.code == ErrorCode::FileStorageLimitExceeded
  }

  pub fn is_single_file_limit_exceeded(&self) -> bool {
    self.code == ErrorCode::SingleUploadLimitExceeded
  }

  pub fn should_retry_upload(&self) -> bool {
    !matches!(
      self.code,
      ErrorCode::FileStorageLimitExceeded | ErrorCode::SingleUploadLimitExceeded
    )
  }

  pub fn is_ai_response_limit_exceeded(&self) -> bool {
    self.code == ErrorCode::AIResponseLimitExceeded
  }

  pub fn is_ai_image_response_limit_exceeded(&self) -> bool {
    self.code == ErrorCode::AIImageResponseLimitExceeded
  }

  pub fn is_local_ai_not_ready(&self) -> bool {
    self.code == ErrorCode::LocalAINotReady
  }

  pub fn is_local_ai_disabled(&self) -> bool {
    self.code == ErrorCode::LocalAIDisabled
  }

  pub fn is_ai_max_required(&self) -> bool {
    self.code == ErrorCode::AIMaxRequired
  }

  static_uniflow_error!(internal, ErrorCode::Internal);
  static_uniflow_error!(record_not_found, ErrorCode::RecordNotFound);
  static_uniflow_error!(workspace_initialize, ErrorCode::WorkspaceInitializeError);
  static_uniflow_error!(view_name, ErrorCode::ViewNameInvalid);
  static_uniflow_error!(view_thumbnail, ErrorCode::ViewThumbnailInvalid);
  static_uniflow_error!(invalid_view_id, ErrorCode::ViewIdIsInvalid);
  static_uniflow_error!(view_data, ErrorCode::ViewDataInvalid);
  static_uniflow_error!(unauthorized, ErrorCode::UserUnauthorized);
  static_uniflow_error!(email_empty, ErrorCode::EmailIsEmpty);
  static_uniflow_error!(email_format, ErrorCode::EmailFormatInvalid);
  static_uniflow_error!(email_exist, ErrorCode::EmailAlreadyExists);
  static_uniflow_error!(password_empty, ErrorCode::PasswordIsEmpty);
  static_uniflow_error!(passworkd_too_long, ErrorCode::PasswordTooLong);
  static_uniflow_error!(
    password_forbid_char,
    ErrorCode::PasswordContainsForbidCharacters
  );
  static_uniflow_error!(password_format, ErrorCode::PasswordFormatInvalid);
  static_uniflow_error!(password_not_match, ErrorCode::PasswordNotMatch);
  static_uniflow_error!(name_too_long, ErrorCode::UserNameTooLong);
  static_uniflow_error!(
    name_forbid_char,
    ErrorCode::UserNameContainForbiddenCharacters
  );
  static_uniflow_error!(name_empty, ErrorCode::UserNameIsEmpty);
  static_uniflow_error!(user_id, ErrorCode::UserIdInvalid);
  static_uniflow_error!(text_too_long, ErrorCode::TextTooLong);
  static_uniflow_error!(invalid_data, ErrorCode::InvalidParams);
  static_uniflow_error!(out_of_bounds, ErrorCode::OutOfBounds);
  static_uniflow_error!(serde, ErrorCode::Serde);
  static_uniflow_error!(field_record_not_found, ErrorCode::FieldRecordNotFound);
  static_uniflow_error!(payload_none, ErrorCode::UnexpectedEmpty);
  static_uniflow_error!(http, ErrorCode::NetworkError);
  static_uniflow_error!(
    unexpect_calendar_field_type,
    ErrorCode::UnexpectedCalendarFieldType
  );
  static_uniflow_error!(collab_not_sync, ErrorCode::CollabDataNotSync);
  static_uniflow_error!(server_error, ErrorCode::InternalServerError);
  static_uniflow_error!(not_support, ErrorCode::NotSupportYet);
  static_uniflow_error!(local_version_not_support, ErrorCode::LocalVersionNotSupport);
  static_uniflow_error!(
    folder_index_manager_unavailable,
    ErrorCode::FolderIndexManagerUnavailable
  );
  static_uniflow_error!(workspace_data_not_match, ErrorCode::WorkspaceDataNotMatch);
  static_uniflow_error!(local_ai, ErrorCode::LocalAIError);
  static_uniflow_error!(local_ai_unavailable, ErrorCode::LocalAIUnavailable);
  static_uniflow_error!(response_timeout, ErrorCode::ResponseTimeout);
  static_uniflow_error!(file_storage_limit, ErrorCode::FileStorageLimitExceeded);

  static_uniflow_error!(view_is_locked, ErrorCode::ViewIsLocked);
  static_uniflow_error!(local_ai_not_ready, ErrorCode::LocalAINotReady);
  static_uniflow_error!(local_ai_disabled, ErrorCode::LocalAIDisabled);
  static_uniflow_error!(user_not_login, ErrorCode::UserNotLogin);
  static_uniflow_error!(ref_drop, ErrorCode::WeakRefDrop);
}

impl std::convert::From<ErrorCode> for UniflowError {
  fn from(code: ErrorCode) -> Self {
    let msg = format!("{}", code);
    UniflowError {
      code,
      msg,
      payload: vec![],
    }
  }
}

pub fn internal_error<T>(e: T) -> UniflowError
where
  T: std::fmt::Debug,
{
  UniflowError::internal().with_context(format!("{:?}", e))
}

impl std::convert::From<std::io::Error> for UniflowError {
  fn from(error: std::io::Error) -> Self {
    UniflowError::internal().with_context(error)
  }
}

impl std::convert::From<protobuf::ProtobufError> for UniflowError {
  fn from(e: protobuf::ProtobufError) -> Self {
    UniflowError::internal().with_context(e)
  }
}

impl From<ValidationError> for UniflowError {
  fn from(value: ValidationError) -> Self {
    UniflowError::new(ErrorCode::InvalidParams, value)
  }
}

impl From<ValidationErrors> for UniflowError {
  fn from(value: ValidationErrors) -> Self {
    UniflowError::new(ErrorCode::InvalidParams, value)
  }
}

impl From<anyhow::Error> for UniflowError {
  fn from(e: anyhow::Error) -> Self {
    e.downcast::<UniflowError>()
      .unwrap_or_else(|err| UniflowError::new(ErrorCode::Internal, err))
  }
}

impl From<fancy_regex::Error> for UniflowError {
  fn from(e: fancy_regex::Error) -> Self {
    UniflowError::internal().with_context(e)
  }
}

impl From<JoinError> for UniflowError {
  fn from(e: JoinError) -> Self {
    UniflowError::internal().with_context(e)
  }
}

impl From<tokio::sync::oneshot::error::RecvError> for UniflowError {
  fn from(e: tokio::sync::oneshot::error::RecvError) -> Self {
    UniflowError::internal().with_context(e)
  }
}

impl From<String> for UniflowError {
  fn from(e: String) -> Self {
    UniflowError::internal().with_context(e)
  }
}

impl From<collab::error::CollabError> for UniflowError {
  fn from(value: CollabError) -> Self {
    match value {
      CollabError::SerdeJson(err) => UniflowError::serde().with_context(err),
      CollabError::UnexpectedEmpty(err) => UniflowError::payload_none().with_context(err),
      CollabError::AcquiredWriteTxnFail => UniflowError::internal(),
      CollabError::AcquiredReadTxnFail => UniflowError::internal(),
      CollabError::YrsTransactionError(err) => UniflowError::internal().with_context(err),
      CollabError::YrsEncodeStateError(err) => UniflowError::internal().with_context(err),
      CollabError::UndoManagerNotEnabled => {
        UniflowError::not_support().with_context("UndoManager is not enabled")
      },
      CollabError::DecodeUpdate(err) => UniflowError::internal().with_context(err),
      CollabError::NoRequiredData(err) => UniflowError::internal().with_context(err),
      CollabError::Awareness(err) => UniflowError::internal().with_context(err),
      CollabError::UpdateFailed(err) => UniflowError::internal().with_context(err),
      CollabError::Internal(err) => UniflowError::internal().with_context(err),
    }
  }
}

impl From<uuid::Error> for UniflowError {
  fn from(value: uuid::Error) -> Self {
    UniflowError::internal().with_context(value)
  }
}

impl From<ollama_rs::error::OllamaError> for UniflowError {
  fn from(value: ollama_rs::error::OllamaError) -> Self {
    UniflowError::local_ai().with_context(value)
  }
}
