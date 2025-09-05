import json
import boto3
import os

# Initialize the DynamoDB client
dynamodb = boto3.client('dynamodb')

# Get the DynamoDB table name from environment variables
table_name = os.environ.get('DYNAMODB_TABLE')
if not table_name:
    raise ValueError("DYNAMODB_TABLE environment variable is not set")

def lambda_handler(event, context):
    # CORS headers for all responses
    cors_headers = {
        'Access-Control-Allow-Origin': 'https://oneclickbouquet.sctp-sandbox.com',
        'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token',
        'Access-Control-Allow-Methods': 'GET,POST,OPTIONS',
        'Access-Control-Allow-Credentials': 'true'
    }
    
    try:
        # Handle OPTIONS request for CORS preflight
        if event.get('httpMethod') == 'OPTIONS':
            return {
                'statusCode': 200,
                'headers': cors_headers,
                'body': json.dumps('OK')
            }
        
        # Handle GET request for testing
        if event.get('httpMethod') == 'GET':
            return {
                'statusCode': 200,
                'headers': cors_headers,
                'body': json.dumps({
                    'message': 'OneClickBouquet API is working!',
                    'timestamp': context.aws_request_id
                })
            }
        
        # Get JSON payload from the event
        json_payload = event.get('body')
        if json_payload is None:
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps("No payload provided.")
            }
        
        payload = json.loads(json_payload)
        
        # Validate required fields
        required_fields = ['order_id', 'bouquet', 'quantity', 'style']
        for field in required_fields:
            if field not in payload:
                return {
                    'statusCode': 400,
                    'headers': cors_headers,
                    'body': json.dumps(f"Missing required field: {field}")
                }
        
        # Extract order details
        order_id = payload.get('order_id')
        bouquet = payload.get('bouquet')
        quantity = payload.get('quantity')
        style = payload.get('style')
        
        # Ensure order_id is not None
        if order_id is None:
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps("Missing required field: order_id")
            }
        
        # Validate quantity is a number
        try:
            quantity = int(quantity)
        except (ValueError, TypeError):
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps("Quantity must be a valid number")
            }
        
        # Validate style is a number
        try:
            style = int(style)
        except (ValueError, TypeError):
            return {
                'statusCode': 400,
                'headers': cors_headers,
                'body': json.dumps("Style must be a valid number")
            }

        # Define the item to be stored in DynamoDB
        item = {
            'order_id': {'S': order_id},
            'bouquet': {'S': bouquet},
            'quantity': {'N': str(quantity)},
            'style': {'N': str(style)}
        }

        # Put the item in the DynamoDB table
        dynamodb.put_item(TableName=table_name, Item=item)

        return {
            'statusCode': 200,
            'headers': cors_headers,
            'body': json.dumps(f"Order {order_id} processed successfully!")
        }

    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'headers': cors_headers,
            'body': json.dumps("Invalid JSON payload.")
        }
    except Exception as e:
        print(f"Error occurred: {e}")
        return {
            'statusCode': 500,
            'headers': cors_headers,
            'body': json.dumps("An internal error occurred.")
        }
