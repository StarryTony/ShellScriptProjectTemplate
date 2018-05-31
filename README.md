# ShellScriptProjectTemplate
A template to quickly start a shell script project, it's easy to extend functions and supports customising profile as well as recording historical manipulations. Colourful theme & debug options are built-in.

To extend any function, just add your function to **arrayMenu** in the form of 'shortcuts ::function_name:: function_description' and then write your function body.
```
  showMenu(){
    arrayMenu=(
        # KEY::Function::Description
        'q      or Q::exit            ::Exit (Ctrl+C)'
        'o      or O::open_output     ::Open output'
        'r      or R::rename_output   ::Rename output'
        'd      or D::clean_cache     ::Clean output cache'
        'c      or C::setOutputDir    ::Choose the output directory'
        'p      or P::open_output_dir ::Open out directory'
        )
```
