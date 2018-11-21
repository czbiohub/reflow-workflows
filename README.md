# reflow-workflows
[![Build Status](https://travis-ci.org/czbiohub/reflow-workflows.svg?branch=master)](https://travis-ci.org/czbiohub/reflow-workflows)

Commonly used bioinformatics pipelines written in [Reflow](https://github.com/grailbio/reflow).

## How to run workflows

You'll need to install Golang and [Reflow](https://github.com/grailbio/reflow) if you haven't already.

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

	```
	aegea ssh ubuntu@olgabot-reflow
	```

3. Launch a screen or tmux window

	```
	screen
	```

	Or:

	```
	tmux new
	```
4. Copy your AWS credentials and public key from your local computer so Reflow knows who you are

	Copy your public key to the instance so that computer can recognize you:


	```
	aegea scp ~/.ssh/id_rsa.pub ubuntu@olgabot-reflow:~/.ssh/
	```

	If you get a `No such file or directory` error, you'll first need to [create a public key](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) (psst ... I don't use a passphrase )


	```
	scp -r ~/.aws ubuntu@ec2-54-218-96-104.us-west-2.compute.amazonaws.com:~
	```

5. Test that reflow is installed and sees your AWS credentials:

	Test for installation:
	```
	reflow
	```

	Test for 

	```
	reflow setup-ec2
	reflow setup-dynamodb-assoc czbiohub-reflow-quickstart
	```

	You should see this output:

	```
	reflow: creating DynamoDB table czbiohub-reflow-quickstart
	reflow: dynamodb table czbiohub-reflow-quickstart already exists
	reflow: dynamodb index ID4-ID-index already exists
	```

	Yay now we're ready to try some reflow workflows!

6. Set your name as the user for Reflow configure.
	Since the username of the machine is `ubuntu`, we only see `ubuntu@reflow` jobs that get launched by Reflow. This will replace the hostname (e.g. olgabot-reflow) for the username.

	```
	echo "user: local,$HOST@localhost" >> ~/.reflow/config.yml
	```


5. Get the latest version of aguamenti with `git pull`, then install it
	
	```
	cd aguamenti
	git pull
	make conda_install
	```

6. Clone the private reflow-batches repo, and create a branch for your project

	```
	# Go to the home directory
	cd 
	git clone https://github.com/czbiohub/reflow-batches
	git checkout -b '$USERNAME'
	```

7. Create a batch and write it to the reflow-batches

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

8. Change to the directory and run the batch!

	```
	~/reflow-batches/rnaseq/mus/20181030_FS10000331_12_BNT40322-1214/
	reflow runbatch
	```

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
