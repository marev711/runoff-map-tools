runoff-map-tools
================

Various scripts to manage runoff_maps

lat_lon_runoff_plot.ncl: 
  Read grids.nc-file + runoff map, writes

  (1) a land basin file with three columns:
      lat/lon/runoff_basin_index, e.g., 
         89.4628225     0.0000005    -2
         89.4628225    20.0000005    -2
         89.4628225    40.0000005    -2
         ...


  (2) a ocean basin file with three columns:
      lat/lon/runoff_basin_index

  Optionally the script can visualise a specified land 
  and ocean basin. 

  Usage: (i)   update settings section in the script
         (ii)  run with "ncl lat_lon_runoff_plot.ncl"
         (iii) update the the basin index column in the 
               relevant output file (land and/or ocean)
         (iv)  use the "write_runoff.F90" to convert the
               lat/lon/runoff_basin file back to a proper
               runoff_maps.txt-file (see below)  

write_runoff.F90:
  Read from stdin and write runoff_map-syntax to stdout.
  Usage: awk '{print $3}' lat_lon_land.txt | write_runoff.x > runoff_map.txt
         awk '{print $3}' lat_lon_ocean.txt | write_runoff.x >> runoff_map.txt
