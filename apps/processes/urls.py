from django.urls import path
from apps.processes.views import ProcessRequest, TaskStatus, SignUpView,LoginView

urlpatterns = [
    path('signup/', SignUpView.as_view(), name='signup'),
    path('login/', LoginView.as_view(), name='login'),
    path('process/', ProcessRequest.as_view(), name='process_request'),
    path('status/<str:task_id>/', TaskStatus.as_view(), name='task_status'),
]
