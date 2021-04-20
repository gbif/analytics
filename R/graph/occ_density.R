# Call out to Python to make the maps
occ_density <- function(sourceFile, plotsDir, targetFilePattern) {
    print(paste("Processing density map for: ", sourceFile))

    status <- system2('R/snapshot_density_map.py', args=c(sourceFile, plotsDir, targetFilePattern))
}
