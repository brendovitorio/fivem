const c = (el)=>document.querySelector(el);
const cs = (el)=>document.querySelectorAll(el);
let porcemtageminicial = 1.7;
let questao = []
let pergunta = 1;
let acertos = 0;
let id = 0;
let Index = null
let aprovado = false;
let emTeste = false;
let finalizado = false;


$(function(){
    init();
    var actionContainer = $("#actionmenu");
    window.addEventListener('message',function(event){
        var item = event.data;
        if (item.Showmenu){
            emTeste = false;
            Index = item.Index;
            questao = item.Questions;
            actionContainer.show();
            $('#form-area').html('');
            inicioProva();
        }
        if (item.Hidemenu){
            actionContainer.hide();
        }
    });

    function init() {
        $(".menuoption").each(function(i,obj){
 
            if ($(this).attr("data-action")){
                $(this).click(function(){
                    $.post("http://driverlicense/Finish",JSON.stringify($(this).data("action")));
                })
            }
 
            if ($(this).attr("data-sub")){
                var menu = $(this).data("sub");
                var element = $("#"+menu);
 
                $(this).click(function(){
                    element.show();
                    $(this).parent().hide();
                })
            }
        });
    }

    document.onkeyup = function(data) {
        if (data.which == 27) {
            $.post("http://driverlicense/Finish");
        }
    };
})

function inicioProva(){
    if(emTeste == false){
        $('#resultado').hide();
        $('#sair').hide();
        $('#iniciando').show();
        $('#iniciando').html(`
            TESTE DMV<br>PRIMEIRA HABILITAÇÃO<br><br>
            <br>
            <br><br><br>
            <button id="bIniciar">INICIAR TESTE</button>
        `);
        /* $('#iniciando').html(`
            TESTE DMV<br>PRIMEIRA HABILITAÇÃO<br><br>
            <img src="https://static.wikia.nocookie.net/gtawiki/images/2/21/Lossantos_seal.png"/><br>
            CIDADE LOS SANTOS <br><br><br>
            <button id="bIniciar">INICIAR TESTE</button>
        `); */
    }else{
        nuiUF();
        $('#iniciando').hide();
    }
    $('#bIniciar').click(()=>{
        $('#iniciando').hide();
        emTeste = true;
        nuiUF();
    });   
}
function nuiUF(){
    if(emTeste = true){
        pergunta = 1;
        acertos = 0;
        questao.map((item, index)=>{
            let questaoItem = c('#formulario').cloneNode(true);
            questaoItem.setAttribute('data-key', index);
                questaoItem.querySelector('#pergunta').innerHTML = item.id+'. '+item.pergunta+'<br><br>';
                $('#formulario').addClass("teste");
                questaoItem.id = 'p'+item.id;
                questaoItem.querySelector('#perg1').innerHTML = '<input class="perguntas-input"  id="A'+item.id+'" value="A" type="checkbox"> a) '+item.a+'</input>';
                questaoItem.querySelector('#perg2').innerHTML = '<input class="perguntas-input"  id="B'+item.id+'" value="B" type="checkbox"> b) '+item.b+'</input>';
                questaoItem.querySelector('#perg3').innerHTML = '<input class="perguntas-input"  id="C'+item.id+'" value="C" type="checkbox"> c) '+item.c+'</input>';
                questaoItem.querySelector('#perg4').innerHTML = '<input class="perguntas-input"  id="D'+item.id+'" value="D" type="checkbox"> d) '+item.d+'</input><br><br>';
                questaoItem.querySelector('#botao').innerHTML = '<button class="proximo" id="r'+item.id+'">Próximo</button><br><br><br>';
            c('#form-area').append( questaoItem );
                $('#p'+pergunta).show();
                $('#p'+item.id).hide();
        });
        for(let i = 1; i <= questao.length; i++){
            $('#r'+i).click(()=>{
                let getResp = questao[i-1].resposta;
                if($('input').is(':checked')){
                    if($('#'+getResp).is(':checked')){
                        acertos++;
                    }
                        $('#p'+i).hide();
                        $('#p'+i).slideUp()
                            pergunta++;
                        $('#error').css('display', 'none');
                        $('#error').html('VOCÊ PRECISA DE ACERTAR AO MENOS 60% DA PROVA!');
                        $('#p'+pergunta).show();
                        $('#p'+pergunta).slideDown()
                        $('input[type="checkbox"]').prop("checked",  false);
                }else{
                    $('#error').css('background','transparent');
                    $('#error').css('display', 'block');
                    $('#error').html('RESPONDA UMA QUESTÃO');
                }
                if(pergunta == questao.length+1){
                    pergunta--;
                    let porcentagem = pergunta / porcemtageminicial;
                    if(acertos > porcentagem){
                        aprovado = true;
                        finalizado = true;
                        $('#resultado').show();
                        $('#resultado').html(`
                            <img class="imgResultado" src="https://cdn.discordapp.com/attachments/741015038307074059/748427777182793778/aprovado.png" style="opacity: 0.2;">
                            <img class="imgResultado" src="https://cdn.discordapp.com/attachments/741015038307074059/748428174622326784/posetivo.png" style="top: 200px; left: -35px; opacity: 0.2;">
                            <p>Parabéns você foi aprovado em nosso teste teórico contendo `+acertos+` acertos, dirija-se até o instrutor na parte externa.</p>                
                        `);
                        $('#sair').html('SAIR!');
                        $('#sair').show();
                        $('#sair').css('background', 'transparente');
                    }else{
                        aprovado = false;
                        finalizado = true;
                        $('#resultado').show();
                        $('#sair').show();
                        $('#sair').css('background', 'transparente');
                        $('#sair').html('SAIR!');
                        $('#resultado').html(`
                            <img class="imgResultado" src="https://cdn.discordapp.com/attachments/741015038307074059/748428175792537730/negativo.png" style="top: 200px; left: -35px; opacity: 0.2;">
                            <img class="imgResultado" src="https://cdn.discordapp.com/attachments/741015038307074059/748427778176712794/reprovado.png" style="opacity: 0.2;">
                            <p>Infelizmente você reprovou em nosso teste teórico contendo `+acertos+` acertos. Boa sorte na próxima vez!</p>
                        `);
                    }
                }
            }); 
        }
        $('input[type="checkbox"]').click(()=>{
            $(":checkbox").change(function(){
                $('input[type="checkbox"]').prop("checked", false);
                $(this).prop("checked", true);
            });
        });
    }else{
        inicioProva();
    }    

}

$('#sair').click((data)=>{
    $.post("http://driverlicense/Finish", aprovado && JSON.stringify({ Index: Index }) );
})