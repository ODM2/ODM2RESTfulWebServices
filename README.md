# ODM2 RESTful Web Services

[![Build status](https://travis-ci.org/ODM2/ODM2RESTfulWebServices.svg?branch=master)](https://travis-ci.org/ODM2/ODM2RESTfulWebServices)

A Python RESTful web service inteface for accessing data in an ODM2 database via Django rest swagger APIs.

NOTE: Currently this repository is under heavy development, a working version is not guaranteed at any point.

For current stable version, please refer to the
[odm2rest_legacy branch](https://github.com/ODM2/ODM2RESTfulWebServices/tree/odm2rest_legacy).

## Development Installation

1. Clone both ODM2PythonAPI repository and ODM2RESTfulWebServices repository.

    ```bash
    $ git clone https://github.com/ODM2/ODM2RESTfulWebServices.git odm2restapi
    $ git clone https://github.com/ODM2/ODM2PythonAPI.git odm2pythonapi
    ```

2. Create a new conda environment from the `odm2restapi` environment file.

   ```bash
   $ cd odm2restapi/
   $ git checkout odm2rest_1_0 # This is the development branch, all PR's must merge to here!
   $ conda env create --file environment.yml
   ```

3. Install `odm2pythonapi` master into the environment

   ```bash
   $ source activate odm2restenv
   $ pip install -e ../odm2pythonapi/ # Assuming you're still under odm2restapi folder
   ```

4. Install [`npm` and `nodejs`](https://www.npmjs.com/get-npm), which will be used to install the swagger editor.
5. Get swagger editor for a nice interface and syntax checking when editing the swagger yaml file.

   ```bash
   $ cd odm2restapi/
   $ npm init -y
   $ sudo npm install -g swagger
   $ swagger project edit # This will open a new browser
   ```

### Credits

This work was supported by National Science Foundation Grants [EAR-1224638](http://www.nsf.gov/awardsearch/showAward?AWD_ID=1224638) and [ACI-1339834](http://www.nsf.gov/awardsearch/showAward?AWD_ID=1339834). Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation. 
