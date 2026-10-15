#ifdef YAML_CONV2
  ! lchnk is available from state%lchnk (no new parameter needed)

  character(len=200) :: ext_str
  type(yaml_vars) :: yaml
  integer  :: unit_input, unit_output, y_nstep
  integer,save :: n_calls=0
  integer  :: convproc_do_aer_int, convproc_do_gas_int

  !populate YAML structure
  yaml%lev_print = 51 !level (**remove these if generating data for a dependent subroutines**)
  yaml%nstep_print = 355 !time step(**remove these if generating data for a dependent subroutines**)

  !YAML file input generation code- DO NOT PORT to C++
  !print all inputs one-by-one at column "yaml%col_print"
  yaml%col_print = icolprnt(state%lchnk) !column to write data(**remove these if generating data for a dependent subroutines**)
  y_nstep = get_nstep() !time step (**remove these if generating data for a dependent subroutines**)

  yaml%flag_print = .false. ! to write or not to write data (**remove these if generating data for a dependent subroutines**)
  !In the case of y_i or y_k are not passed as arguments:
  if(yaml%col_print > 0 .and. y_nstep==yaml%nstep_print ) then

  ! record number of calls that can output yaml file. you only need to write one set of input/output
  n_calls = n_calls+1
  ! if (n_calls==1) then ! output the first call. change this if writing out other calls

     yaml%lchnk_print = state%lchnk !(**remove these if generating data for a dependent subroutines**)
     yaml%flag_print  = .true.!(**remove these if generating data for a dependent subroutines**)

     !open I/O yaml files (it can have an extra optional argument to pass a unique string to differentiate file names)
     call open_files('ma_convproc_intr', &  !intent-in
!             unit_input, unit_output) !intent-out
          unit_input, unit_output) !intent-out

      !start by adding an input string
      call write_input_output_header(unit_input, unit_output,yaml%lchnk_print,yaml%col_print, &
           'convective_processing',yaml%nstep_print, yaml%lev_print)

      !< add code for writing data here>
      ! Convert logical flags to integers
      convproc_do_aer_int = 0
      if (convproc_do_aer) convproc_do_aer_int = 1
      convproc_do_gas_int = 0
      if (convproc_do_gas) convproc_do_gas_int = 1

      ! Write control flags
      call write_var(unit_input, unit_output, 'convproc_do_aer', convproc_do_aer_int)
      call write_var(unit_input, unit_output, 'convproc_do_gas', convproc_do_gas_int)

      ! state components - extract from state%var instead of passing state directly
      call write_1d_var(unit_input, unit_output, 'state_pdeldry', pver, state_pdeldry(yaml%col_print,:))
     call write_1d_var(unit_input, unit_output, 'state_pdel', pver, state_pdel(yaml%col_print,:))
     call write_1d_var(unit_input, unit_output, 'state_t', pver, state_t(yaml%col_print,:))
     call write_1d_var(unit_input, unit_output, 'state_pmid', pver, state_pmid(yaml%col_print,:))
     call write_2d_var(unit_input, unit_output, 'state_q', pver, pcnst, state%q(yaml%col_print,:,:))

     ! initial ptend components
     call write_1d_var(unit_input, unit_output, 'ptend_lq_init', pcnst, ptend_lq)
     call write_2d_var(unit_input, unit_output, 'ptend_q_init', pver, pcnst, ptend_q(yaml%col_print,:,:))

     call write_var(unit_input,unit_output,'dt',dt)
     call write_1d_var(unit_input,unit_output,'dp_frac', pver, dp_frac(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'icwmrdp', pver, icwmrdp(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'rprddp', pver, rprddp(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'evapcdp', pver, evapcdp(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'sh_frac', pver, sh_frac(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'icwmrsh', pver, icwmrsh(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'rprdsh', pver, rprdsh(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'evapcsh', pver, evapcsh(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'dlf', pver, dlf(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'dlfsh', pver, dlfsh(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'cmfmcsh', pverp, cmfmcsh(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'sh_e_ed_ratio', pver, sh_e_ed_ratio(yaml%col_print,:))
     call write_var(unit_input,unit_output,'nsrflx_mzaer2cnvpr',nsrflx_mzaer2cnvpr)
     call write_2d_var(unit_input,unit_output,'qsrflx_mzaer2cnvpr', pcnst, nsrflx_mzaer2cnvpr, qsrflx_mzaer2cnvpr(yaml%col_print,:,:))
     call write_1d_var(unit_input,unit_output,'mu', pver, mu(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'md', pver, md(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'du', pver, du(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'eu', pver, eu(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'ed', pver, ed(yaml%col_print,:))
     call write_1d_var(unit_input,unit_output,'dp', pver, dp(yaml%col_print,:))
     call write_var(unit_input,unit_output,'jt',jt(yaml%col_print))
     call write_var(unit_input,unit_output,'maxg',maxg(yaml%col_print))
     call write_var(unit_input,unit_output,'ideep',ideep(yaml%col_print))
     call write_var(unit_input,unit_output,'lengath',lengath)
     call write_1d_var(unit_input, unit_output,'species_class',size(species_class),species_class)

     !writes aerosol mmr from state%q or q vector (cloud borne and interstitial)
     !"aer_num_only" is .ture. if printing aerosol num only
     !call write_aerosol_mmr_from_stateq(unit_input, unit_output, fld_name,field,aer_num_only)

     !close only the input file, not the output file
     close(unit_input)
     call freeunit(unit_input)
  endif
#endif
