# $1 is the first argument witch is expected to be a PDB file.
# $2 is the second argument witch is expected to be a SF mtz.
# Note that PHENIX must be souced to run this script.
#
# This script takes a PDB file and creates two files. one with just the DNA BB ("xxxxx_bb.pdb") and the other with the DNA BB removed ("xxxxx_sc.pdb"). Then phenix.real_space_correlation is ran on each file creating xxxxx_bb.rsc and xxxxx_sc.rsc.

echo "Keeping DNA bb"
phenix.pdbtools modify.keep="(name ' P  ' or name ' OP1' or name ' OP2' or name ' O5\'' or name ' C5\'' or name ' C4\'' or name ' O4\'' or name ' C3\'' or name ' O3\'' or name ' C2\'' or name ' C1\'')" output.file_name="$1_bb.pdb" $1

echo "Removing DNA bb"
phenix.pdbtools modify.remove="(name ' P  ' or name ' OP1' or name ' OP2' or name ' O5\'' or name ' C5\'' or name ' C4\'' or name ' O4\'' or name ' C3\'' or name ' O3\'' or name ' C2\'' or name ' C1\'')" output.file_name="$1_sc.pdb" $1

echo "Running phenix.real_space_correlation"
phenix.real_space_correlation detail=residue $1_bb.pdb $2 > $1_bb.rsc
phenix.real_space_correlation detail=residue $1_sc.pdb $2 > $1_sc.rsc
