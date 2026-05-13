################################################################################
# Includes a Postprocessors for reactivity control. 
################################################################################
[Postprocessors]
  [rho_controll]
    type = ParsedPostprocessor
    #expression = '0'
    expression = 'if(t<=10000.0,5.154693e+02, -1000)'
    use_t = True
  []
[]

