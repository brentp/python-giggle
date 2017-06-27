from setuptools import setup, Extension
import os
import glob
import sys
import subprocess
import pkg_resources

def get_version():
    """Get the version info from the mpld3 package without importing it"""
    import ast

    with open(os.path.join("giggle", "__init__.py"), "r") as init_file:
      module = ast.parse(init_file.read())

    version = (ast.literal_eval(node.value) for node in ast.walk(module)
         if isinstance(node, ast.Assign)
         and node.targets[0].id == "__version__")
    try:
      return next(version)
    except StopIteration:
          raise ValueError("version could not be located")


# Temporarily install dependencies required by setup.py before trying to import them.
# From https://bitbucket.org/dholth/setup-requires

sys.path[0:0] = ['setup-requires']
pkg_resources.working_set.add_entry('setup-requires')


def missing_requirements(specifiers):
    for specifier in specifiers:
        try:
            pkg_resources.require(specifier)
        except pkg_resources.DistributionNotFound:
            yield specifier


def install_requirements(specifiers):
    to_install = list(specifiers)
    if to_install:
        cmd = [sys.executable, "-m", "pip", "install",
            "-t", "setup-requires"] + to_install
        subprocess.call(cmd)


requires = ['cython']
install_requirements(missing_requirements(requires))


excludes = ['irods', 'plugin', 'timer']

excludes.extend("""lib/giggle/src/api_test.c
lib/giggle/src/giggle.c
lib/giggle/src/index_search.c
lib/giggle/src/offset_idx_lookup.c
lib/giggle/src/search_file.c
lib/giggle/src/server_enrichment.c
lib/giggle/src/server_overlap.c
lib/giggle/src/sig_test.c
lib/giggle/src/speed_tests.c
lib/giggle/src/test.c""".split())


sources = [x for x in glob.glob('lib/htslib/*.c') if not any(e in x for e in
    excludes)] + glob.glob('lib/htslib/cram/*.c')
sources = [x for x in sources if not x.endswith(('htsfile.c', 'tabix.c', 'bgzip.c'))]

sources.extend([x for x in glob.glob('lib/giggle/src/*.c') if not any(e in x for e in excludes)])

import numpy as np
from Cython.Distutils import build_ext

here = os.path.abspath(".")

cmdclass = {'build_ext': build_ext}
extension = [Extension("giggle.giggle",
                        ["giggle/giggle.pyx"]+ ["lib/giggle/src/giggle_index.c"],
                        libraries=['z', 'dl', 'm', 'curl', 'crypto'],
                        include_dirs=[here, "lib/giggle/src/"])]

setup(
    name="giggle",
    description="python wrapper to giggle",
    url="https://github.com/brentp/python-giggle/",
    long_description=open("README.md").read(),
    license="MIT",
    author="Brent Pedersen",
    author_email="bpederse@gmail.com",
    version=get_version(),
    cmdclass=cmdclass,
    ext_modules=extension,
    packages=['giggle', 'giggle.tests'],
    test_suite='nose.collector',
    tests_require='nose',
    install_requires=[],
    include_package_data=True,
    zip_safe=False,
)
