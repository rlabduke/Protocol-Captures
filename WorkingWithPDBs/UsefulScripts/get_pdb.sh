# $1 is the first argument witch is expected to be a PDB code.
# Note that PHENIX must be souced to run this script.
#
# This script makes a directory with the name of the given PDB
# code and downloads PDB data, creates a kinemage, and calculates maps.

mkdir $1
cd $1
phenix.fetch_pdb --mtz $1
phenix.kinemage $1.pdb
phenix.maps map.map_type=2mFo-DFc map.map_type=mFo-DFc map_coefficients.map_type=2mFo-DFc $1.pdb $1.mtz
cd ..
