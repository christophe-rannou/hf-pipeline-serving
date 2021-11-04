# Infrastructure

Infrastructure is fully handled using Terraform.

This Terraform module creates an OVHcloud Managed Kubernetes cluster and deploys a scalable app along with its monitoring.

### Requirements:
- Terraform CLI
- OVHcloud API keys, see [getting started](https://docs.ovh.com/gb/en/api/first-steps-with-ovh-api/)

## Usage

Populate terraform vars with the missing OVHcloud API keys along with the serviceName (public cloud project) you wish to use. Then:
```bash
tf plan
tf apply
```

Currently, the Nginx and monitoring services are exposed as LoadBalancer services, to get their IP you need to get the associated Service in your kubernetes cluster.
During the deployment a `kubeconfig.yaml` file was created in the Terraform module, you can use it to interact with the Kubernetes cluster:

## Accessing the app
Nginx IP:
```bash
❯ kubectl get service nginx-ingress-controller                                                                                                                                                                                                                                                                       (base)
NAME                       TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
nginx-ingress-controller   LoadBalancer   x.x.x.x   <NGINX-EXTERNAL-IP>    80:32171/TCP,443:32166/TCP   3h52m
```

The APP is exposed through Nginx using an Ingress, there is no DNS record registered within this Terraform so to actually query the question-answering API you will need to specify the correct host in the headers of your query.
The host is defined in the variables.tf under `app > host`
```bash
curl -X POST http://<NGINX-EXTERNAL-IP>:5000/predict \
-H "Host: serving.ai.com" \
-H "Content-Type: application/json" \
-d '{"question":"What is extractive question answering?", "context":"Extractive Question Answering is the task of extracting an answer from a text given a question. An example of a question answering dataset is the SQuAD dataset, which is entirely based on that task. If you would like to fine-tune a model on a SQuAD task, you may leverage the examples/pytorch/question-answering/run_squad.py script."}'
```


## Accessing Grafana

Grafana IP:
```bash
❯ k get service prometheus-stack-grafana                                                                                                                                                                                                                                                                             (base)
NAME                       TYPE           CLUSTER-IP   EXTERNAL-IP    PORT(S)        AGE
prometheus-stack-grafana   LoadBalancer   x.x.x.x   <GRAFANA-EXTERNAL-IP>   80:30727/TCP   3h53m
```
 You can find the Grafana credentials in a secret in the monitoring namespace `prometheus-stack-grafana`.
 
## Next steps
Globally the infrastructure needs 

### Securing
- IP tables for monitoring
- vRack
- SSL

### Monitoring
- log collection
- BentoML metrics scrape

### Access
Remove the LoadBalancer service to only use Ingresses