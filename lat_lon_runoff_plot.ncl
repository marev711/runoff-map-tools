;; Converts the input run off file and its corresponding
;; grids.nc file into a 'lat lon land_value'-file and a
;; 'lat lon ocean_value'-file. Plots a specific basin, here
;; 52 for the Amazon basin.

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin 
    ;; Settings
    runoff_file = "../ic3-orca025-setup/runoff_maps_orca025.txt"
    grids_file  = "../ic3-orca025-setup/grids_orca025.nc"
    lat_name    = "A128.lat"
    lon_name    = "A128.lon"
    foutput_land = "lat_lon_land.txt"
    foutput_ocean = "lat_lon_ocean.txt"

    plot_land_and_ocean = True
    ;; End of settings

    runoff = asciiread(runoff_file, -1, "integer")
    f = addfile(grids_file, "r")
    lat = f->$lat_name$
    lon = f->$lon_name$

    ;; Rewrite longitude from 0..360 to -180..180
    lon_update = mod(lon + 180, 360) - 180
    delete(lon)
    lon = lon_update
    delete(lon_update)

    grid_size   = dimsizes(lat)
    print(grid_size)
    lat_length = grid_size(1)
    land_points = runoff(0:lat_length-1)
    ocean_points = runoff(lat_length:lat_length*2-1)

    ;; Write output
    output_land  = [/lat, lon, land_points/]    
    write_table(foutput_land, "w", output_land, "%12f5 %12f5 %5d")

    output_ocean = [/lat, lon, ocean_points/]    
    write_table(foutput_ocean, "w", output_ocean, "%13f5 %12f5 %5d")

    if (plot_land_and_ocean .eq. True) then
        wks   = gsn_open_wks ("ps","scatter")  ; open workstation

        res             = True  ; plot mods desired
        res@gsnFrame    = False ; don't advance yet
        res@gsnMaximize = True

        ;; 52 is the Amazon basin index
        land_lat = lat(0, ind(land_points .eq. 52))
        land_lon = lon(0, ind(land_points .eq. 52))
        ocean_lat = lat(0, ind(ocean_points .eq. 52))
        ocean_lon = lon(0, ind(ocean_points .eq. 52))
        res@mpCenterLonF = -50
        res@mpMinLatF = min(land_lat) - 1
        res@mpMaxLatF = max(land_lat) + 1
        res@mpMinLonF = min(land_lon) - 1
        res@mpMaxLonF = max(ocean_lon) + 1

        map = gsn_csm_map(wks,res)  ; Create the map plot, don't draw

        ;; Attach the markers to the plot
        mkres = True
        mkres@gsMarkerColor = "Blue"
        mkres@gsMarkerSizeF = 15.        ; Increase marker sizes.
        mkres@gsMarkerIndex = 6

        dum1 = gsn_add_polymarker(wks,map,land_lon,land_lat,mkres)
        mkres@gsMarkerIndex = 4
        dum2 = gsn_add_polymarker(wks,map,ocean_lon,ocean_lat,mkres)

        draw(map)
        frame(wks)
    end if
end
