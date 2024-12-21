from flask import Flask, request, jsonify
from flask_cors import CORS
import os
from dotenv import load_dotenv
from dotenv import dotenv_values
import json
parameters_env = ".env"
if os.path.exists(parameters_env):
    load_dotenv(override=True)
    config = dotenv_values(parameters_env)

from openai import AzureOpenAI
import openai

app = Flask(__name__)
CORS(app)  # This enables CORS for all routes and origins
# Azure OpenAI and Azure Search configuration
azure_open_ai_chat_complettion_deployment_name= os.getenv("AZURE_OPEN_AI_CHAT_COMPLETIONS_DEPLOYMENT_NAME") 
azure_ai_search_endpoint = os.getenv("AZURE_SEARCH_SERVICE_ENDPOINT")
azure_ai_search_admin_key = os.getenv("AZURE_SEARCH_SERVICE_ADMIN_KEY")
search_index_name = os.getenv("SEARCH_INDEX_NAME")
azure_open_ai_endpoint = os.getenv("AZURE_OPEN_AI_ENDPOINT")
azure_open_ai_api_key = os.getenv("AZURE_OPEN_AI_API_KEY")

@app.route('/api/chat', methods=['POST'])
def chat():
    openai_client = AzureOpenAI(
         azure_endpoint=azure_open_ai_endpoint,
        api_key=azure_open_ai_api_key,
        api_version="2024-06-01"
)
    try:
       
        data = request.json
        print(f"prompt: {data}")
        user_message = data.get("message", "")
        
        response = openai_client.chat.completions.create(
        model=azure_open_ai_chat_complettion_deployment_name,
        messages=[
        {"role":"system","content":"Sos un sistema que ayuda a una persona entender la materia Diseño de Sistemas de la Univerdad"},
        {"role":"user","content":f"{user_message}"}
    ],
            extra_body={
                "data_sources":[
                        {
                    "type":"azure_search",
                    "parameters":{
                        "endpoint":azure_ai_search_endpoint,
                        "index_name":search_index_name,
                        "authentication":{
                            "type":"api_key",
                            "key":azure_ai_search_admin_key
                        }
                }
            }
        ]
    }
)
        
        
        
        response_json = response.to_json()
        response_data = json.loads(response_json)
        first_message = response_data["choices"][0]["message"]["content"]
        print("First Message Content:", first_message)

      
        return jsonify({"message":first_message})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True)
