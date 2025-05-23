# SCGC Homework

First observation: helm deployments are not working properly, in an production project I would use K8s as I know and make them work, but this is an educational project..

Task 5
I have some experience from Google Cloud Platform from work. We have a monolith application that runs on cloud and I saw graphs of load in different scenarios:
When QA Automation scripts where running....and it was the most disturbing for the infrastructure (we even got pod resource overflow and had the deployment scale up in replicas, which was not needed at that point)
I don't have access to production cloud, so the rest of the activity is pretty normal, just the development team works on the app (DEV, QA and business).

Denial-of-Service is basic....like my coleague did by mistake with his QAA scripts....:)
On local machine it can be done because the resources allocated are capped and the machine doesn't scale up, so it has a bottleneck, but just that.
On GCP we genuinely got an DOS because his pod where he started QAA script got everytime resource overflow and restart and also spawned more replicas...we set it to just 1 replica, and was no problem...but the pod kept getting resource overflow
and kept restarting every few minutes (when he received peak load). QAA script wasn't optimised to run on docker at that time.

Task 6
First secure action that goes in my mind is trying to solve this issue of DOS...the most elegant and usefull for us was to solve it so the pod doesn't restart. One solution was to cap JVM resources to 3 GBs RAM because we also had memory overflow on the 4GB pod.So first solution was to cap the JVM resources so it couldn't consume more than the pod offered. 
Other soltuion might be to use a gateway / proxy service like Kong and limit the ingres so it will not have that many requests ratio. Indeed in our application we had did this config, our server would return error "Too many requests" when it is attacked like a DOS, but it doesn't go down, thanks to our devops team that did that.
All in all in an app, it's recommended to use independent security module for authentication and authorization, OAuth etc.
Also from some Amazon EC2 experience, it's nice to filter the Ingress and Outgress and also specify just the IPv4/6 addresses that can communicate with the app, and also on which protocols.

P.S.: Sorry that I don't have screenshots for this part but helm did me bad this time...in practice, I like to use the tools that I know better and did work for me in the past (it saves time and efficiency)
Also, I had a full app + Terraform + K8s project at Cloud in sem 1, so it's not that a big deal. But SCGC was nice cause it tackled other more devops oriented fields and in a different way. 
