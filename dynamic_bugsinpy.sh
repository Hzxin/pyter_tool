#! /bin/bash

src_dir=$1
project=$2
cd "$src_dir"

if [ ! -d "$src_dir/pyter" ]; then
    mkdir pyter
fi

bug_info_path="$1/bugsinpy_bug.info"
information=$(<${bug_info_path})
information="$( cut -d '"' -f 2 <<< "$information" )";
py_version=${information:0:5}
pyenv install -s ${py_version}
pyenv virtualenv ${py_version} temp
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
source ~/.bashrc
pyenv activate temp
pyenv local temp

pip install -e /pyter/pyter_tool/pyannotate/.
pip install pytest-timeouts

/bugsinpy/framework/bin/bugsinpy-compile

python /pyter/pyter_tool/my_tool/extract_neg.py --bench="/pyter/pyter_tool/bugsinpy" --nopos="" --project=$project
python /pyter/pyter_tool/my_tool/extract_pos.py --bench="/pyter/pyter_tool/bugsinpy" --nopos="" --project=$project



