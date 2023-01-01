# Information

This Bicep file will create for you a full-fletched Azure Service Bus. It is designed to deploy on dev, test or production environment but you can easily edit this by updating the @allowed tag over the "env" paremeter in main.bicep. 
Entrypoint is main.bicep and don't forget to update the parameters-files before running.

The following resources are going to be created:
- Resource Group 
- Azure Service Bus (Standard tier)
- Azure Service Bus Queue (Dead Letter Queue)
- Azure Service Bus Topic 
- 2 Subscriptions (one with and one without filters)
- 2 Authorization rules on topic level (one for send, one for listen)