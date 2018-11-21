# Debugging Reflow

## Debugging multiple jobs from `reflow runbatch`

### How to capture standard error (stderr) if all your output disappears

If you're in `screen`, you may not be able to <a href="https://github.com/grailbio/reflow/issues/42" class="external-link">see all output</a> because it disappears before you have a chance. Then it's good to redirect the stderr to a file so you can at least inspect it:

``` syntaxhighlighter-pre
✘  Sat  9 Jun - 00:11  ~/kmer-hashing/sourmash/maca/facs   origin ☊ master ✔ 2☀ 
 ubuntu@olgabot-reflow  reflow runbatch 2&> err

 ✘  Sat  9 Jun - 00:11  ~/kmer-hashing/sourmash/maca/facs   origin ☊ master ✔ 2☀ 
 ubuntu@olgabot-reflow  less err
reflow: batch program ~/reflow-workflows/sourmash.rf runsfile samples.csv
reflow: batch program ~/reflow-workflows/sourmash.rf runsfile samples.csv
open /home/ubuntu/.reflow/runs/12f9a53350fa89e25c121c2b56c2e22a92ce923c55656dbe776432c974ff3f38.json: too many open files
open /home/ubuntu/.reflow/runs/12f9a53350fa89e25c121c2b56c2e22a92ce923c55656dbe776432c974ff3f38.json: too many open files
```


### How to check on your running batch

First, open a new `screen` or `tmux` window. In this example, my batch information is in the folder `~/kmer-hashing/sourmash/maca/facs` so we'll change to that directory since it contains the `config.json`:

``` syntaxhighlighter-pre
cd ~/kmer-hashing/sourmash/maca/facs
reflow batchinfo
```

### How to look at the last 20 lines of ALL log files

The last 20 lines are usually pretty informative to show where in the process all your samples are. It's best to pipe that output into `less -S` so it's easy to scroll through since there's a bunch of output.

```
tail -n 20 log.* | less -S
```

If you get a "too many files" error, use `xargs` and do this instead:


```
ls -1 | grep -E '^log\.' | tail -n 20 | less -S
```

### How to look at nonzero log files

You will have a LOT of log files ... which is annoying. To look only at the nonzero ones, you can filter the `ls -lha` output for only files that are kilobytes or more, i.e. {some digit}K, e.g. `grep -P '\dK'` and take the last column (column 9), then feed all of those files into `tail` with `xargs` and use `less` so you can page through everything:

``` syntaxhighlighter-pre
 ls -lha | grep -P '\dK' | grep log | cut -f 9 -d ' '| xargs tail -n 50 | less
```

### How to look at the created files

It can also be useful to take a peek at the files as they're getting created. In this particular workflow, we're creating a `{sample_id}.signature` file for every sample, in the s3 bucket `s3://olgabot-maca/facs/sourmash/`. We can look at the growing file list there by doing `aws s3 ls` of the bucket and then counting the lines with `wc -l` :

``` syntaxhighlighter-pre
 Mon 11 Jun - 19:31  /mnt/data/maca/facs 
 ubuntu@olgabot-reflow  aws s3 ls s3://olgabot-maca/facs/sourmash/ | wc -l
1086
```

### What to do when you have a bunch of jobs "waiting"

If you ran `reflow runbatch` and then walk away, you'd hope that all your jobs are done when you get back. Unfortunately, only a few jobs may have finished, as in this example where `unique_prefixes` is a list of S3 folders that should have outputs:

<span class="confluence-embedded-file-wrapper"><img src="https://tettra-production.s3.us-west-2.amazonaws.com/teams/38108/users/91771/cqSF7LFnfn5UOfQUr8esFQvrNsqixiao5EVtkFBN.png" class="confluence-embedded-image confluence-external-resource" /></span>

Check the output of `reflow listbatch` which if your batch failed, will show that there's a bunch of jobs "waiting." An example excerpt is below:

``` syntaxhighlighter-pre
 ✘  Tue 26 Jun - 21:39  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 6☀ 
 ubuntu@ip-172-31-42-179  reflow listbatch
A1-B002427-3_39_F-1-1_trim=false_scaled=100     12af8e26 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1000    9568d8b3 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1100    6bcd3d1a waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1200    8508d407 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1300    c38167a2 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1400    297c2a9f waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1500    6daec549 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1600    345e906f waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1700    1d2d96df waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1800    c2031915 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=1900    8aefd12a waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=200     273354de waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=2000    d026b17e waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=2500    9e06336f waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=300     dee9cefc waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=3000    0efb3c07 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=3500    61df5887 waiting
A1-B002427-3_39_F-1-1_trim=false_scaled=400     818f00a6 waiting
```

*!!! Solution: run* `reflow runbatch -retry` *which will rerun your jobs !!!*


## Debugging single jobs - inspect running and dead jobs

#### **Shell into current**`<strong>exec</strong>` **environment**

While an exec is running, you can shell into its environment with `reflow shell`; get the exec uri via `reflow ps -l,` then pass that into reflow shell. Open a new terminal when you do this :)

for example,

``` syntaxhighlighter-pre
reflow shell ec2-54-214-227-181.us-west-2.compute.amazonaws.com:9000/f1d4fc064c7a85c8/f046b4086edc0cee84b46d633a43fff01d203d4b3c92442cf9a77d0d7276f000
```

<span id="reflow-ssh-into-a-running-instance" class="confluence-anchor-link"></span>

#### **SSH into a running instance**

If you have a public SSH key in `~/.ssh/id_rsa.pub`, then this will be automatically installed on the Reflow instances, and you can ssh in to each instance (under the user "`core`"), e.g.,: `ssh core@ ec2-54-214-227-181.us-west-2.compute.amazonaws.com`

<span id="reflow-retrieve-intermediate-files" class="confluence-anchor-link"></span>

#### **Retrieve intermediate files**

You can retrieve files that were produced by immediate stages by using `reflow cat`, e.g., `reflow cat sha256:... > myfile` if you want to inspect these.

<span id="reflow-how-to-force-rerunning-of-a-workflow" class="confluence-anchor-link"></span>

**How to force rerunning of a workflow**
----------------------------------------

WHen Reflow finishes successfully, it then considers the job done and caches the result. To force re-running the job without the cache, use either:

`reflow run -eval=bottomup -invalidate=.* myworkflow.rf`

or

`reflow -cache=off run myworkflow.rf`

<span id="reflow-how-to-run-1000s-of-files-at-once" class="confluence-anchor-link"></span>
