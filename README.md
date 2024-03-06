# opensearch-github-actions
Github Actions for running OpenSearch

## Inputs

| Name                     | Required | Default  | Description                                                                                                                               |
|--------------------------|----------|----------|-------------------------------------------------------------------------------------------------------------------------------------------|
| `version`          | Yes      |          | The version of OpenSearch you need to use, you can use any version present in [gallery.ecr.aws](https://gallery.ecr.aws/opensearchproject/opensearch). |
| `security-disabled`       | No       | false     |  Set to `true` to disable https and basic authentication                                                            |
| `nodes`                  | No       | 1        | Number of nodes in the cluster.                                                                                                           |
| `port`                   | No       | 9200     | Port where you want to run OpenSearch.                                                                                                 |
| `opensearch_password` | No       | changeme | The password for the user admin in your cluster                                                                                         |


## Usage

```yml
- name: Runs OpenSearch
  uses: theablefew/opensearch-github-actions/opensearch@main
  with:
    version: 2.12.0
    security-disabled: true
```


Heavily borrowed from elastic/elasticsearch-github-actions. :)