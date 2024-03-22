# DigitalOcean Docker Registry Cleanup
This GitHub Action removes outdated image manifests, ensuring efficient resource management and reducing clutter in your registry. It's particularly beneficial when you're pushing images of multiple environments to the same repository, each with a different naming convention (e.g., adding a suffix like `-dev`, `-staging`, `-prod`, etc.).

## Usage

Add this step to a job to automatically delete older images as part of a job:

```yaml
steps:
  - name: Install doctl
    uses: digitalocean/action-doctl@v2
    with:
      token: ${{ secrets.DIGITALOCEAN_API_KEY }}
  - name: Remove old images from Container Registry
    uses: mrsethsamuel/digitalocean-docker-registry-cleanup@v1
    with:
      repository: "test-repo-2, test-repo-2"  # required
      environment: "dev, staging, prod"
      num_to_keep: 5
      perform_gc: false
```

## Inputs

- **repository** - (Required) Image repository names in the Container Registry, separated by commas. 
- **environment** - (Optional) Environments for which to remove old images (e.g., dev, staging, prod), separated by commas.
- **num_to_keep** - (Optional) Number of recent images to keep. Default is 5
- **perform_gc** - (Optional) Whether to trigger garbage collection after removing old images. Default is false


## Outcome
The provided input leads to the execution of the github actions Which yields the following output:

```shell
No manifests found for test-repo-1 (dev) to delete.
No manifests found for test-repo-1 (staging) to delete.
No manifests found for test-repo-1 (prod) to delete.
No manifests found for test-repo-2 (dev) to delete.
No manifests found for test-repo-2  (staging) to delete.
No manifests found for test-repo-2  (prod) to delete.
Garbage collection is skipped.
```

## License

This GitHub Action and associated scripts and documentation in this project are released under the Apache License 2.0 License.
