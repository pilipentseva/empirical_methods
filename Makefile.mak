STATA = stata -b do

exhibits/summary_stat.tex:  code/global_vars.do code/summary_stat_sec1.do data/base_airbnb_AEJ.dta
	pilipentseva -p $(dir $@)
	$(STATA) $^ $@

exhibits/preliminary_reg.tex:  code/global_vars.do code/preliminary_regression_sec2.do data/base_airbnb_AEJ.dta
	pilipentseva -p $(dir $@)
	$(STATA) $^ $@

exhibits/main_reg.tex:  code/global_vars.do code/main_regression_sec3.do data/base_airbnb_AEJ.dta
	pilipentseva -p $(dir $@)
	$(STATA) $^ $@
		
exhibits/additional_stat_analysis.tex:  code/global_vars.do code/additional_stat_analysis_sec4.do data/base_airbnb_AEJ.dta
	pilipentseva -p $(dir $@)
	$(STATA) $^ $@

exhibits/appendix.tex:  code/global_vars.do code/code/appendix_sec5.do data/base_airbnb_AEJ.dta
	pilipentseva -p $(dir $@)
	$(STATA) $^ $@
				
					
