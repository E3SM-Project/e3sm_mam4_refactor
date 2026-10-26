#ifdef YAML_CONV2
  ! lchnk is available from state%lchnk (no new parameter needed)

  character(len=200) :: ext_str
  type(yaml_vars) :: yaml
  integer  :: unit_input, unit_output, y_nstep
  integer,save :: n_calls=0
  integer  :: convproc_do_aer_int, convproc_do_gas_int
#endif
