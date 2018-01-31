"""
odm2rest
--------

A Python RESTful web service inteface for accessing data in an
ODM2 database via Django rest swagger APIs.
"""
from __future__ import (absolute_import, division, print_function)

import os

from setuptools import find_packages, setup

here = os.path.abspath(os.path.dirname(__file__))

# Dependencies.
with open('requirements.txt') as f:
    requirements = f.readlines()
install_requires = [t.strip() for t in requirements]

with open(os.path.join(here, 'README.md')) as readme:
    README = readme.read()

# allow setup.py to be run from any path
os.chdir(os.path.normpath(os.path.join(os.path.abspath(__file__), os.pardir)))

setup(
    name='odm2rest',
    version='0.1',
    packages=find_packages(),
    include_package_data=True,
    license='BSD License',
    description='A Python RESTful web service inteface for accessing data in an '
                'ODM2 database via Django rest swagger APIs',
    long_description=README,
    url='https://github.com/ODM2/ODM2RESTfulWebServices',
    author='Landung Setiawan',
    author_email='landungs@uw.edu',
    install_requires=install_requires,
    classifiers=[
        'Environment :: Web Environment',
        'Framework :: Django',
        'Framework :: Django :: 1.11',
        'Intended Audience :: Science/Research',
        'License :: OSI Approved :: BSD License',
        'Operating System :: OS Independent',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2.7',
        'Topic :: Software Development :: Libraries :: Python Modules',
    ],
)
