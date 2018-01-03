import os
from setuptools import find_packages, setup

with open(os.path.join(os.path.dirname(__file__), 'README.md')) as readme:
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
    url='https://www.example.com/',
    author='Landung Setiawan',
    author_email='landungs@uw.edu',
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
