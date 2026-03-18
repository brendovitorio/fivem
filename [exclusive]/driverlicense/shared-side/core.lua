Categories = {
    [1] = { 
        ["category"] = "A",
        ["description"] = "Moto",
        ["price"] = 2000,
        ["taxs"] = {
            theoretical = 100,
            practice = 350
        },
    },
    [2] = {  
        ["category"] = "B",
        ["description"] = "Carro",
        ["price"] = 5000,
        ["taxs"] = {
            theoretical = 100,
            practice = 350
        },
    },
    [3] = {  
        ["category"] = "C",
        ["description"] = "Ônibus",
        ["price"] = 8000,
        ["taxs"] = {
            theoretical = 100,
            practice = 350
        },
    },
    [4] = {  
        ["category"] = "D",
        ["description"] = "Caminhão",
        ["price"] = 12000,
        ["taxs"] = {
            theoretical = 100,
            practice = 350
        },
    },
}

Locations = {
    [1] = {
        ["coords"] = { 228.7,374.34,106.1,167.25 },
        ["categories"] = {
            [1] = { 
                vehicles = {"vader"},
                maxErros = 3,
                instructor = "a_m_y_genstreet_01",
                spawn = { 
                    {213.81, 390.05, 106.85, 173.2} 
                },
                route = {
                    { coords = { 213.16,364.29,106.25,246.62 }, text = "Verifique os dois lados da via, para garantir que está livre para proceguir." },
                    { coords = { 237.58,345.91,105.53,249.45 }, text = "Não é obrigatório esperar os semafaros, porém você deve parar em todos e garantir que a via está livre para seguir." },
                    { coords = { 404.59,298.94,102.97,249.45 }, text = "Mantenha uma distância segura do veículo à frente." },
                    { coords = { 549.09,247.59,103.1,331.66 }, text = "Atenção e cuidado ao atravessar esquinas." },
                    { coords = { 913.27,520.58,120.56,263.63 }, text = "Dirigir embriagado é crime!" },
                    { coords = { 1065.37,414.49,90.99,136.07 }, text = "O limite de velocidade das auto-estradas é de 120Km/h.", limiteSpeed = 120 },
                    { coords = { 536.55,-321.04,43.52,62.37 }, text = "É proíbido estacionar em áreas cuja uma faixa vermelha está pintada na calçada." },
                    { coords = { 246.9,-221.15,54.02,62.37 }, text = "O limite de velocidade de áreas comerciais é de 80Km/h.", limiteSpeed = 80 },
                    { coords = { -57.29,-103.02,57.79,351.5 }, text = "O limite de velocidade de áreas residenciais é de 60Km/h.", limiteSpeed = 60 },
                    { coords = { -40.29,18.62,72.0,351.5 }, text = "Transitar com veículos danificados é crime!" },
                    { coords = { 30.86,233.74,109.54,351.5 }, text = "Veículos de emergência possuem prioridade, de passagem!" },
                    { coords = { 201.62,358.26,106.39,314.65 }, text = "Você terminou seu teste, estacione na auto-escola para finalizar o percurso." },
                    { coords = { 220.14, 377.39, 106.46 }, text = "Aguarde, o examinador dará o resultado." },
                },
            },
            [2] = {  
                vehicles = {"premier"},
                maxErros = 3,
                instructor = "s_m_y_uscg_01",
                spawn = { 
                    {213.81, 390.05, 106.85, 173.2} 
                },
                route = {
                    { coords = { 213.16,364.29,106.25,246.62 }, text = "Verifique os dois lados da via, para garantir que está livre para proceguir." },
                    { coords = { 237.58,345.91,105.53,249.45 }, text = "Não é obrigatório esperar os semafaros, porém você deve parar em todos e garantir que a via está livre para seguir." },
                    { coords = { 404.59,298.94,102.97,249.45 }, text = "Mantenha uma distância segura do veículo à frente." },
                    { coords = { 549.09,247.59,103.1,331.66 }, text = "Atenção e cuidado ao atravessar esquinas." },
                    { coords = { 913.27,520.58,120.56,263.63 }, text = "Dirigir embriagado é crime!" },
                    { coords = { 1065.37,414.49,90.99,136.07 }, text = "O limite de velocidade das auto-estradas é de 120Km/h.", limiteSpeed = 120 },
                    { coords = { 536.55,-321.04,43.52,62.37 }, text = "É proíbido estacionar em áreas cuja uma faixa vermelha está pintada na calçada." },
                    { coords = { 246.9,-221.15,54.02,62.37 }, text = "O limite de velocidade de áreas comerciais é de 80Km/h.", limiteSpeed = 80 },
                    { coords = { -57.29,-103.02,57.79,351.5 }, text = "O limite de velocidade de áreas residenciais é de 60Km/h.", limiteSpeed = 60 },
                    { coords = { -40.29,18.62,72.0,351.5 }, text = "Transitar com veículos danificados é crime!" },
                    { coords = { 30.86,233.74,109.54,351.5 }, text = "Veículos de emergência possuem prioridade, de passagem!" },
                    { coords = { 201.62,358.26,106.39,314.65 }, text = "Você terminou seu teste, estacione na auto-escola para finalizar o percurso." },
                    { coords = { 220.14, 377.39, 106.46 }, text = "Aguarde, o examinador dará o resultado." },
                },
            },
            [3] = {  
                vehicles = {"rentalbus"},
                maxErros = 3,
                instructor = "ig_mp_agent14",
                spawn = { 
                    {213.81, 390.05, 106.85, 173.2} 
                },
                route = {
                    { coords = { 213.16,364.29,106.25,246.62 }, text = "Verifique os dois lados da via, para garantir que está livre para proceguir." },
                    { coords = { 237.58,345.91,105.53,249.45 }, text = "Não é obrigatório esperar os semafaros, porém você deve parar em todos e garantir que a via está livre para seguir." },
                    { coords = { 404.59,298.94,102.97,249.45 }, text = "Mantenha uma distância segura do veículo à frente." },
                    { coords = { 549.09,247.59,103.1,331.66 }, text = "Atenção e cuidado ao atravessar esquinas." },
                    { coords = { 913.27,520.58,120.56,263.63 }, text = "Dirigir embriagado é crime!" },
                    { coords = { 1065.37,414.49,90.99,136.07 }, text = "O limite de velocidade das auto-estradas é de 120Km/h.", limiteSpeed = 120 },
                    { coords = { 536.55,-321.04,43.52,62.37 }, text = "É proíbido estacionar em áreas cuja uma faixa vermelha está pintada na calçada." },
                    { coords = { 246.9,-221.15,54.02,62.37 }, text = "O limite de velocidade de áreas comerciais é de 80Km/h.", limiteSpeed = 80 },
                    { coords = { -57.29,-103.02,57.79,351.5 }, text = "O limite de velocidade de áreas residenciais é de 60Km/h.", limiteSpeed = 60 },
                    { coords = { -40.29,18.62,72.0,351.5 }, text = "Transitar com veículos danificados é crime!" },
                    { coords = { 30.86,233.74,109.54,351.5 }, text = "Veículos de emergência possuem prioridade, de passagem!" },
                    { coords = { 201.62,358.26,106.39,314.65 }, text = "Você terminou seu teste, estacione na auto-escola para finalizar o percurso." },
                    { coords = { 220.14, 377.39, 106.46 }, text = "Aguarde, o examinador dará o resultado." },
                },
            },
            [4] = {  
                vehicles = {"hauler"},
                maxErros = 3,
                instructor = "cs_drfriedlander",
                spawn = { 
                    {213.81, 390.05, 106.85, 173.2} 
                },
                route = {
                    { coords = { 213.16,364.29,106.25,246.62 }, text = "Verifique os dois lados da via, para garantir que está livre para proceguir." },
                    { coords = { 237.58,345.91,105.53,249.45 }, text = "Não é obrigatório esperar os semafaros, porém você deve parar em todos e garantir que a via está livre para seguir." },
                    { coords = { 404.59,298.94,102.97,249.45 }, text = "Mantenha uma distância segura do veículo à frente." },
                    { coords = { 549.09,247.59,103.1,331.66 }, text = "Atenção e cuidado ao atravessar esquinas." },
                    { coords = { 913.27,520.58,120.56,263.63 }, text = "Dirigir embriagado é crime!" },
                    { coords = { 1065.37,414.49,90.99,136.07 }, text = "O limite de velocidade das auto-estradas é de 120Km/h.", limiteSpeed = 120 },
                    { coords = { 536.55,-321.04,43.52,62.37 }, text = "É proíbido estacionar em áreas cuja uma faixa vermelha está pintada na calçada." },
                    { coords = { 246.9,-221.15,54.02,62.37 }, text = "O limite de velocidade de áreas comerciais é de 80Km/h.", limiteSpeed = 80 },
                    { coords = { -57.29,-103.02,57.79,351.5 }, text = "O limite de velocidade de áreas residenciais é de 60Km/h.", limiteSpeed = 60 },
                    { coords = { -40.29,18.62,72.0,351.5 }, text = "Transitar com veículos danificados é crime!" },
                    { coords = { 30.86,233.74,109.54,351.5 }, text = "Veículos de emergência possuem prioridade, de passagem!" },
                    { coords = { 201.62,358.26,106.39,314.65 }, text = "Você terminou seu teste, estacione na auto-escola para finalizar o percurso." },
                    { coords = { 220.14, 377.39, 106.46 }, text = "Aguarde, o examinador dará o resultado." },
                },
            },
        }
    },
}

ListQuestions = {
    [1] = {
        {            
            pergunta = 'Condutores que possuem habilitação A, podem dirigir quais veículos?',
            a = 'Todos veículo, menos trem.',
            b = 'Avião de caça e carro hatch.',
            c = 'Veículos motorizados com duas/três rodas.',
            d = 'Apenas carro.',
            resposta = 'C'
        },{                     
            pergunta = 'A carteira B, permite que o condutor transite com qual veículo?',
            a = 'Carro',
            b = 'Moto',
            c = 'Caminhão',
            d = 'Ônibus',
            resposta = 'A'
        },{                         
            pergunta = 'Estacionar o veículo na contramão, será punido com ?',
            a = 'Multa de dez mil dólares.',
            b = 'Não será punido, pois é permitido por lei.',
            c = 'Multa e apreensão do veículo.',
            d = 'Apreensão do veículo, multa, condenado a cadeira elétrica.',
            resposta = 'C'
        },{                      
            pergunta = 'Transitar com o veículo em mau estado de conservação e segurança é considerada uma infração, podendo ser punida com ?',
            a = 'Multa',
            b = 'Multa e apreensão do veículo.',
            c = 'Multa e retenção do veículo até ocorrer a regularização.',
            d = 'Cadeia.',
            resposta = 'C'
        },{
            pergunta = 'Em caso de acidente de trânsito com vítima(s), podemos dizer que primeiros socorros são ?',
            a = 'as providências tomadas no local, iniciais e temporárias, até a chegada de socorro',
            b = 'o pronto atendimento da(s) vítima(s) em substituição às equipes da saúde',
            c = 'as ações que só podem ser realizadas por equipes profissionais',
            d = 'procedimentos de competência exclusiva de médicos no local do acidente',
            resposta = 'A'
        },{
            pergunta = 'Caso você esteja sendo ultrapassado por um veículo em uma rodovia, o que você deve fazer?',
            a = 'Acelerar o carro para evitar ser ultrapassado',
            b = 'Abrir a janela e xingar o outro motorista que está indo rápido demais.',
            c = 'Reduzir a velocidade para que o outro veículo consiga ultrapassar com segurança.',
            d = 'Jogar seu carro para cima do outro veículo para bater e jogar ele no acostamento.',
            resposta = 'C'
        },{
            pergunta = 'A distância percorrida pelo veículo do momento em que o condutor tira o pé do acelerador e o coloca sobre o pedal do freio é denominada ?',
            a = 'distância de frenagem',
            b = 'distância de seguimento',
            c = 'distância de reação',
            d = 'distância de parada',
            resposta = 'C'
        },{
            pergunta = 'Quando o motorista estacionar junto de hidrantes de incêndio devidamente identificados, terá como medida administrativa ?',
            a = 'remoção do veículo',
            b = 'recolhimento do CRLV',
            c = 'retenção do veículo',
            d = 'recolhimento da CNH',
            resposta = 'A'
        },{
            pergunta = 'A remoção do veículo pode ocorrer quando o condutor ?',
            a = 'Parar o veículo em um estacionamento',
            b = 'Não pagar seus impostos ou deixar carro estacionado em local impróprio',
            c = 'Dançar em lugar público',
            d = 'Andar com quantidade excessiva de pizzas em seu veículo',
            resposta = 'B'
        },{
            pergunta = 'O condutor que for pego andando de moto sem capacete, será punido com ?',
            a = 'Amor e carinho.',
            b = 'Somente uma multa de cem dólares',
            c = 'Não será punido pois é permitido por lei',
            d = 'Multa, apreensão do veículo.',
            resposta = 'D'
        },{
            pergunta = 'O condutor que for pego promovendo ou participando de competições esportivas na via pública, sem autorização, será punido com',
            a = 'Multa de quatrocentos dólares e pode ficar de 2 a 5 anos preso.',
            b = 'Multa, remoção da sua habilitação, apreensão do veículo.',
            c = 'Uma passagem para o Brasil',
            d = 'Multa e perde direito de utilizar o banco da cidade',
            resposta = 'B'
        },{
            pergunta = 'Caso seu pneu furar, você deve ?',
            a = 'Parar meu carro e chamar um mecânico porque não é possível andar sem pneu.',
            b = 'Andar devagar porque está furado e chamar a polícia',
            c = 'Andar mais rápido possível para evitar capotar',
            d = 'Acelerar máximo possível até perder a roda também',
            resposta = 'A'
        },{
            pergunta = 'Caso você possuir apenas habilitação A e for pego dirigindo um carro, você pode ser punido ?',
            a = 'Multa de 100 doláres, apreensão de veículo e retenção da sua habilitação',
            b = 'Apreendido e encaminhado a delegacia',
            c = 'Multa de 500 dólares e remoção de veículo.',
            d = 'Multa de 100 dólares e 2 anos de prisão',
            resposta = 'A'
        },{
            pergunta = 'O objetivo principal da sinalização de trânsito é ?',
            a = 'Controlar a velocidade dos veículos',
            b = 'Garantir uma via com bom fluxo e segura',
            c = 'Enfeitar a cidade',
            d = 'Proporcionar um ambiente amigável para motoristas',
            resposta = 'B'
        },
    },   
    [2] = {
        {            
            pergunta = 'Condutores que possuem habilitação A, podem dirigir quais veículos?',
            a = 'Todos veículo, menos trem.',
            b = 'Avião de caça e carro hatch.',
            c = 'Veículos motorizados com duas/três rodas.',
            d = 'Apenas carro.',
            resposta = 'C'
        },{                     
            pergunta = 'A carteira B, permite que o condutor transite com qual veículo?',
            a = 'Carro',
            b = 'Moto',
            c = 'Caminhão',
            d = 'Ônibus',
            resposta = 'A'
        },{                         
            pergunta = 'Estacionar o veículo na contramão, será punido com ?',
            a = 'Multa de dez mil dólares.',
            b = 'Não será punido, pois é permitido por lei.',
            c = 'Multa e apreensão do veículo.',
            d = 'Apreensão do veículo, multa, condenado a cadeira elétrica.',
            resposta = 'C'
        },{                      
            pergunta = 'Transitar com o veículo em mau estado de conservação e segurança é considerada uma infração, podendo ser punida com ?',
            a = 'Multa',
            b = 'Multa e apreensão do veículo.',
            c = 'Multa e retenção do veículo até ocorrer a regularização.',
            d = 'Cadeia.',
            resposta = 'C'
        },{
            pergunta = 'Em caso de acidente de trânsito com vítima(s), podemos dizer que primeiros socorros são ?',
            a = 'as providências tomadas no local, iniciais e temporárias, até a chegada de socorro',
            b = 'o pronto atendimento da(s) vítima(s) em substituição às equipes da saúde',
            c = 'as ações que só podem ser realizadas por equipes profissionais',
            d = 'procedimentos de competência exclusiva de médicos no local do acidente',
            resposta = 'A'
        },{
            pergunta = 'Caso você esteja sendo ultrapassado por um veículo em uma rodovia, o que você deve fazer?',
            a = 'Acelerar o carro para evitar ser ultrapassado',
            b = 'Abrir a janela e xingar o outro motorista que está indo rápido demais.',
            c = 'Reduzir a velocidade para que o outro veículo consiga ultrapassar com segurança.',
            d = 'Jogar seu carro para cima do outro veículo para bater e jogar ele no acostamento.',
            resposta = 'C'
        },{
            pergunta = 'A distância percorrida pelo veículo do momento em que o condutor tira o pé do acelerador e o coloca sobre o pedal do freio é denominada ?',
            a = 'distância de frenagem',
            b = 'distância de seguimento',
            c = 'distância de reação',
            d = 'distância de parada',
            resposta = 'C'
        },{
            pergunta = 'Quando o motorista estacionar junto de hidrantes de incêndio devidamente identificados, terá como medida administrativa ?',
            a = 'remoção do veículo',
            b = 'recolhimento do CRLV',
            c = 'retenção do veículo',
            d = 'recolhimento da CNH',
            resposta = 'A'
        },{
            pergunta = 'A remoção do veículo pode ocorrer quando o condutor ?',
            a = 'Parar o veículo em um estacionamento',
            b = 'Não pagar seus impostos ou deixar carro estacionado em local impróprio',
            c = 'Dançar em lugar público',
            d = 'Andar com quantidade excessiva de pizzas em seu veículo',
            resposta = 'B'
        },{
            pergunta = 'O condutor que for pego andando de moto sem capacete, será punido com ?',
            a = 'Amor e carinho.',
            b = 'Somente uma multa de cem dólares',
            c = 'Não será punido pois é permitido por lei',
            d = 'Multa, apreensão do veículo.',
            resposta = 'D'
        },{
            pergunta = 'O condutor que for pego promovendo ou participando de competições esportivas na via pública, sem autorização, será punido com',
            a = 'Multa de quatrocentos dólares e pode ficar de 2 a 5 anos preso.',
            b = 'Multa, remoção da sua habilitação, apreensão do veículo.',
            c = 'Uma passagem para o Brasil',
            d = 'Multa e perde direito de utilizar o banco da cidade',
            resposta = 'B'
        },{
            pergunta = 'Caso seu pneu furar, você deve ?',
            a = 'Parar meu carro e chamar um mecânico porque não é possível andar sem pneu.',
            b = 'Andar devagar porque está furado e chamar a polícia',
            c = 'Andar mais rápido possível para evitar capotar',
            d = 'Acelerar máximo possível até perder a roda também',
            resposta = 'A'
        },{
            pergunta = 'Caso você possuir apenas habilitação A e for pego dirigindo um carro, você pode ser punido ?',
            a = 'Multa de 100 doláres, apreensão de veículo e retenção da sua habilitação',
            b = 'Apreendido e encaminhado a delegacia',
            c = 'Multa de 500 dólares e remoção de veículo.',
            d = 'Multa de 100 dólares e 2 anos de prisão',
            resposta = 'A'
        },{
            pergunta = 'O objetivo principal da sinalização de trânsito é ?',
            a = 'Controlar a velocidade dos veículos',
            b = 'Garantir uma via com bom fluxo e segura',
            c = 'Enfeitar a cidade',
            d = 'Proporcionar um ambiente amigável para motoristas',
            resposta = 'B'
        },
    },  
    [3] = {
        {            
            pergunta = 'Condutores que possuem habilitação A, podem dirigir quais veículos?',
            a = 'Todos veículo, menos trem.',
            b = 'Avião de caça e carro hatch.',
            c = 'Veículos motorizados com duas/três rodas.',
            d = 'Apenas carro.',
            resposta = 'C'
        },{                     
            pergunta = 'A carteira B, permite que o condutor transite com qual veículo?',
            a = 'Carro',
            b = 'Moto',
            c = 'Caminhão',
            d = 'Ônibus',
            resposta = 'A'
        },{                         
            pergunta = 'Estacionar o veículo na contramão, será punido com ?',
            a = 'Multa de dez mil dólares.',
            b = 'Não será punido, pois é permitido por lei.',
            c = 'Multa e apreensão do veículo.',
            d = 'Apreensão do veículo, multa, condenado a cadeira elétrica.',
            resposta = 'C'
        },{                      
            pergunta = 'Transitar com o veículo em mau estado de conservação e segurança é considerada uma infração, podendo ser punida com ?',
            a = 'Multa',
            b = 'Multa e apreensão do veículo.',
            c = 'Multa e retenção do veículo até ocorrer a regularização.',
            d = 'Cadeia.',
            resposta = 'C'
        },{
            pergunta = 'Em caso de acidente de trânsito com vítima(s), podemos dizer que primeiros socorros são ?',
            a = 'as providências tomadas no local, iniciais e temporárias, até a chegada de socorro',
            b = 'o pronto atendimento da(s) vítima(s) em substituição às equipes da saúde',
            c = 'as ações que só podem ser realizadas por equipes profissionais',
            d = 'procedimentos de competência exclusiva de médicos no local do acidente',
            resposta = 'A'
        },{
            pergunta = 'Caso você esteja sendo ultrapassado por um veículo em uma rodovia, o que você deve fazer?',
            a = 'Acelerar o carro para evitar ser ultrapassado',
            b = 'Abrir a janela e xingar o outro motorista que está indo rápido demais.',
            c = 'Reduzir a velocidade para que o outro veículo consiga ultrapassar com segurança.',
            d = 'Jogar seu carro para cima do outro veículo para bater e jogar ele no acostamento.',
            resposta = 'C'
        },{
            pergunta = 'A distância percorrida pelo veículo do momento em que o condutor tira o pé do acelerador e o coloca sobre o pedal do freio é denominada ?',
            a = 'distância de frenagem',
            b = 'distância de seguimento',
            c = 'distância de reação',
            d = 'distância de parada',
            resposta = 'C'
        },{
            pergunta = 'Quando o motorista estacionar junto de hidrantes de incêndio devidamente identificados, terá como medida administrativa ?',
            a = 'remoção do veículo',
            b = 'recolhimento do CRLV',
            c = 'retenção do veículo',
            d = 'recolhimento da CNH',
            resposta = 'A'
        },{
            pergunta = 'A remoção do veículo pode ocorrer quando o condutor ?',
            a = 'Parar o veículo em um estacionamento',
            b = 'Não pagar seus impostos ou deixar carro estacionado em local impróprio',
            c = 'Dançar em lugar público',
            d = 'Andar com quantidade excessiva de pizzas em seu veículo',
            resposta = 'B'
        },{
            pergunta = 'O condutor que for pego andando de moto sem capacete, será punido com ?',
            a = 'Amor e carinho.',
            b = 'Somente uma multa de cem dólares',
            c = 'Não será punido pois é permitido por lei',
            d = 'Multa, apreensão do veículo.',
            resposta = 'D'
        },{
            pergunta = 'O condutor que for pego promovendo ou participando de competições esportivas na via pública, sem autorização, será punido com',
            a = 'Multa de quatrocentos dólares e pode ficar de 2 a 5 anos preso.',
            b = 'Multa, remoção da sua habilitação, apreensão do veículo.',
            c = 'Uma passagem para o Brasil',
            d = 'Multa e perde direito de utilizar o banco da cidade',
            resposta = 'B'
        },{
            pergunta = 'Caso seu pneu furar, você deve ?',
            a = 'Parar meu carro e chamar um mecânico porque não é possível andar sem pneu.',
            b = 'Andar devagar porque está furado e chamar a polícia',
            c = 'Andar mais rápido possível para evitar capotar',
            d = 'Acelerar máximo possível até perder a roda também',
            resposta = 'A'
        },{
            pergunta = 'Caso você possuir apenas habilitação A e for pego dirigindo um carro, você pode ser punido ?',
            a = 'Multa de 100 doláres, apreensão de veículo e retenção da sua habilitação',
            b = 'Apreendido e encaminhado a delegacia',
            c = 'Multa de 500 dólares e remoção de veículo.',
            d = 'Multa de 100 dólares e 2 anos de prisão',
            resposta = 'A'
        },{
            pergunta = 'O objetivo principal da sinalização de trânsito é ?',
            a = 'Controlar a velocidade dos veículos',
            b = 'Garantir uma via com bom fluxo e segura',
            c = 'Enfeitar a cidade',
            d = 'Proporcionar um ambiente amigável para motoristas',
            resposta = 'B'
        },
    },    
    [4] = {
        {            
            pergunta = 'Condutores que possuem habilitação A, podem dirigir quais veículos?',
            a = 'Todos veículo, menos trem.',
            b = 'Avião de caça e carro hatch.',
            c = 'Veículos motorizados com duas/três rodas.',
            d = 'Apenas carro.',
            resposta = 'C'
        },{                     
            pergunta = 'A carteira B, permite que o condutor transite com qual veículo?',
            a = 'Carro',
            b = 'Moto',
            c = 'Caminhão',
            d = 'Ônibus',
            resposta = 'A'
        },{                         
            pergunta = 'Estacionar o veículo na contramão, será punido com ?',
            a = 'Multa de dez mil dólares.',
            b = 'Não será punido, pois é permitido por lei.',
            c = 'Multa e apreensão do veículo.',
            d = 'Apreensão do veículo, multa, condenado a cadeira elétrica.',
            resposta = 'C'
        },{                      
            pergunta = 'Transitar com o veículo em mau estado de conservação e segurança é considerada uma infração, podendo ser punida com ?',
            a = 'Multa',
            b = 'Multa e apreensão do veículo.',
            c = 'Multa e retenção do veículo até ocorrer a regularização.',
            d = 'Cadeia.',
            resposta = 'C'
        },{
            pergunta = 'Em caso de acidente de trânsito com vítima(s), podemos dizer que primeiros socorros são ?',
            a = 'as providências tomadas no local, iniciais e temporárias, até a chegada de socorro',
            b = 'o pronto atendimento da(s) vítima(s) em substituição às equipes da saúde',
            c = 'as ações que só podem ser realizadas por equipes profissionais',
            d = 'procedimentos de competência exclusiva de médicos no local do acidente',
            resposta = 'A'
        },{
            pergunta = 'Caso você esteja sendo ultrapassado por um veículo em uma rodovia, o que você deve fazer?',
            a = 'Acelerar o carro para evitar ser ultrapassado',
            b = 'Abrir a janela e xingar o outro motorista que está indo rápido demais.',
            c = 'Reduzir a velocidade para que o outro veículo consiga ultrapassar com segurança.',
            d = 'Jogar seu carro para cima do outro veículo para bater e jogar ele no acostamento.',
            resposta = 'C'
        },{
            pergunta = 'A distância percorrida pelo veículo do momento em que o condutor tira o pé do acelerador e o coloca sobre o pedal do freio é denominada ?',
            a = 'distância de frenagem',
            b = 'distância de seguimento',
            c = 'distância de reação',
            d = 'distância de parada',
            resposta = 'C'
        },{
            pergunta = 'Quando o motorista estacionar junto de hidrantes de incêndio devidamente identificados, terá como medida administrativa ?',
            a = 'remoção do veículo',
            b = 'recolhimento do CRLV',
            c = 'retenção do veículo',
            d = 'recolhimento da CNH',
            resposta = 'A'
        },{
            pergunta = 'A remoção do veículo pode ocorrer quando o condutor ?',
            a = 'Parar o veículo em um estacionamento',
            b = 'Não pagar seus impostos ou deixar carro estacionado em local impróprio',
            c = 'Dançar em lugar público',
            d = 'Andar com quantidade excessiva de pizzas em seu veículo',
            resposta = 'B'
        },{
            pergunta = 'O condutor que for pego andando de moto sem capacete, será punido com ?',
            a = 'Amor e carinho.',
            b = 'Somente uma multa de cem dólares',
            c = 'Não será punido pois é permitido por lei',
            d = 'Multa, apreensão do veículo.',
            resposta = 'D'
        },{
            pergunta = 'O condutor que for pego promovendo ou participando de competições esportivas na via pública, sem autorização, será punido com',
            a = 'Multa de quatrocentos dólares e pode ficar de 2 a 5 anos preso.',
            b = 'Multa, remoção da sua habilitação, apreensão do veículo.',
            c = 'Uma passagem para o Brasil',
            d = 'Multa e perde direito de utilizar o banco da cidade',
            resposta = 'B'
        },{
            pergunta = 'Caso seu pneu furar, você deve ?',
            a = 'Parar meu carro e chamar um mecânico porque não é possível andar sem pneu.',
            b = 'Andar devagar porque está furado e chamar a polícia',
            c = 'Andar mais rápido possível para evitar capotar',
            d = 'Acelerar máximo possível até perder a roda também',
            resposta = 'A'
        },{
            pergunta = 'Caso você possuir apenas habilitação A e for pego dirigindo um carro, você pode ser punido ?',
            a = 'Multa de 100 doláres, apreensão de veículo e retenção da sua habilitação',
            b = 'Apreendido e encaminhado a delegacia',
            c = 'Multa de 500 dólares e remoção de veículo.',
            d = 'Multa de 100 dólares e 2 anos de prisão',
            resposta = 'A'
        },{
            pergunta = 'O objetivo principal da sinalização de trânsito é ?',
            a = 'Controlar a velocidade dos veículos',
            b = 'Garantir uma via com bom fluxo e segura',
            c = 'Enfeitar a cidade',
            d = 'Proporcionar um ambiente amigável para motoristas',
            resposta = 'B'
        },
    },           
}

function shuffleKeys(tbl, correctAnswer)
    local Questions = {}
    local correctKey = nil  -- Para armazenar a nova chave da resposta correta após embaralhamento

    for key in pairs(tbl) do
        table.insert(Questions, key)
    end
    -- Embaralhar
    for i = #Questions, 2, -1 do
        local j = math.random(i)
        Questions[i], Questions[j] = Questions[j], Questions[i]
    end

    local numbers = 1
    local shuffled = {}
    for Key,Question in pairs(tbl) do
        shuffled[Key] = tbl[Questions[numbers]]
        if Questions[numbers] == correctAnswer then
            correctKey = Key
        end
        numbers = numbers + 1
    end
    return shuffled, correctKey
end

function Questions(index)
    if ListQuestions[tonumber(index)] then
        local allQuestions = ListQuestions[tonumber(index)]
        local selectedQuestions = getRandomQuestions(9, allQuestions)  -- Substituir por sua própria função
        local data = {}
        for index, value in ipairs(selectedQuestions) do
            local shuffledOptions,correctKey = shuffleKeys({
                ["A"] = value["a"],
                ["B"] = value["b"],
                ["C"] = value["c"],
                ["D"] = value["d"],
            }, value["resposta"])
            table.insert(data, {
                ["id"] = index,
                ["pergunta"] =  value["pergunta"],
                ["a"] = shuffledOptions["A"],
                ["b"] = shuffledOptions["B"],
                ["c"] = shuffledOptions["C"],
                ["d"] = shuffledOptions["D"],
                ["resposta"] = correctKey..index
            })
        end
        return data
    end
end

function getRandomQuestions(n, list)
    local randomIndices = {}
    local randomQuestions = {}
    while #randomIndices < n do
        local randIndex = math.random(1, #list)
        if not randomIndices[randIndex] then
            randomIndices[randIndex] = true
            table.insert(randomQuestions, list[randIndex])
        end
    end
    return randomQuestions
end