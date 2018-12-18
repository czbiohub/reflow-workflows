
How to *write* workflows
------------------------

**How to add syntax highlighting**

In Atom/Sublime Text, set the syntax highlighting for `.rf` files as the Go (golang) syntax. It's not perfect but it's something.

<span id="reflow-functions" class="confluence-anchor-link"></span>

### Functions

The basic unit of Reflow are functions which execute one or more specific commands on input files. In this example, the function `Compute` takes three arguments, `r1` and `r1` which are both lists of `file` objects, the `name` of the sample, and a `string` of kmer sizes to use.

`exec` must specify the docker `image` that is used, and other arguments like `mem` , `cpu` , and `disk` are optional. I suspect they have fairly small but reasonable defaults.

Notice that the output variable `signature` of `exec` is used in the command itself. This is important as the output of each command must be tracked. If a command outputs many files, the output can be of type `dir` instead of `file`.

``` syntaxhighlighter-pre
// Compute a minhash signature for a sample
func Compute(r1, r2 [file], name, ksizes string) = 
    exec(image := sourmash, mem := 4*GiB, cpu := 2) (signature file) {"
        /home/main/anaconda2/bin/sourmash compute --track-abundance --ksizes {{ksizes}} --name {{name}} --output {{signature}} {{r1}} {{r2}}
"}
```

### Basic workflow

When first writing a workflow, I recommend using a single sample to make sure you know it works. Here's the `Compute` function above written out to work with the images and files. Save this text to a file named `sourmash.rf` and try running it with `reflow run sourmash.rf`

``` syntaxhighlighter-pre
// Name of the docker image to use, i.e. this docker image is located
// at https://hub.docker.com/r/czbiohub/sourmash/
val sourmash = "czbiohub/sourmash"

// Compute a minhash signature for a sample
func Compute(r1, r2 [file], name, ksizes string) = 
    exec(image := sourmash, mem := 4*GiB, cpu := 2) (signature file) {"
        /home/main/anaconda2/bin/sourmash compute --track-abundance --ksizes {{ksizes}} --name {{name}} --output {{signature}} {{r1}} {{r2}}
"}

// Create a file for each element in the `read1s`, `read2s` string array
// Now `r1`, `r1` are arrays of files
val r1 = [file("s3://czbiohub-maca/remux_data/170907_A00111_0051_BH2HWLDMXX/rawdata/N8-MAA000612-3_9_M-1-1_S36/N8-MAA000612-3_9_M-1-1_S36_R1_001.fastq.gz)]
val r2 = [file("s3://czbiohub-maca/remux_data/170907_A00111_0051_BH2HWLDMXX/rawdata/N8-MAA000612-3_9_M-1-1_S36/N8-MAA000612-3_9_M-1-1_S36_R2_001.fastq.gz)]
val sample_id = "N8-MAA000612-3_9_M-1-1_S36"
val ksizes = "21,31,51"
val output_signature = "s3://olgabot-maca/facs/sourmash/N8-MAA000612-3_9_M-1-1_S36.signature"

val signature = Compute(r1, r2, sample_id, ksizes)

// Instantiate the system modules "files" (system modules begin
// with $), assigning its instance to the "files" identifier. To
// view the documentation for this module, run "reflow doc
// $/files".
val files = make("$/files")

val Main = files.Copy(signature, output_signature)
```

### How to write a workflow with arguments

Since you'll likely want to change the inputs to the function, let's expand upon our previous `sourmash.rf` file to one that can take command line arguments.

To add command line arguments, use the keyword `param`. Required arguments are specified by their file type only, in this case, `read1` , `read2` , `sample_id` and `output_signature` are all required. However, optional arguments are specified with their default value, in this case `ksizes` has the default value `"21,31,51"` . The rest of the function is largely the same except for some string processing that allows for multiple fastqs to be input.

``` syntaxhighlighter-pre
param (
    // S3 path to read1 of the fastq/fasta file. If multiple files, 
    // can be pipe-separated e.g. sample1_01.fastq|sample1_02.fastq
    read1 string

    // S3 path to read2 of the fastq/fasta file. If multiple files, 
    // can be pipe-separated e.g. sample1_01.fastq|sample1_02.fastq
    read2 string

    // Identifier of the sample
    sample_id string

    // Full s3 file location to put the sourmash signature
    output_signature string

    // Size of kmer(s) to use
    ksizes = "21,31,51"
)

// Name of the docker image to use, i.e. this docker image is located
// at https://hub.docker.com/r/czbiohub/sourmash/
val sourmash = "czbiohub/sourmash"

// Compute a minhash signature for a sample
func Compute(r1, r2 [file], name, ksizes string) = 
    exec(image := sourmash, mem := 4*GiB, cpu := 2) (signature file) {"
        /home/main/anaconda2/bin/sourmash compute --track-abundance --ksizes {{ksizes}} --name {{name}} --output {{signature}} {{r1}} {{r2}}
"}

// Instantiate system module "strings" to split on "|" character
val strings = make("$/strings")

// Split each read string by the pipe "|" to get individual s3 paths
val read1s = strings.Split(read1, "|")
val read2s = strings.Split(read2, "|")

// Create a file for each element in the `read1s`, `read2s` string array
// Now `r1`, `r1` are arrays of files
val r1 = [file(read1) | read1 <- read1s]
val r2 = [file(read2) | read2 <- read2s]

val signature = Compute(r1, r2, sample_id, ksizes)

// Instantiate the system modules "files" (system modules begin
// with $), assigning its instance to the "files" identifier. To
// view the documentation for this module, run "reflow doc
// $/files".
val files = make("$/files")

val Main = files.Copy(signature, output_signature)
```

The previous workflow can be run with the command line:

``` syntaxhighlighter-pre
reflow run sourmash.rf \
    -read1=s3://czbiohub-maca/remux_data/170907_A00111_0051_BH2HWLDMXX/rawdata/N8-MAA000612-3_9_M-1-1_S36/N8-MAA000612-3_9_M-1-1_S36_R1_001.fastq.gz \
    -read2=s3://czbiohub-maca/remux_data/170907_A00111_0051_BH2HWLDMXX/rawdata/N8-MAA000612-3_9_M-1-1_S36/N8-MAA000612-3_9_M-1-1_S36_R2_001.fastq.gz \
    -sample_id=N8-MAA000612-3_9_M-1-1_S36 \
    -output_signature=s3://olgabot-maca/facs/sourmash/N8-MAA000612-3_9_M-1-1_S36.signature
```
