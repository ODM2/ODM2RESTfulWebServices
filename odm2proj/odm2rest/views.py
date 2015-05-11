from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse

@api_view(('GET',))
def api_root(request, format=None):
    return Response({
        'variables': reverse('variable-list', request=request, format=format),
        'variableCode': reverse('variable-detail', request=request, format=format, args=['USU3']),
        'sites': reverse('site-list', request=request, format=format),
        'actions': reverse('action-list', request=request, format=format),
        'values': reverse('value-list', request=request, format=format, args=['02E4DC76-B258-E411-AE79-0024E852D68F'])
    })

"""
def pagination(obj, request):
    max = request.GET.get('max') if 'max' in request.GET else 1
    paginator = Paginator(obj, max)  # Show 25 contacts per page
    page = request.GET.get('page')
    try:
        return paginator.page(page)
    except PageNotAnInteger:
        # If page is not an integer, deliver first page.
        return paginator.page(1)
    except EmptyPage:
        return ""

def folder_list(request):
    folders = UserFolder.objects.filter(creator=request.user).order_by('-modified_date')
    folders_dict = []
    for folder in folders:
        d = {}
        for k, v in folder.__dict__.items():
            d[k] = str(v)
        d["creator__first_name"] = folder.creator.first_name
        folders_dict.append(d)
    folders = Common.pagination(folders_dict, request)
    #folders = json.dumps(folders)
    folders = json.dumps(folders.object_list) #added .object_list
    return HttpResponse(folders)
"""
