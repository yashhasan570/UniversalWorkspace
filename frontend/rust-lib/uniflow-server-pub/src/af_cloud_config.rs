use std::fmt::Display;

use serde::{Deserialize, Serialize};

use uniflow_error::{ErrorCode, UniflowError};

pub const UNIVERSALWORKSPACE_CLOUD_BASE_URL: &str = "UNIVERSALWORKSPACE_CLOUD_ENV_UNIVERSALWORKSPACE_CLOUD_BASE_URL";
pub const UNIVERSALWORKSPACE_CLOUD_WS_BASE_URL: &str = "UNIVERSALWORKSPACE_CLOUD_ENV_UNIVERSALWORKSPACE_CLOUD_WS_BASE_URL";
pub const UNIVERSALWORKSPACE_CLOUD_GOTRUE_URL: &str = "UNIVERSALWORKSPACE_CLOUD_ENV_UNIVERSALWORKSPACE_CLOUD_GOTRUE_URL";

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct AFCloudConfiguration {
  pub base_url: String,
  pub ws_base_url: String,
  pub gotrue_url: String,
}

impl Display for AFCloudConfiguration {
  fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
    f.write_fmt(format_args!(
      "base_url: {}, ws_base_url: {}, gotrue_url: {}",
      self.base_url, self.ws_base_url, self.gotrue_url,
    ))
  }
}

impl AFCloudConfiguration {
  pub fn from_env() -> Result<Self, UniflowError> {
    let base_url = std::env::var(UNIVERSALWORKSPACE_CLOUD_BASE_URL).map_err(|_| {
      UniflowError::new(
        ErrorCode::InvalidAuthConfig,
        "Missing UNIVERSALWORKSPACE_CLOUD_BASE_URL",
      )
    })?;

    let ws_base_url = std::env::var(UNIVERSALWORKSPACE_CLOUD_WS_BASE_URL).map_err(|_| {
      UniflowError::new(
        ErrorCode::InvalidAuthConfig,
        "Missing UNIVERSALWORKSPACE_CLOUD_WS_BASE_URL",
      )
    })?;

    let gotrue_url = std::env::var(UNIVERSALWORKSPACE_CLOUD_GOTRUE_URL)
      .map_err(|_| UniflowError::new(ErrorCode::InvalidAuthConfig, "Missing AF_CLOUD_GOTRUE_URL"))?;

    if base_url.is_empty() || ws_base_url.is_empty() || gotrue_url.is_empty() {
      return Err(UniflowError::new(
        ErrorCode::InvalidAuthConfig,
        format!(
          "Invalid UNIVERSALWORKSPACE_CLOUD_BASE_URL: {}, UNIVERSALWORKSPACE_CLOUD_WS_BASE_URL: {}, UNIVERSALWORKSPACE_CLOUD_GOTRUE_URL: {}",
          base_url, ws_base_url, gotrue_url,
        )),
      );
    }

    Ok(Self {
      base_url,
      ws_base_url,
      gotrue_url,
    })
  }

  /// Write the configuration to the environment variables.
  pub fn write_env(&self) {
    std::env::set_var(UNIVERSALWORKSPACE_CLOUD_BASE_URL, &self.base_url);
    std::env::set_var(UNIVERSALWORKSPACE_CLOUD_WS_BASE_URL, &self.ws_base_url);
    std::env::set_var(UNIVERSALWORKSPACE_CLOUD_GOTRUE_URL, &self.gotrue_url);
  }
}
