# reflow-workflows
[![Build Status](https://travis-ci.org/czbiohub/reflow-workflows.svg?branch=master)](https://travis-ci.org/czbiohub/reflow-workflows) [![Documentation Status](https://readthedocs.org/projects/reflow-workflows/badge/?version=latest)](https://reflow-workflows.readthedocs.io/en/latest/?badge=latest)


Commonly used bioinformatics pipelines written in [Reflow](https://github.com/grailbio/reflow).

## How to run workflows

You'll need to install Golang and [Reflow](https://github.com/grailbio/reflow) if you haven't already.

To run a workflow, use `reflow run myworkflow.rf`. Some workflows have command line arguments, e.g.

```
reflow run demux.rf RUNID OUTFOLDER
```


## Debugging a workflow


### How to add syntax highlighting

In Atom/Sublime Text, set the syntax highlighting for `.rf` files as the Go (golang) syntax. It's not perfect but it's something.

### How to inspect running and dead jobs

#### Shell into current `exec` environment

While an exec is running, you can shell into its environment with `reflow shell`; for example, `reflow exec ec2-54-214-227-181.us-west-2.compute.amazonaws.com:9000/f1d4fc064c7a85c8/f046b4086edc0cee84b46d633a43fff01d203d4b3c92442cf9a77d0d7276f000`

#### SSH into a running instance

If you have a public SSH key in `~/.ssh/id_rsa.pub`, then this will be automatically installed on the Reflow instances, and you can ssh in to each instance (under the user "`core`"), e.g.,: `ssh core@ ec2-54-214-227-181.us-west-2.compute.amazonaws.com`

#### Retrieve intermediate files

You can retrieve files that were produced by immediate stages by using `reflow cat`, e.g., `reflow cat sha256:... > myfile` if you want to inspect these.

### How to force rerunning of a workflow

WHen Reflow finishes successfully, it then considers the job done and caches the result. To force re-running the job without the cache, use either:

```
reflow run -eval=bottomup -invalidate=.* myworkflow.rf
```


```
reflow -cache=off run myworkflow.rf
```
