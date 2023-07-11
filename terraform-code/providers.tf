# Configure the provider
provider "google" {
  credentials = "polished-scope-389605-3d8324539eb9.json"
  project     = "polished-scope-389605"
  region      = "us-central1"
  zone        = "us-central1-c"
}

provider "google-beta" {
  credentials = "polished-scope-389605-3d8324539eb9.json"
  project     = "polished-scope-389605"
  region      = "us-central1"
  zone        = "us-central1-c"
}
