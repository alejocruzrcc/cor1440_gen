# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#//= require sip/motor
#//= require jquery-ui/autocomplete
#//= require cocoon


@cor1440_gen_prepara_eventos_comunes = (root) ->
  $(document).on('click', '.envia_filtrar', (e) -> 
    f = e.target.form
    a = f.action
    if a.endsWith(".pdf")
    	$(f).attr("action", a.substr(0, a.length-4))
    	$(f).removeAttr("target")
  )
  $(document).on('click', '.envia_generar_pdf', (e) -> 
    f = e.target.form
    a = f.action
    if !a.endsWith(".pdf")
    	$(f).attr("action", a + ".pdf")
    	$(f).attr("target", "_blank")
  )

