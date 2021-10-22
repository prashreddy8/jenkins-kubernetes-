# jenkins-kubernetes-example
=========================Setting up EKS cluster with terraform==================================

1. Navigate to <b>terraformcode\providers.tf</b> and edit your shared_credentials_file location wherever your aws credentialss are stored
2. Create the EKS cluster by navigating to tfcode directory and run `terraform plan`
   This will show you ~49 resources to add
3. Run `terraform apply`
   This process will take approx 15 mins to complete which will create EKS cluster 'my-eks-cluster' in your AWS account
4. Once applied, please verify that your EKS cluster is now active
5. Open shell window and run below command:
   `aws eks --region us-east-1 update-kubeconfig --name my-eks-cluster`
6. Verify by running `kubectl get nodes`. This will show you 3 worker nodes up and running.

=============Setting up CICD for Hellow orld project============================================

1. Goto manage plugins and add your EKS cluster credentails
2. Create a new pipeline in Jenkins and use Jenkinsfile in this repository

=========Monitoring pod metrics for nodejs application========================================

1. To attach the necessary policy to the IAM role for your worker nodes
2. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
3. Select one of the worker node instances and choose the IAM role in the description.
4. On the IAM role page, choose Attach policies.
5. In the list of policies, select the check box next to CloudWatchAgentServerPolicy. If necessary, use the search box to find this policy.
6. Choose Attach policies.
7. Run the following command to deploy container insight:

`ClusterName=<my-cluster-name>
RegionName=<my-cluster-region>
FluentBitHttpPort='2020'
FluentBitReadFromHead='Off'
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f - `

8. <b> Set up the CloudWatch agent to collect cluster metrics </b>
9. Create namespace for cloudwatch:
`kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml`
10. To create a service account for the CloudWatch agent
`kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-serviceaccount.yaml`
11. To create a ConfigMap for the CloudWatch agent
`curl -O https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-configmap.yaml`
12. Edit the downloaded YAML file, as follows:

`cluster_name – In the kubernetes section, replace {{cluster-name}} with the name of your cluster. Remove the {{}} characters. Alternatively, if you're using an Amazon EKS cluster, you can delete the "cluster_name" field and value. If you do, the CloudWatch agent detects the cluster name from the Amazon EC2 tags.`
13. Create the ConfigMap in the cluster by running the following command: `kubectl apply -f cwagent-configmap.yaml`
14. Download the DaemonSet YAML to your kubectl client host by running the following command
`curl -O  https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-daemonset.yaml`
15. Uncomment the port section in the cwagent-daemonset.yaml file as in the following:

ports:
  - containerPort: 8125
   hostPort: 8125
   protocol: UDP
    
16. Deploy the CloudWatch agent in your cluster by running the following command: `kubectl apply -f cwagent-daemonset.yaml`
17. Validate that the agent is deployed by running the following command: kubectl get pods -n amazon-cloudwatch`
18. Once configured you will be able to see the metrics as below for individual pods by selecting filters:

![cloudwatch filters](https://user-images.githubusercontent.com/45530974/138239708-830124a6-5ebc-49cf-b1f2-e4ca20466713.PNG)


19. Complete cloudwatch dashboard:

![CLoudwatch](https://user-images.githubusercontent.com/45530974/138239939-8a87a00f-dbee-4eb1-8661-7f54f27d51b4.PNG)






