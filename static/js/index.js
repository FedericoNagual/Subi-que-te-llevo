$('.canc').click(function(){
    viaje = $(this).val()
    viaje = JSON.stringify(viaje, null, 2)
    console.log(viaje)
    $.post(
        "/cancelar",
        {viaje:viaje},
        function(data){
            window.location = "/historial"
        }
    )
})