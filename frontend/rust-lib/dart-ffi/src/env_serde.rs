use std::collections::HashMap;

use serde::Deserialize;

use uniflow_server_pub::af_cloud_config::AFCloudConfiguration;
use uniflow_server_pub::AuthenticatorType;

#[derive(Deserialize, Debug)]
pub struct UniversalWorkspaceDartConfiguration {
  /// The root path of the application
  pub root: String,
  pub app_version: String,
  /// This path will be used to store the user data
  pub custom_app_path: String,
  pub origin_app_path: String,
  pub device_id: String,
  pub platform: String,
  pub authenticator_type: AuthenticatorType,
  pub(crate) universalworkspace_cloud_config: AFCloudConfiguration,
  #[serde(default)]
  pub(crate) envs: HashMap<String, String>,
}

impl UniversalWorkspaceDartConfiguration {
  pub fn from_str(s: &str) -> Self {
    serde_json::from_str::<UniversalWorkspaceDartConfiguration>(s).unwrap()
  }

  pub fn write_env(&self) {
    self.authenticator_type.write_env();
    self.universalworkspace_cloud_config.write_env();

    for (k, v) in self.envs.iter() {
      std::env::set_var(k, v);
    }
  }
}
