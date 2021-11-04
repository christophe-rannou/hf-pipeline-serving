import os
from bentoml.service.artifacts import BentoServiceArtifact
from bentoml import env, api, artifacts
from bentoml.adapters import JsonInput
import bentoml
from transformers import pipeline


class MyPipelineArtifact(BentoServiceArtifact):
    def __init__(self, name):
        super(MyPipelineArtifact, self).__init__(name)
        self._model = None

    def pack(self, model, metadata=None):
        self._model = model
        return self

    def get(self):
        return self._model

    def save(self, dst):
        # no need to save, fully pretrained pipeline
        pass

    def load(self, path):
        model = pipeline("question-answering", model="distilbert-base-cased-distilled-squad")
        return self.pack(model)

    def _file_path(self, base_path):
        return os.path.join(base_path, self.name + '.json')


@env(infer_pip_packages=True)
@artifacts([MyPipelineArtifact('question_answerer')])
class MyPipelineService(bentoml.BentoService):

    @api(input=JsonInput(), batch=False)
    def predict(self, input_data):
        context = input_data.get("context")
        question = input_data.get("question")
        result = self.artifacts.question_answerer(question=question, context=context)
        return {'result': result}


if __name__ == '__main__':
    svc = MyPipelineService()
    svc.save()
