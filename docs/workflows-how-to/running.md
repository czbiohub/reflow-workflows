# Running workflows

## How to run single workflows

You'll need to install Golang and [Reflow](https://github.com/grailbio/reflow) if you haven't already.

To run a workflow, use `reflow run myworkflow.rf`. Some workflows have command line arguments, e.g.

```
reflow run demux.rf RUNID OUTFOLDER
```


## How to run multiple workflows (batch mode)

First, change into a directory containing a `samples.csv` and `config.json` (see [])

```
reflow runbatch
```

## Debugging workflows

Next, you probably want to check out [debugging workflows](debugging-workflows.md).