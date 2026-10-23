gmq() {
  gh api graphql \
    -F owner='{owner}' -F name='{repo}' \
    -f query='
      query($owner: String!, $name: String!) {
        repository(owner: $owner, name: $name) {
          mergeQueue(branch: "main") {
            entries(first: 100) {
              nodes {
                position
                state
                pullRequest { number title }
              }
            }
          }
        }
      }' \
    --jq '.data.repository.mergeQueue.entries.nodes[] |
      [.position, .pullRequest.number, .state, .pullRequest.title] | @tsv'
}
