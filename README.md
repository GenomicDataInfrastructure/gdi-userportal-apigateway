# API Gateway For GDI User Portal

## What

This project has one main purpose, exercise and define how we are going to manage and integrate with multiple components.

We will be testing two solutions:

- Kong
- Gravitee.io

## Why

So we can achieve:

- Centralised security
- Centralised observability
- API Routing
- Resiliency

## Gravitee Takeaways

#### Installation

The installation is straightforward as Gravitee provides a docker-compose file ready to be used. The latter contains the following services: mongodb, elasticsearch, gateway, management-api, management ui, portal ui.

`docker-compose -f `docker-compose-name` up` is enough to get a running instance of Gravitee.

#### Configuration

Configuration can be done by creating a `gravitee.yaml` file. It offers a large scope for customizing Gravitee: CORS, security, databases, notifications...

However, the configuration of the endpoints (external APIs) seems to be only possible through the UI Portal. It could be unconvenient, especially on production environment where we would have preferred a config file instead of a UI.

Although in theory we should be able to do so, I was not able to get rid of some default components: MongoDB and ElasticSearch.

Overall, I feel that the configuration could be a bit tricky.

#### Features

Along with the API Gateway, Gravitee provides several other features: load balancer, policies (for traffic and communication), monitoring, audit... Yet, Kong provides a larger set of features.

#### Performances

The tests performed do not allow us to conclude anything about performances.

People tend to agree that Gravitee uses many RAM but provides good performances. Scaling horizontally and especially vertically is very effective with Gravitee.

#### Documentation and Community

From my experience, finding answers or troubleshooting in the documentation could be cumbersome.

Besides, the community seems to be relatively small as compared to Kong's one.
