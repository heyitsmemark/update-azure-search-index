FROM alpine:latest

LABEL "com.github.actions.name"="Update Azure Cognitive Search index"
LABEL "com.github.actions.description"="Updates an existing index within a specified Azure Cognitive Search instance."
LABEL "com.github.actions.icon"="search"
LABEL "com.github.actions.color"="green"
LABEL "repository"="https://github.com/heyitsmemark/update-azure-search-index"
LABEL "homepage"="https://github.com/heyitsmemark/update-azure-search-index"
LABEL "maintainer"="heyitsmemark"

ADD entrypoint.sh /entrypoint.sh

RUN apk update && apk add curl jq
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]