{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
}:

let

  python = pkgs.python36;
  pythonPackages = python.pkgs;

  venvDir = "./.venv";

in

stdenv.mkDerivation {
  name = "snortEnv";
  buildInputs = [
    python pythonPackages.virtualenv pythonPackages.pip
  ];
  propagatedBuildInputs = with pkgs; [
    rdkafka protobuf
  ];
  shellHook = ''
    export SOURCE_DATE_EPOCH=$(date +%s)

    if [ ! -d ${venvDir} ]; then
        virtualenv --python=${python}/bin/python ${venvDir}
        ${venvDir}/bin/pip install --upgrade pip
        source ${venvDir}/bin/activate

        if [ -e ./requirements.txt ]; then
            ${venvDir}/bin/pip install -r ./requirements.txt
        fi

        deactivate
    fi

    source ${venvDir}/bin/activate
  '';
}