# reflow-workflows
[![Build Status](https://travis-ci.org/czbiohub/reflow-workflows.svg?branch=master)](https://travis-ci.org/czbiohub/reflow-workflows) [![Documentation Status](https://readthedocs.org/projects/reflow-workflows/badge/?version=latest)](https://reflow-workflows.readthedocs.io/en/latest/?badge=latest)

Commonly used bioinformatics pipelines written in [Reflow](https://github.com/grailbio/reflow). Check out our [documentation!](https://reflow-workflows.readthedocs.io/en/latest/).

## How to run workflows
1. Launch an aegea instance with reflow

	Most likely, you'll want to run the workflow and walk away from it. Launch an aegea instance with reflow pre-installed on it. Make sure to change `$USERNAME` to your own AWS username, otherwise `aegea` will complain.

	```
	aegea launch --iam-role S3fromEC2 --ami-tags Name=czbiohub-reflow -t t2.micro  '$USERNAME-reflow'
	```

	If you're getting an error about `dns`, try this:


	```
	aegea launch --iam-role S3fromEC2 --ami-tags Name=czbiohub-reflow -t t2.micro --no-dns '$USERNAME-reflow'
	```

2. Now ssh into your instance

	We recommend using [iTerm2](https://www.iterm2.com/) for this as the 

	```
	aegea ssh ubuntu@olgabot-reflow
	```

	This will automatically launch a `tmux` session with `tmuxinator start reflow`, and should look like this:

	![Tmux session with ](images/fresh_instance_tmuxinator_login.png)


3. Create a batch and write it to the reflow-batches

	```
	aguamenti rnaseq-align \
		--output ~/reflow-batches/rnaseq/mus/20181030_FS10000331_12_BNT40322-1214/ \ 
		$EXPT_ID $TAXON s3://olgabot-maca/aguamenti-test/
	```

	Equivalently, you could assign bash variables to `EXPT_ID` and `TAXON` to make the output a little more readable:
	```
	EXPT_ID=20181030_FS10000331_12_BNT40322-1214
	TAXON=mus
	aguamenti rnaseq-align \
		--output ~/reflow-batches/rnaseq/$TAXON/$EXPT_ID \
		$EXPT_ID $TAXON s3://olgabot-maca/aguamenti-test/
	```

4. Change to the directory and run the batch!

	```
	cd ~/reflow-batches/rnaseq/mus/20181030_FS10000331_12_BNT40322-1214/
	```

	There should be both a `samples.csv` and `config.json` file there:

	```
	➜  20181030_FS10000331_12_BNT40322-1214 git:(master) ll
	Permissions Size User   Date Modified Git Name
	.rw-rw-r--    93 ubuntu 18 Dec 17:48   -- config.json
	.rw-rw-r--   49k ubuntu 18 Dec 17:48   -- samples.csv
	```

	To run the batch, do `reflow runbatch`!

5. Commit the changes and push to reflow batches ONCE. After this, it will push every hour automatically, but first it needs to store your username and password, which is why you need to enter it this first time

	First, tell git your name and email, otherwise it's assumed to be `ubuntu` which is lame.
	
	```
	git config --global user.name "Rosalind Franklin"
	git config --global user.email "you@email.com"
	```

	Now you're ready to push your changes!

	```
	git add -A .
	git commit -m "Added mus RNA-seq run for $EXPT_ID"
	# Get any updated changes before pushing
	git pull && git push
	```

To see how this image was built and set up if you want to use some of the info for your own, check out the [czbiohub/packer-images/reflow.json](https://github.com/czbiohub/packer-images/blob/master/reflow.json) recipe and [czbiohub/packer-images/scripts/reflow.sh](https://github.com/czbiohub/packer-images/tree/master/scripts) script.


#### On your local computer



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
