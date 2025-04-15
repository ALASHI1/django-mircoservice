from rest_framework.views import APIView
from rest_framework.response import Response
from apps.processes.serializers import RequestSerializer, UserSerializer, LoginSerializer
from apps.processes.tasks import handle_request_task
from rest_framework import status
from rest_framework.generics import CreateAPIView,GenericAPIView
from django.contrib.auth.models import User
from drf_yasg.utils import swagger_auto_schema
from rest_framework.authtoken.models import Token
from django.contrib.auth import authenticate
from rest_framework.permissions import AllowAny
# Create your views here.



class ProcessRequest(APIView):
    @swagger_auto_schema(
        request_body=RequestSerializer,
        operation_description="Queue a background task to process the request.",        
    )    
    
    def post(self, request):
        serializer = RequestSerializer(data=request.data)
        if serializer.is_valid():
            task = handle_request_task.delay(serializer.validated_data)
            return Response({"message": "Request processed successfully!", "task_id": task.id}, status=status.HTTP_202_ACCEPTED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    

class TaskStatus(APIView):
    def get(self, request, task_id):
        task = handle_request_task.AsyncResult(task_id)
        if task.state == 'PENDING':
            response = {
                'state': task.state,
                'status': 'Pending...'
            }
        elif task.state != 'FAILURE':
            response = {
                'state': task.state,
                'result': task.result
            }
        else:
            response = {
                'state': task.state,
                'error': str(task.info),  # this is the exception raised
            }
        return Response(response, status=status.HTTP_200_OK)
    
    





class SignUpView(CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]

    def perform_create(self, serializer):
        # Automatically create the user, and also create a token for the user
        user = serializer.save()
        token, created = Token.objects.get_or_create(user=user)
        # After creating the user and token, return the token key in the response
        return Response({
            'message': 'User created successfully',
            'token': token.key
        }, status=status.HTTP_201_CREATED)
        
        
        

class LoginView(APIView):
    permission_classes = [AllowAny]

    @swagger_auto_schema(
        request_body=LoginSerializer,
        operation_description="User login and token generation."
    )    
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')

        user = authenticate(request, username=username, password=password)
        if user is not None:
            token, created = Token.objects.get_or_create(user=user)
            return Response({'token': token.key}, status=status.HTTP_200_OK)
        else:
            return Response({'error': 'Invalid Credentials'}, status=status.HTTP_401_UNAUTHORIZED)