use std::fs::{File, OpenOptions};
use std::io::{Read, Write};
use std::path::Path;

use serde::{Deserialize, Serialize};

use uniflow_server_pub::af_cloud_config::AFCloudConfiguration;

#[derive(Debug, Serialize, Deserialize, Clone, Default)]
pub struct UniversalWorkspaceYamlConfiguration {
  cloud_config: Vec<AFCloudConfiguration>,
}

pub fn save_universalworkspace_cloud_config(
  root: impl AsRef<Path>,
  new_config: &AFCloudConfiguration,
) -> Result<(), Box<dyn std::error::Error>> {
  let file_path = root.as_ref().join("universalworkspace.yaml");
  let mut config = read_yaml_file(&file_path).unwrap_or_default();

  if !config
    .cloud_config
    .iter()
    .any(|c| c.base_url == new_config.base_url)
  {
    config.cloud_config.push(new_config.clone());
    write_yaml_file(&file_path, &config)?;
  }
  Ok(())
}

fn read_yaml_file(
  file_path: impl AsRef<Path>,
) -> Result<UniversalWorkspaceYamlConfiguration, Box<dyn std::error::Error>> {
  let mut file = File::open(file_path)?;
  let mut contents = String::new();
  file.read_to_string(&mut contents)?;
  let config: UniversalWorkspaceYamlConfiguration = serde_yaml::from_str(&contents)?;
  Ok(config)
}

fn write_yaml_file(
  file_path: impl AsRef<Path>,
  config: &UniversalWorkspaceYamlConfiguration,
) -> Result<(), Box<dyn std::error::Error>> {
  let yaml_string = serde_yaml::to_string(config)?;
  let mut file = OpenOptions::new()
    .create(true)
    .write(true)
    .truncate(true)
    .open(file_path)?;
  file.write_all(yaml_string.as_bytes())?;
  Ok(())
}
