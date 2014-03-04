﻿local L = LibStub("AceLocale-3.0"):NewLocale("EnsidiaFails", "ptBR")
if not L then return end

L["addon_desc"] = "EnsidiaFails é um addon que reporta se um jogador na raide falhar em evitar uma habilidade durante um encontro, que poderia ter sido evitado"
L["admiral"] = "Almirante das FALHAS é:"
L["after"] = "Depois do combate"
L["Amount of entries to display"] = "Quantidade de entradas para mostrar"
L["announce"] = "Anunciar para"
L["announce_after_style"] = "Estilo de \"anúnciar depois\""
L["announce_after_style_desc"] = "Como o relatório deve parecer depois do combate"
L["announce_desc"] = "Configure onde postar os anúncios"
L["announce_style"] = "Estilo do anuncio"
L["announce_style_desc"] = "Quando relatar falhas"
L["Announcing Disabled! %s is the main announcer. (He/She has the same version as you (%s))"] = "Anúncios desabilitados! %s é o principal anunciante. (Ele/Ela tem a mesma versão que você (%s))"
L["Announcing Disabled! %s is the main announcer. (Please consider updating your addon his/her version was %s)(yours: %s)"] = "Anúncios desabilitados! %s é o anunciante principal. (Por favor, atualize seu addon a versão do addon dele/dela é %s)(A sua: %s)"
L["Announcing Enabled! YOU are the main announcer for EnsidiaFails, please check your announcing settings"] = "Anúncios habilitados! VOCÊ é o anunciante principal para o EnsidiaFails, por favor verifique suas configurações de anúncios"
L["At how many stacks are you supposed to stop dps"] = "A quantas pilhas você deve parar o dps"
L["Auto Delete New Instance"] = "Auto deletar nova instância"
L["being at the wrong place"] = "estar no lugar errado"
L["captain"] = "O Jogador que mais FALHOU:"
L["casting"] = "conjurando"
L["Channel"] = "Canal"
L["Confirm Delete Instance"] = "Confirmar Exclusão da Instância"
L["Confirm Delete on Raid Join"] = "Confirmar exclusão ao entrar em raide"
L["Deep Breath"] = "Sopro Flamejante"
L["Delete New Instance Only"] = "Apagar Novas Instâncias Apenas"
L["Delete on Raid Join"] = "Apagar ao Entrar em Raide"
L["didnt_fail"] = "Jogadores que não falharam:"
L["diff..."] = " jogadores diferentes! Exibindo o TOP"
L["diff%..."] = " jogadores diferentes! Mostrando o TOP %s..."
L["Disable announce override"] = "Desabilitar substituição de anuncio"
L["Disabled"] = "Desativado"
L["Disallows accepting commands from other users that'd change the announcing settings"] = "Não permitir aceitações de comandos de outros usuários que mudaram as configurações de anuncios"
L["dispelling"] = "dissipando"
L["during"] = "Durante o combate"
L["during_and_after"] = "Durante e após o combate"
L["failed"] = " falhou"
L["fails_at"] = " falhou em"
L["fails_on"] = " FALHA em"
L["filter"] = "Filtro"
L["filter_desc"] = "Marque as falhas que deseja rastrear! Se uma falha não está marcada próximo ao nome, a falha não será rastreada ou anunciada!"
L["Frost Bomb"] = "Bomba de Gelo"
L["general"] = "Geral"
L["Group by fails"] = "Agrupar por falhas"
L["Group by player"] = "Agrupar por jogadores"
L["Guild"] = "Guilda"
L["How close combatlog events have to be, when determining who failed"] = "Quão perto os eventos do combatlog tem de ser, quando determinando quem falhou"
L["How many stack is still not a fail"] = "Quantas pilhas ainda não são uma falha."
L["How much damage taken needed for a fail from "] = "Quanto dano recebido precisa para ser uma falha de"
L["How much healing taken is still not a fail"] = "Quanta cura recebida ainda não é um falha"
L["How much time do you have for moving before adding a fail for "] = "Quanto tempo você tem para se mover antes de adicionar uma falha de"
L["jumping"] = "pulando"
L["left and right"] = "esquerda e direita"
L["LocalDefense"] = "DefesaLocal"
L["Marked Immortal Guardian"] = "Guardião imortal marcado"
L["moving"] = "movendo"
L["No"] = "Não"
L["nobody_failed"] = "EnsidiaFails - Ninguém Falhou!"
L["noexceptions"] = "Sem exceções"
L["noexceptions_desc"] = "Sem excessões, toda falha é uma falha!"
L["not_casting"] = "não conjurando"
L["not_dispelling"] = "não dissipando"
L["not moving"] = "não movendo"
L["not spreading"] = "não espalhando"
L["Officer"] = "Oficial"
L["Only report overkills"] = "Reportar somente overkills"
L["Only report overkills in LFR"] = "Reportar somente overkills no LDR"
L["oreset"] = "Redefinir Geral"
L["oreset_desc"] = "Redefinir contador geral de falhas"
L["oreseted"] = "Contador de falhas gerais reiniciado."
L["ostats"] = "Estatísticas Globais"
L["ostats_desc"] = "Relatório Estatísticas Gerais"
L["Party"] = "Grupo"
L["Proximity Mine"] = "Minas de Proximidade"
L["Raid"] = "Raide"
L["remove"] = "Remover uma Falha"
L["removed"] = "Falha removida de"
L["remove_desc"] = "Remover uma falha de um jogador"
L["reset"] = "Reiniciar"
L["Reset Data?"] = "Redefinir Dados?"
L["reset_desc"] = "Reiniciar o contador de falhas"
L["reseted"] = "Contador de falhas reinciado."
L["Reset EnsidiaFails?"] = "Redefinir EnsidiaFails?"
L["reset on combat"] = "Reiniciar a cada combate"
L["resume"] = "Relatório resumido de falhas."
L["Say"] = "Dizer"
L["Self"] = "Eu"
L["sensitive"] = "sensitivo"
L["shaman_healing"] = "Xamã curando"
L["Show all"] = "Mostrar tudo"
L["Snaplasher"] = "Snaplasher"
L["spreading"] = "espalhando"
L["stats"] = "Estatísticas"
L["stats_desc"] = "Relatar Estatísticas"
L["susped"] = "Relatório de falhas suspenso por 60 segundos."
L["Talent based Exception"] = "Excessão baseada nos talentos"
L["The Halls of Winter"] = "Salões de inverno"
L["The Prison of Yogg-Saron"] = "A Prisão de Yogg-Saron"
L["Top X Stats"] = "Top Estatísticas X"
L["Trade"] = "Comércio"
L["turning away"] = "afastando-se"
L["Use talent scanning for determining tanks"] = "Usar escaneamento de talentos para determinar os tanquers"
L["we_have"] = "EnsidiaFails - Temos"
L["Wrong name!"] = "Nome errado!"
L["Yes"] = "Sim"