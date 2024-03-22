#!/bin/bash

# Inputs
repositories="$1"
environments="$2"
num_to_keep="$3"
perform_gc="$4"


IFS=',' read -r -a repositories <<< "$repositories"
IFS=',' read -r -a environments <<< "$environments"

# Define the function to delete manifests
delete_manifests() {

    # Fetch all digests for the repository
    DIGESTS=$(doctl registry repository lm "$repository" --format Digest,UpdatedAt,Tags | tail -n +2 | grep "$environment" | sort -rk2 | awk '{print $1}')

    # Keep only the last $num_to_keep digests
    DIGESTS_TO_DELETE=$(echo "$DIGESTS" | tail -n +$(($num_to_keep+1)))

   # Check if DIGESTS_TO_DELETE is not empty
    if [ -n "$DIGESTS_TO_DELETE" ]; then
        # Echo the deleted manifests
        echo "Manifests found for $repository ($environment): $DIGESTS"
        echo "Manifest Digests to be removed for $repository ($environment): $DIGESTS_TO_DELETE"

        # Loop through each digest and delete its corresponding manifest
        for DIGEST in $DIGESTS_TO_DELETE; do
            doctl registry repository delete-manifest "$repository" "$DIGEST" --force
        done

        # Echo the deleted manifests
        echo "Manifest Digests removed for $repository ($environment): $DIGESTS_TO_DELETE"
    else
        echo "No manifests found for $repository ($environment) to delete."
    fi
}

# Loop through each repository and environment
for repository in "${repositories[@]}"; do
    for environment in "${environments[@]}"; do
        delete_manifests "$repository" "$environment"
    done
done

# Start garbage collection if perform_gc is true
if [ "$perform_gc" = true ]; then
    doctl registry garbage-collection start --include-untagged-manifests --force
else
    echo "Garbage collection is skipped."
fi
