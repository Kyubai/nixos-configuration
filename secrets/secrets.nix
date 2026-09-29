let
  deack-pc-01-host = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOFxnhPz1P8Ten6gkdJFhQT6DZJwBpgu0Sxt2RZ5FzN";
  mri = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJaOvQm6DCDl+ytVcGr7sFtJZINapQynYASlnlf090nV";
in {
  "anthropic-api-key.age".publicKeys = [deack-pc-01-host mri];
}
