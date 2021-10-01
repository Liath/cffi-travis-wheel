# Override few multibuild functions to customize behavior

function build_wheel {
    if [ -f "/etc/centos-release" ]; then
      yum update -y;
      yum install libffi-devel -y
    fi
    pip install pytest pycparser
    build_bdist_wheel $@
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    if [ -f "/etc/alpine-release" ]; then
      apk add gcc musl-dev
    fi
    pip install pytest
    py.test ../cffi/c/ ../cffi/testing/
}

function install_run {
    if [ -f "/etc/alpine-release" ]; then
      apk add python3 wget
      ln -s $(which python3) /bin/python
      wget "https://bootstrap.pypa.io/get-pip.py"
      python get-pip.py
    fi

    # Copypaste from multibuild/common_utils.sh:install_run
    install_wheel
    mkdir tmp_for_test
    (cd tmp_for_test && run_tests)
}
