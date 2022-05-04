if did_filetype()
  finish
endif
if getline(1) =~# '^{'
  setfiletype json
endif
