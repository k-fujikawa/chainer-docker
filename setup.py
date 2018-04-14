#!/usr/bin/env python

import pip
from pip.req import parse_requirements

from setuptools import find_packages
from setuptools import setup


reqs = parse_requirements(
    'requirements.txt',
    session=pip.download.PipSession()
)

install_requires = [str(req.req) for req in reqs]

setup(
    # FIXME: Set the name of this package
    # name='name of package',
    version='0.0.0',
    packages=find_packages(exclude=['tests*']),
    install_requires=install_requires,
    scripts=[],
    tests_require=[
        'coverage',
        'nose',
        'flake8',
        'flake8-import-order',
    ],
    test_suite='nose.collector',
)
