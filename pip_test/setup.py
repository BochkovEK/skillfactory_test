#!/usr/bin/env python

from setuptools import setup

setup(
    name='pip_package_test',
    version='1.0',
    description='A small example package',
    author='bochkov-ek',
    author_email='mail@domain.com',
    packages=['pip_package_test'], #same as name
    install_requires=[], #external packages as dependencies
)