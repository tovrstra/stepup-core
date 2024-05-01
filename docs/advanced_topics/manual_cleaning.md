# Manual Cleaning

The automatic cleaning discussed [in a previous tutorial](../getting_started/automatic_cleaning.md)
is StepUp's default mechanism for removing irrelevant and unwanted files.
In exceptional situations, the automatic cleaning may not be sufficient,
in which case a more manual cleanup is required:

- A dependency has changed that StepUp cannot track, such as an upgrade of a systemwide tool used in your workflow.
  In this situation, StepUp cannot make the affected steps pending, and you may want to remove the affected outputs to rebuild them.

- You are planning a rather drastic reorganization of your project, including renaming some directories containing output files.
  When directories are renamed, StepUp can no longer clean up old outputs in the renamed directories.
  In this situation, you will want to cleanup outputs manually before renaming directories.

Simply removing outputs with the `rm` command is possible but quickly becomes tedious for larger projects.
The `cleanup` program, a companion to `stepup`, can selectively remove a large number of outputs with minimal end-user effort.
You need to provide as arguments the files whose (indirect) outputs all have to be removed.
Such arguments can be one of the two things:

1. If a file is given, all outputs using this file as input will be removed.
   Furthermore, if the file itself is also a build output, it will also be removed.
2. If a directory is given, all outputs will be removed from this directory.
   Furthermore, if the directory is created in the build, it will also be removed.

Files are removed recursively, for instance, outputs of outputs are also cleaned up.

!!! note "`cleanup` requires `stepup` to be running."

    The `cleanup` script sends a list of paths to clean to the director process.
    The director takes care of analyzing the workflow to decide which files need to be removed.
    For this reason, an instance of `stepup` must be running for `cleanup` to work.


## Try the Following

- The [Static Named Glob](static_named_glob.md) tutorial provides a good test case for experimenting with `cleanup`.
  For this example, run `stepup` without any arguments.
  Then open a second terminal in the same directory and run `cleanup ch3/sec3_1_applications.txt`.
  You will see that the following files are deleted:

    - `ch3/sec3_1_applications.md`
    - `public/ch3.md`

- In the previous points, also try removing all outputs with `cleanup ./`