# Merge Datasets Together

# Load Data / Create Dataset Lists -----------------------------------------------
# Load data that we'll merge datasets into and create lists of datasets to merge
# into this dataset.

#### Load dataset to merge into
points_all <- readRDS(file.path(finaldata_file_path, DATASET_TYPE,"individual_datasets", "points_dmspols.Rds")) %>% data.table 

#### Names of datasets to merge in
# Separate by time invarient (merge by cell_id) and time varying (merge by cell_id 
# and year)
DATASETS_TIME_INVARIANT <- c("points_gadm.Rds", "points_distance_cities.Rds", "points_distance_rsdp_phases.Rds")
DATASETS_TIME_VARYING <- c("points_viirs.Rds",
                           "points_ndvi.Rds",
                           "points_globcover.Rds",
                           "points_dmspols_zhang2016.Rds",
                           "points_distance_roads_byspeed.Rds",
                           "points_distance_improved_roads_byspeed_before.Rds",
                           "points_distance_improved_roads_byspeed_after.Rds")

# Merge ------------------------------------------------------------------------
for(dataset in DATASETS_TIME_VARYING){
  print(dataset)
  dataset_temp <- readRDS(file.path(finaldata_file_path, DATASET_TYPE, "individual_datasets", dataset)) %>% data.table 
  points_all <- merge(points_all, dataset_temp, by=c("cell_id", "year"), all=T)
  rm(dataset_temp); gc()
}

for(dataset in DATASETS_TIME_INVARIANT){
  print(dataset)
  dataset_temp <- readRDS(file.path(finaldata_file_path, DATASET_TYPE, "individual_datasets", dataset)) %>% data.table 
  points_all <- merge(points_all, dataset_temp, by="cell_id", all=T)
  rm(dataset_temp); gc()
}

# Export -----------------------------------------------------------------------
saveRDS(points_all, file.path(finaldata_file_path, DATASET_TYPE, "merged_datasets", "grid_data.Rds"))





