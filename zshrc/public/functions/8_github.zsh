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
    --jq '.data.repository.mergeQueue |
      if . == null then
        "Merge queue is not configured for main."
      else
        .entries.nodes[] |
        [.position, .pullRequest.number, .state, .pullRequest.title] | @tsv
      end'
}
