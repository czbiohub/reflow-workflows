
# Subcommand Reference


``` syntaxhighlighter-pre
✘  Tue 26 Jun - 22:04  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow -help
Reflow is a tool for managing execution of Reflow programs.

Usage of reflow:
        reflow [flags] <command> [args]
Reflow commands:
        batchinfo
        cat
        collect
        config
        doc
        ec2instances
        images
        info
        kill
        list
        listbatch
        logs
        migrate
        offers
        ps
        repair
        rmcache
        run
        runbatch
        setup-dynamodb-assoc
        setup-ec2
        setup-s3-repository
        shell
        sync
        version
Global flags:
  -assoc string
        override assoc from config; see reflow config -help
  -aws string
        override aws from config; see reflow config -help
  -awsregion string
        override awsregion from config; see reflow config -help
  -awstool string
        override awstool from config; see reflow config -help
  -base string
        override base from config; see reflow config -help
  -cache string
        override cache from config; see reflow config -help
  -cluster string
        override cluster from config; see reflow config -help
  -config string
        path to configuration file; otherwise use default (builtin) config (default "/home/ubuntu/.reflow/config.yaml")
  -cpuprofile string
        capture a CPU profile and deposit it to the provided path
  -http string
        run a diagnostic HTTP server on this port
  -https string
        override https from config; see reflow config -help
  -log string
        set the log level: off, error, info, debug (default "info")
  -logger string
        override logger from config; see reflow config -help
  -project string
        project for which the job is launched (for accounting)
  -repository string
        override repository from config; see reflow config -help
  -universe string
        digest namespace
  -user string
        override user from config; see reflow config -help
```

batchinfo
---------

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:56  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow batchinfo -help
usage: reflow batchinfo

Batchinfo displays runtime information for the batch in the current directory.
See runbatch -help for information about Reflow's batching mechanism.

Flags:
  -help
        display subcommand help
```

cat
---

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:56  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow cat -help
usage: reflow cat files...

Cat copies files from Reflow's repository

Flags:
  -help
        display subcommand help
```

collect
-------

``` syntaxhighlighter-pre
Tue 26 Jun - 21:56  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow collect -help
usage: reflow collect [-threshold date]

Collect performs garbage collection of the reflow cache,
        removing entries that have not been accessed more recently than the
        provided threshold date.

Flags:
  -dry-run
        when true, reports on what would have been collected without actually removing anything from the cache (default true)
  -help
        display subcommand help
  -rate int
        maximum writes/sec to dynamodb (default 300)
  -threshold string
        cache entries older than this threshold will be collected (default "YYYY-MM-DD")
```

config
------

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:56  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow config -help
usage: reflow config

Config writes the current Reflow configuration to standard 
output.

Reflow's configuration is a YAML file with the follow toplevel
keys:

assoc: dynamodb,table
        configure an assoc using the provided DynamoDB table name

aws: awsenv
        configure AWS credentials from the user's environment
aws: ec2metadata
        use EC2/IAM role credentials

awstool: docker,image
        use the given docker image containing the AWS CLI

cache: off
        turn caching off
cache: read
        read-only caching
cache: read+write
        read and write caching
cache: s3,bucket,table
        configure a cache using an S3 bucket and DynamoDB table (legacy)
cache: write
        write-only caching

cluster: ec2cluster
        configure a cluster using AWS EC2 compute nodes
cluster: static
        configure a static cluster

https: file,authoritycert,cert,key
        configure HTTPS from provided files
https: httpsca,pem
        configure a HTTPS CA from the provided PEM-encoded signing certificate

repository: s3,bucket
        configure a repository using an S3 bucket

user: local,username
        provide a local username

A Reflow distribution may contain a builtin configuration that may be
modified and overriden:

        $ reflow config > myconfig
        <edit myconfig>
        $ reflow -config myconfig ...

Flags:
  -help
        display subcommand help
  -marshal
        marshal the configuration before displaying it
```

doc
---

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:57  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow doc -help   
usage: reflow doc path

Doc displays documentation for Reflow modules.

Flags:
  -help
        display subcommand help
```

ec2instances
------------

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:57  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow ec2instances -help
usage: reflow ec2instances

Ec2instances lists EC2 instance types known by Reflow.

The columns displayed by the instance listing are:

        type    the name of the instance type
        mem     the amount of instance memory (GiB)
        cpu     the number of instance VCPUs
        price   the hourly on-demand price of the instance in the selected region
        cpu features
                        a set of CPU features supported by this instance type
        flags   a set of flags:
                    ebs    when the instance supports EBS optimization
                    old    when the instance is not of the current generation

Flags:
  -help
        display subcommand help
  -region string
        region for which to show prices (default "us-west-2")
  -sort string
        sorting field (type, cpu, mem, price) (default "type")
```

images
------

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:57  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow images  -help     
usage: reflow images path

Images prints the paths of all Docker images used by a reflow program.

Flags:
  -help
        display subcommand help
```

info
----

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:57  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow info -help
usage: reflow info names...

Info displays general information about Reflow objects.

Info displays information about:

        - runs
        - cached filesets
        - files
        - execs
        - allocs

Where an opaque identifier is given (a sha256 checksum), info looks
it up in all candidate data sources and displays the first match.
Abbreviated IDs are expanded where possible.

Flags:
  -help
        display subcommand help
```

kill
----

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:58  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow kill -help
usage: reflow kill allocs...

Kill terminates and frees allocs.

Flags:
  -help
        display subcommand help
```

list
----

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:58  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow list -help
usage: reflow list [-a] [[-n] alloc]

List enumerates resources (allocs and execs) in a hierarchical fashion.

The columns displayed by list are:

        state   the state of an exec
        memory  the amount of reserved memory
        cpu     the number of reserved CPUs
        disk    the amount of reserved disk space
        ident   the exec's identifier, or the alloc's owner
        uri     the exec's or alloc's URI

Flags:
  -a    recursively list all resources
  -help
        display subcommand help
  -n    display entries only
```

listbatch
---------

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:58  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow listbatch -help
usage: reflow listbatch

Listbatch lists runtime status for the batch in the current directory.
See runbatch -help for information about Reflow's batching mechanism.

The columns displayed by listbatch are:

        id    the batch run ID
        run   the run's name
        state the run's state

Flags:
  -help
        display subcommand help
```

logs
----

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:58  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow logs -help
usage: reflow logs exec

Logs displays logs from execs.

Flags:
  -f    follow the logs
  -help
        display subcommand help
  -stdout
        display stdout instead of stderr
```

migrate
-------

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:59  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow migrate -help
usage: reflow migrate

Migrate forward-migrates Reflow's configuration and
underlying services.

Migrations are as follows:

reflow0.6:
 *      Convert cache configuration from the monolithic "cache" key to the
        split "repository" and "assoc" keys, configured separately.
 *      Add abbreviation indices to DynamoDB assocs to permit abbreviated
        lookups to command reflow info, others.

Flags:
  -help
        display subcommand help
```

offers
------

``` syntaxhighlighter-pre
 Tue 26 Jun - 21:59  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow offers -help
usage: reflow offers

Offers displays the currently available offers from the cluster.

Flags:
  -help
        display subcommand help
```

ps
--

``` syntaxhighlighter-pre
 ✘  Tue 26 Jun - 22:00  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow ps -help 
usage: reflow ps [-a] [-l]

Ps lists execs.

The columns displayed by ps are:

        run       the run associated with the exec
        ident     the exec identifier
        time      the exec's start time
        duration  the exec's run duration
        state     the exec's state
        mem       the amount of memory used by the exec
        cpu       the number of CPU cores used by the exec
        disk      the total amount of disk space used by the exec
        procs     the set of processes running in the exec

Ps lists only running execs; flag -a lists all known execs in any
state. Completed execs display profile information for memory, cpu,
and disk utilization in place of live utilization.

Ps must contact each node in the cluster to gather exec data. If a node 
does not respond within a predefined timeout, it is skipped, and an error is
printed on the console.

Flags:
  -a    list dead execs
  -help
        display subcommand help
  -l    show long listing
```

repair
------

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:01  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow repair -help
usage: reflow repair -batch samples.csv path | repair path [args]

Repair performs cache repair by cache-assisted pseudo-evaluation of
the provided reflow program. The program (evaluated with its arguments)
is evaluated by performing logical cache lookups in place of executor
evaluation. When values are missing and are immediately computable,
they are computed. Flow nodes that are successfully computed this way
are written back to the cache with all available keys. Repair is used to 
perform forward-migration of caching scheme, or back-filling when 
evaluations strategies change (e.g., bottomup vs. topdown evaluation).

Repair accepts command line arguments as in "reflow run" or parameters
supplied via a CSV batch file as in "reflow runbatch".

Flags:
  -batch string
        batch file to process
  -getconcurrency int
        number of concurrent assoc gets (default 50)
  -help
        display subcommand help
  -writebackconcurrency int
        number of concurrent writeback threads (default 20)
```

rmcache
-------

``` syntaxhighlighter-pre
Tue 26 Jun - 22:01  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow rmcache -help
usage: reflow cacherm

Rmcache removes items from cache. 
Items are digests read from the standard input.

Flags:
  -help
        display subcommand help
```

run
---

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:02  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow run -help 
usage: reflow run [-local] [flags] path [args]

Run type checks, then evaluates a Reflow program on the
cluster specified by the runtime profile. In local mode, run uses the
locally-available Docker daemon to evaluate the Reflow. 

If the Reflow program has the suffix ".reflow", it is taken to use
the legacy syntax; programs with suffixes ".rf" use the modern
syntax.

Arguments that are supplied after reflow program are parsed and
passed to that program. For programs using legacy syntax, these are
used to define "param" expressions; in modern programs, these are
used to define the module's parameters.

Run transcripts are printed to standard error and are logged in
        $HOME/.reflow/runs/yyyy-mm-dd/hhmmss-progname.exec
        $HOME/.reflow/runs/yyyy-mm-dd/hhmmss-progname.log

Reflow logs abbreviated task summaries for execs, interns, and
externs. On error, or if the logging level is set to debug, the full
task state is printed together with context.

Run exits with an error code according to evaluation status. Exit
code 10 indicates a transient runtime error. Exit codes greater than
10 indicate errors during program evaluation, which are likely not
retriable.

Flags:
  -alloc string
        use this alloc to execute program (don't allocate a fresh one)
  -dir string
        directory where execution state is stored in local mode (alias for local dir for backwards compatibilty)
  -eval string
        evaluation strategy (default "topdown")
  -gc
        enable garbage collection during evaluation
  -help
        display subcommand help
  -invalidate string
        regular expression for node identifiers that should be invalidated
  -local
        execute flow on the local Docker instance
  -localdir string
        directory where execution state is stored in local mode (default "/tmp/flow")
  -nocacheextern
        don't cache extern ops
  -recomputeempty
        recompute empty cache values
  -resources string
        override offered resources in local mode (JSON formatted reflow.Resources)
  -trace
        trace flow evaluation
```

runbatch
--------

``` syntaxhighlighter-pre
 ✘  Tue 26 Jun - 22:02  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow runbatch -help 
usage: reflow runbatch [-retry] [-reset] [flags]

Runbatch runs the batch defined in this directory.

A batch is defined by a directory with a batch configuration file named
config.json, which stores a single JSON dictionary with two entries, 
defining the paths of the reflow program to be used and the run file 
that contains each run's parameter. For example, the config.json file

        {
                "program": "pipeline.reflow",
                "runs_file": "samples.csv"
        }

specifies that batch should run "pipeline.reflow" with the parameters
specified in each row of "samples.csv".

The runs file must contain a header naming its columns. Its first
column must be named "id" and contain the unique identifier of each
run. The other columns name the parameters to be used for each reflow
run. Unnamed columns are used as arguments to the run. For example,
if the above "pipeline.reflow" specified parameters "bam" and
"sample", then the following CSV defines that three runs are part of
the batch: bam=1.bam,sample=a; bam=2.bam,sample=b; and
bam=3.bam,sample=c.

        id,bam,sample
        1,1.bam,a
        2,2.bam,b
        3,3.bam,c

Reflow deposits individual log files into the working directory for
each run in the batch. These are in addition to the standard log
files that are peristed for runs, and are always logged at the debug
level.

Flags:
  -eval string
        evaluation strategy (default "topdown")
  -gc
        enable runtime garbage collection
  -help
        display subcommand help
  -invalidate string
        regular expression for node identifiers that should be invalidated
  -nocacheextern
        don't cache extern ops
  -recomputeempty
        recompute empty cache values
  -reset
        reset failed runs
  -retry
        retry failed runs
```

setup-dynamodb-assoc
--------------------

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:02  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow setup-dynamodb-assoc -help
usage: reflow setup-dynamodb-assoc tablename

Setup-dynamodb-assoc provisions a table in AWS's DynamoDB service and
modifies Reflow's configuration to use this table as its assoc.

By default the DynamoDB table is configured with a provisoned
capacity of 10 writes/sec and 20 reads/sec. This can be 
modified through the AWS console after configuration.

The resulting configuration can be examined with "reflow config"

Flags:
  -help
        display subcommand help
```

setup-ec2
---------

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:02  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow setup-dynamodb-assoc -help
usage: reflow setup-dynamodb-assoc tablename

Setup-dynamodb-assoc provisions a table in AWS's DynamoDB service and
modifies Reflow's configuration to use this table as its assoc.

By default the DynamoDB table is configured with a provisoned
capacity of 10 writes/sec and 20 reads/sec. This can be 
modified through the AWS console after configuration.

The resulting configuration can be examined with "reflow config"

Flags:
  -help
        display subcommand help
```

setup-s3-repository
-------------------

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:03  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow setup-s3-repository -help
usage: reflow setup-s3-repository s3bucket

Setup-s3-repository provisions a bucket in AWS's S3 storage service
and modifies Reflow's configuration to use this S3 bucket as its
object repository.

The resulting configuration can be examined with "reflow config"

Flags:
  -help
        display subcommand help
```

shell
-----

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:03  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow shell -help              
usage: reflow shell exec

Run a shell (/bin/bash) inside the container of a running exec.
The local standard input, output and error streams are attached.
The user may exit the terminal by typing 'exit'/'quit'

Flags:
  -help
        display subcommand help
```

sync
----

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:03  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow sync -help 
usage: reflow sync [-sizeonly] [-index n] fileset path

Sync synchronizes a Reflow fileset with a local directory.

Sync skips downloading files that already exist and have the correct
Sync size and checksum. does not delete files in the target path that
are not also in the fileset.

Flags:
  -help
        display subcommand help
  -index int
        fileset list index
  -sizeonly
        validate files based on size alone
```

version
-------

``` syntaxhighlighter-pre
 Tue 26 Jun - 22:04  ~/kmer-hashing/sourmash/maca/facs_v5_1000cell_dna-only_scaled_trim_comparison   origin ☊ master ✔ 4☀ 
 ubuntu@ip-172-31-42-179  reflow version -help
usage: reflow version

Version displays this binary's version (datestamp) and git hash from which it was built.

Flags:
  -help
        display subcommand help
```
