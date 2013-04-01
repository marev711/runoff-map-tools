      program write_runoff
      implicit none
      integer, parameter :: ifs_grid_size=88838  ! Valid for T255
      integer :: basin_map(ifs_grid_size)
      read(unit=*,fmt="(I3)") basin_map
      write(*, fmt="(320I3)") basin_map
      end program write_runoff
