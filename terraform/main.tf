module "network" {
  source              = "../tf-modules/network-module"
  ...
}

module "storage" {
  source              = "../tf-modules/storage-module"
  depends_on          = [module.network]
  ...
}

module "compute" {
  source              = "../tf-modules/compute-module"
  depends_on          = [module.storage]
  ...
}
