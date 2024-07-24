import boto3
from botocore.exceptions import NoCredentialsError, PartialCredentialsError
from time import time

AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')

session = boto3.Session(
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
    region_name="us-east-1"
)

dynamodb = session.resource('dynamodb')

try:
    table = dynamodb.Table('audit-log')

    # response = table.get_item(
    #     Key={'id': '123'}
    # )

    # if 'Item' in response:
    #     item = response['Item']
    #     raise Exception("Item ja existe na tabela")

    response = table.put_item(
        Item={
            'id': '12345',
            'app': '2 minutes ago',
            'resource_id': "4321",
            'action': 'test',
            'actor': 'test',
            'created_at': int(time()),
            'ttl': int(time()) + 120
        }
    )

    print("Item inserido com sucesso:", response)

    # response = table.delete_item(
    #     Key={'id': '123'}
    # )
    #
    # if response['ResponseMetadata']['HTTPStatusCode'] == 200:
    #     print("Item deletado com sucesso.")
    # else:
    #     print("Erro ao deletar o item:", response)

except NoCredentialsError:
    print("Erro: Credenciais não encontradas.")
except PartialCredentialsError:
    print("Erro: Credenciais incompletas.")
except Exception as e:
    print("Erro ao acessar o DynamoDB:", e)