#ifdef YAML_AERO_MODEL_WETDEP_CONVPROC
  if(yaml%flag_print) then ! if this column exists in lchnk

     !write output header
     call write_output_header(unit_output)

     !start writing data

        call write_var(unit_output,'dgncur_a',dgncur_a(ideep(1),:,:))
        call write_var(unit_output,'wetdens',wetdens(ideep(1),:,:))
        call write_var(unit_output,'qaerwat',qaerwat(ideep(1),:,:))
        call write_var(unit_output,'dgnumwet',dgnumwet(ideep(1),:,:))
        call write_var(unit_output,'fracis',fracis(ideep(1),:,:))  

        call write_var(unit_output,'aerdepwetis',aerdepwetis(ideep(1),:))
        call write_var(unit_output,'aerdepwetcw',aerdepwetcw(ideep(1),:))

        ! ptend is passed as intent-out to aero_model_wetdep, so only include as output data.
        ! The following extract the fields from ptend used as output and write them to the data files.
        ! Use -9999.9 to fill in unused portions of the constituent arrays

        if (allocated(ptend_lq_1darr)) deallocate(ptend_lq_1darr)
        allocate(ptend_lq_1darr(size(ptend%lq)))

        if (allocated(ptend_q_3darr)) deallocate(ptend_q_3darr)
        allocate(ptend_q_3darr(size(ptend%q,1),size(ptend%q,2),size(ptend%q,3)))

        do imm=1,size(ptend%lq)
           if (imm<=15) then
                ptend_lq_1darr(imm) = -9999.9
                ptend_q_3darr(:,:,imm) = -9999.9
           else
                ptend_lq_1darr(imm) = ptend%lq(imm)
                ptend_q_3darr(:,:,imm) = ptend%q(:,:,imm)
           endif
        enddo
        call write_var(unit_output,'ptend_lq',ptend_lq_1darr(:))
        call write_var(unit_output,'ptend_q',ptend_q_3darr(ideep(1),:,:))
        deallocate(ptend_lq_1darr)
        deallocate(ptend_q_3darr)


 ! write out qqcw fields only over constituents that are set, for others set value to -9999.9
 ! do upon output as these fields should have been changed via the fldclw pointer

        if (allocated(qqcw_yaml_2darr)) deallocate(qqcw_yaml_2darr)
        allocate(qqcw_yaml_2darr(size(qqcw_yaml),pver))
        do imm=1,size(qqcw_yaml)
           if (imm<=15) then
                qqcw_yaml_2darr(imm,:) = -9999.9
           else
                qqcw_yaml_2darr(imm,:) = qqcw_yaml(imm)%fld(ideep(1),:)
           endif
        enddo
        call write_var(unit_output,'qqcw',qqcw_yaml_2darr)
        deallocate(qqcw_yaml_2darr)

     !writes aerosol mmr from state%q or q vector(cloud borne and interstitial) in the output python module
     !"aer_num_only" is .ture. if printing aerosol num only
     !call write_output_aerosol_mmr_from_stateq(unit_output, fld_name, field, aer_num_only, inp_out_str)

     !close the output file
     close(unit_output)
     call freeunit(unit_output)
  endif

!------------------------------------------------------------------------------------------------------------------------------
! This part of the code is for finding the best lat/lon and n_calls.
!------------------------------------------------------------------------------------------------------------------------------
!  real(r8), pointer :: lat(:), lon(:)
!  lat => state%lat
!  lon => state%lon
!
!   call write_var(unit_output,'lat',lat(yaml%col_print)*57.29577951308232_r8)
!   call write_var(unit_output,'lon',lon(yaml%col_print)*57.29577951308232_r8)
!
!  if(y_nstep == 1 .and. n_calls == 1) then
!     open(unit=214, file='info.txt', status='unknown')
!     write(214,*) "lchnk, icol, lat, lon, n_calls"
!  end if
!  if(y_nstep == yaml%nstep_print) then
!     write(214,*) y_lchnk, yaml%col_print, lat(yaml%col_print)*57.29577951308232_r8, &
!          lon(yaml%col_print)*57.29577951308232_r8, n_calls
!  end if
!  if(y_nstep > yaml%nstep_print) then
!     close(214)
!  end if
!------------------------------------------------------------------------------------------------------------------------------
#endif
