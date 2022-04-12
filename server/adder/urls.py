from .views import *
from django.urls import path
from django.views.decorators.csrf import csrf_exempt


urlpatterns = [
    path('request_code/', csrf_exempt(request_code), name="request_code"),
    path('submit/', csrf_exempt(submit), name="submit"),
    path('logout/', csrf_exempt(logout), name="logout"),
    path('test_session/', test_session, name='test_session')
]