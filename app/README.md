# Question answering APP

The goal of this app is to answer questions based on the provided context. A simple use case for this app is to provide technical support by answering questions based on a technical documentation context.
To provide a pleasant user experience this kind of API should have high availability along with subsecond response time.

## Language
The app is written in Python to directly leverage the Huggingface transformers library. The HTTP serving API is based on BentoML which provides helper methods to easily describe endpoints and inputs along with utilities such as built in prometheus metrics or micro-batching.

## Usage

- Requires Python 3.8

### Locally
Install the requirements:
```bash
pip install -r requirements.txt
```

Once installed generate the BentoML model:
```bash
python main.py
```

And finally serve the model:
```bash
bentoml serve MyPipelineService:latest
```

### Docker
- Requires Docker

Or simple build the Docker image:
```bash
docker build -t serving-app .
```

And run the Docker image:
```bash
docker run serving-app:latest
```

### Example

Simnply query the model with curl:
```bash
curl -X POST http://localhost:5000/predict \
-H "Content-Type: application/json" \
-d '{"question":"What is extractive question answering?", "context":"Extractive Question Answering is the task of extracting an answer from a text given a question. An example of a question answering dataset is the SQuAD dataset, which is entirely based on that task. If you would like to fine-tune a model on a SQuAD task, you may leverage the examples/pytorch/question-answering/run_squad.py script."}'
```

Response:
```json
{
  "result": {
    "score": 0.6177276968955994,
    "start": 33,
    "end": 94,
    "answer": "the task of extracting an answer from a text given a question"
  }
}
```