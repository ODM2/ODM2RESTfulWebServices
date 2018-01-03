import os
from django.conf import settings

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

DEFAULTS = {
    'TEMPLATE_DIR': os.path.join(BASE_DIR, 'templates'),
    'STATIC_DIR': os.path.join(BASE_DIR, 'static/odm2_rest_api'),
    'SCHEMA_DIR': os.path.join(BASE_DIR, 'schemas')
}

ODM2_REST_API = getattr(settings, 'ODM2_REST_API', DEFAULTS)

# SQLAlchemy settings
DB_DEFAULT = {
    'engine': 'db engine',
    'address': 'localhost',
    'port': 5432,
    'db': 'db name',
    'user': 'username',
    'password': 'mypassword'
}

ODM2DATABASE = getattr(settings, 'ODM2DATABASE', DB_DEFAULT)


settings.STATICFILES_DIRS = [ODM2_REST_API['STATIC_DIR']]

settings.INSTALLED_APPS +=  'rest_framework'

SWAGGER_DEFAULTS = {
    'SECURITY_DEFINITIONS': {
        'basic': {
            'type': 'basic'
        }
    },
    'USE_SESSION_AUTH': False,
    'APIS_SORTER': 'alpha',
    'JSON_EDITOR': True,
    'SHOW_REQUEST_HEADERS': True,
    'SUPPORTED_SUBMIT_METHODS': ['get'],

    # Application base domain.
    # If IP Address also include port
    # else only need domain name
    'BASE_DOMAIN': '127.0.0.1:8000'
}

SWAGGER_SETTINGS = getattr(settings, 'SWAGGER_SETTINGS', SWAGGER_DEFAULTS)

settings.REST_FRAMEWORK = {
    'DEFAULT_VERSIONING_CLASS': 'rest_framework.versioning.NamespaceVersioning',
    'DEFAULT_PERMISSION_CLASSES': ('rest_framework.permissions.AllowAny',),
    # 'DEFAULT_PERMISSION_CLASSES': ('rest_framework.permissions.IsAdminUser',),
    # 'VIEW_DESCRIPTION_FUNCTION': 'rest_framework_swagger.views.get_restructuredtext',
    'DEFAULT_PARSER_CLASSES': (
       'rest_framework.parsers.JSONParser',
       'rest_framework_yaml.parsers.YAMLParser',
       'rest_framework_csv.parsers.CSVParser',
    ),
    # 'DEFAULT_CONTENT_NEGOTIATION_CLASS': 'odm2example.negotiation.IgnoreClientContentNegotiation',
    # specifying the renderers
    'DEFAULT_RENDERER_CLASSES': (
        'rest_framework.renderers.JSONRenderer',
        'rest_framework_csv.renderers.CSVRenderer',
        'rest_framework_yaml.renderers.YAMLRenderer',
        # 'rest_framework_xml.renderers.XMLRenderer',
        'rest_framework.renderers.BrowsableAPIRenderer',
    ),
    # 'PAGINATE_BY': 10,                 # Default to 10
    # 'PAGINATE_BY_PARAM': 'page_size',  # Allow client to override, using `?page_size=xxx`.
    # 'MAX_PAGINATE_BY': 100             # Maximum limit allowed when using `?page_size=xxx`.
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 100,
}