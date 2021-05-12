# `update-azure-search-index` GitHub Action

This repository contains an action for use with GitHub Actions, which updates an existing index within an Azure Cognitive Search instance.

> :information_source: This action can be used to both create or update indexes.

## Usage

Update an index using a local definition file:

```yaml
- name: Update index
  uses: heyitsmemark/update-azure-search-index@1.0.0
  with:
    azureSearchInstance: plop
    azureSearchAdminKey: ${{ secrets.AZURE_SEARCH_ADMIN_KEY }}
    indexName: index-plop
    indexDefinitionFile: ./path/to/index.json
```

Update an index using a remote definition file:

```yaml
- name: Update index 
  uses: heyitsmemark/update-azure-search-index@1.0.0
  with:
    azureSearchInstance: plop
    azureSearchAdminKey: ${{ secrets.AZURE_SEARCH_ADMIN_KEY }}
    indexName: index-plop
    indexDefinitionUri: https://domain.com/path/to/index.json
```

## Samples

Sample workflows are available [here](.github/workflows/)