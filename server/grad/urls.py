from django.contrib import admin
from django.urls import path, include
from graphene_django.views import GraphQLView
from graphql_playground.views import GraphQLPlaygroundView
from django.views.decorators.csrf import csrf_exempt
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path("graphql", csrf_exempt(GraphQLView.as_view(graphiql=True))),
    path("playground/", GraphQLPlaygroundView.as_view(endpoint="http://127.0.0.1:8000/graphql")),
    path('tg/', include('adder.urls'))
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
