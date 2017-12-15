#ODM2 RESTful Web Services -- Deployment Guide

A Python RESTful web service inteface for accessing data in an ODM2 database via Django rest swagger APIs.

NOTE: Currently this repository is under heavy development, a working version is not guaranteed at any point. We will start creating tagged releases soon; once available, please use the latest tagged release for stability.

## Production Installation:

1. Clone both ODM2PythonAPI repository and ODM2RESTfulWebServices repository.

    ```bash
    $ git clone https://github.com/ODM2/ODM2RESTfulWebServices.git odm2restapi
    $ git clone -b development  --single-branch https://github.com/ODM2/ODM2PythonAPI.git
    ```
    
2. Create a new conda environment from the `odm2restapi` environment file.

   ```bash
   $ cd odm2restapi/
   $ conda env create --file environment.yml
   ```

3. Install `odm2pythonapi` master into the environment

   ```bash
   $ source activate odm2restenv
   $ pip install -e ../odm2pythonapi/ # Assuming you're still under odm2restapi folder
   ```
4. Change group to www-data : assuming you are in ../odm2restapi 

    ```bash
    $ chown -R :www-data odm2restapi
    ```
5. Edit odm2restapi/odm2rest/settings/__init__.py to use import linux_server.py: 

    ```
    # -*- coding: utf-8 -*-
    from __future__ import print_function
    from __future__ import unicode_literals
    from __future__ import division
    
    from .base import *
    from .linux_server import * #(Change this from .development to .linux_server)
    ```

5. Edit odm2restapi/odm2rest/settings/linux_server.py in the following ways

    ```
        # -*- coding: utf-8 -*-
    from __future__ import print_function
    from __future__ import unicode_literals
    from __future__ import division
    
    
    from .base import *
    
    DEBUG = False (Change from true)
    
    ALLOWED_HOSTS = [server name] (Change from localhost)
    
    STATIC_ROOT = '[desired path to collect static files]' 
    SWAGGER_SETTINGS['BASE_DOMAIN'] = '[ip of server:80]' (change from localhost)
    SITE_URL = ''
    
    
    # SQLAlchemy settings
    ODM2DATABASE = {
        'engine': 'postgresql',
        'address': '[database server name]',
        'port': 5432,
        'db': '[db name]',
        'user': '[db user]',
        'password': '[db user password]'
    }
```
    

   
##Configure Gunicorn:

1. Install Gunicorn in to your conda env.

   ```bash
   $ pip install gunicorn
   ```
2. Create a gunicorn.service file in /etc/systemd/system/ This file should look like: 

    ```
    [Unit]
    Description=gunicorn daemon
    After=network.target
    
    [Service]
    User=[User that installed odm2restapi]
    Group=www-data
    WorkingDirectory=[path to odm2restapi project root #Example: /home/user/odm2restapi]
    ExecStart=[path to your anaconda installation #example: /home/user/anaconda3]/envs/odm2restenv/bin/gunicorn --access-logfile - --workers 3 --bind unix:[path to project root]/odm2restapi.sock odm2rest.wsgi:application
    
    [Install]
    WantedBy=multi-user.target
    ```
    
    
3. Start Gunicorn
    ```bash
    $ sudo systemctl start gunicorn
    $ sudo systemctl enable gunicorn
    ```
4. Make sure the socket file was created: 

    ```bash
    $ sudo systemctl status gunicorn
    ```
4.1: Check your project root folder for odm2rest.sock, if it is not present check the system journal to troubleshoot: 
    ```bash
    $ sudo journalctl -u gunicorn
    ```
    
##Configure NGINX:
1. Create your project in /etc/nginx/sites-available/

    ```bash
    $ sudo vim /etc/nginx/sites-avialable/odm2restapi
    ```
    
    It should look like this: 
    ```
    server {
    listen 80;
    server_name [server name];

    location /favicon.ico { access_log off; log_not_found off; }

    location /static/ {
        root [path to static folder]; #(example: /opt/odm2_media #It's important to leave off the trailing slash,  otherwise it will look one directory too deep.)
    }

    location / {
        include /etc/nginx/mime.types;
        proxy_pass http://unix:[path to project root]/odm2restapi.sock;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
    
    }
    ```
2. Create a sym-link between sites-available and sites-enabled:

    ```bash
    $ sudo ln -s /etc/nginx/sites-available/odm2restapi /etc/nginx/sites-enabled
    ```
    
3. Test NginX:

    ```bash
    $ sudo nginx -t
    ```

4. If everything works, restart nginx:

    ```bash
    $ sudo systemctl restart nginx
    ```






## Legacy prototype version

The first version of the ODM2 RESTful API was developed in late 2015 and early 2016 as a prototype. That legacy code base is no longer used, and the current code base was developed from scratch (though guided by some lessons learned). The legacy code has been archived at the [odm2rest_legacy branch](https://github.com/ODM2/ODM2RESTfulWebServices/tree/odm2rest_legacy). See also relevant discussions on that branch and subsequent architectural decisions at [issue 11](https://github.com/ODM2/ODM2RESTfulWebServices/issues/11).

## Credits

This work was supported by National Science Foundation Grants [EAR-1224638](http://www.nsf.gov/awardsearch/showAward?AWD_ID=1224638) and [ACI-1339834](http://www.nsf.gov/awardsearch/showAward?AWD_ID=1339834). Any opinions, findings, and conclusions or recommendations expressed in this material are those of the author(s) and do not necessarily reflect the views of the National Science Foundation. 