# Electronic Research Data Archive, ERDA

On the University of Copenhagen, the Faculty of Science is hosting infrastructure for use in research and education. The entry to these services is called [Electronic Research Data Archive, ERDA](https://erda.ku.dk/).
As a student, you can [log in to the service with your normal UCPH credentials](https://erda.ku.dk/), and use the storage space for collaborations or datasets.


## Data analysis gateway, DAG

When you are working on datasets stored on ERDA you can use the DAG service, which is implemented as a [Jupyter](https://jupyter.org/hub) notebook where the ERDA storage is available.
The Python interactive environment can be a great way to explore large datasets without having to download the dataset to your machine.

For the HPPS course, you can use DAG and start a terminal to get access to a working GCC compiler as well as Make and other tools. 
When you use DAG, you get a shared server, suitable for exploration and testing, but not suited for long running sessions, or performance measurements.

## MPI Oriented Development and Investigation, MODI

For larger compute tasks, you can use the more performance oriented [MODI service](https://erda.dk/public/MODI-user-guide.pdf). 
This service has a set of reasonably powerful nodes that can be used to test and benchmark your solutions.
It is intended to be a testing site for HPC applications, and is thus ideally suited for the 4th and final assignment in the course.

Like most shared, large-scale facilities, MODI only allows execution of jobs submitted through the queue system.
Similar to large-scale facilities, MODI uses the [SLURM](https://slurm.schedmd.com/overview.html) scheduling system to give multiple users exclusive fair-usage allocations.

While SLURM contains many features, the most common ones are covered in a [SLURM Quickguide](https://gist.github.com/ctokheim/bf68b2c4b78e9851b469be3425470699).

**Important:** When running on MODI all your files need to be placed in `~/modi_mount` as this is the only folder the execution nodes can see. You need to place both the executable and any input/output files here. You can also only submit jobs from this folder, as the results cannot be written elsewhere.
