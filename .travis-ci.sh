#!/bin/bash

# Here are the various libs that will be required. They will be installed
# either with opam or with the system manager.

OPAM_DEPENDS="ocamlfind ocsfml"
LIB_DEPENDS="libboost-all-dev cmake libsfml-dev"
COMPILER_DEPENDS="g++ binutils make"

echo "yes" | sudo add-apt-repository ppa:avsm/ocaml42+opam12
echo "yes" | sudo add-apt-repository ppa:sonkun/sfml-development

sudo apt-get update -qq
sudo apt-get install -qq ocaml ocaml-native-compilers camlp4-extra opam \
						 ${LIB_DEPENDS} ${COMPILER_DEPENDS}

export OPAMYES=1
opam init 
eval `opam config env`
opam install ${OPAM_DEPENDS}
make
make doc
make test
make clean