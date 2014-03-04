﻿local L = LibStub("AceLocale-3.0"):NewLocale("EnsidiaFails", "itIT")
if not L then return end

L["addon_desc"] = [=[EnsidiaFails e' un addon che permette di identificare quali giocatori sbagliano durante un combattimento in incursione subendo danni da magie che possono essere evitate.
]=]
L["admiral"] = "L'ammiraglio della Flotta dei Fail e' : "
L["after"] = "Dopo il Combattimento"
L["Amount of entries to display"] = "N. di player da visualizzare."
L["announce"] = "Annuncia su"
L["announce_after_style"] = "Annuncia raggruppati per"
L["announce_after_style_desc"] = "Scegli come raggruppare gli Errori dopo il Combattimento."
L["announce_desc"] = "Dove annunciare gli Errori" -- Needs review
L["announce_style"] = "Stile degli annunci"
L["announce_style_desc"] = "Quando verranno annunciati in chat gli errori dell'incursione."
L["Announcing Disabled! %s is the main announcer. (He/She has the same version as you (%s))"] = "Annunci Disabilitati! %s e' il Gestore di EnsidiaFails per l'incursione (Ha la tua stessa versione (%s))."
L["Announcing Disabled! %s is the main announcer. (Please consider updating your addon his/her version was %s)(yours: %s)"] = "Annunci Disabilitati! %s e' il Gestore di EnsidiaFails per l'incursione (Aggiorna il tuo addon; la sua versione e' %s) (la tua: %s)"
L["Announcing Enabled! YOU are the main announcer for EnsidiaFails, please check your announcing settings"] = "Annunci Attivi! Sei il Gestore di EnsidiaFails per l'incursione, controlla le impostazioni degli Annunci."
L["At how many stacks are you supposed to stop dps"] = "A quante stack dovresti stoppare il DPS."
L["Auto Delete New Instance"] = "Cancella i dati Automaticamente in una nuova istanza."
L["being at the wrong place"] = "sta nel posto sbagliato"
L["captain"] = "Il Capitano della Nave degli Errori e' :" -- Needs review
L["casting"] = "sta lanciando"
L["Channel"] = "Canale" -- Needs review
L["Confirm Delete Instance"] = "Conferma la cancellazione "
L["Confirm Delete on Raid Join"] = "Conferma la cancellazione"
L["Deep Breath"] = "Soffio Profondo"
L["Delete New Instance Only"] = "Cancella Dati in Nuove Istanze"
L["Delete on Raid Join"] = "Cancella Dati in nuovi Raid"
L["didnt_fail"] = "Non hanno sbagliato : "
L["diff..."] = " Giocatori Diversi! Visualizzo la TOP 10..."
L["diff%..."] = "Giocatori Diversi! Visualizzo la TOP %s..."
L["Disable announce override"] = "Disabilita Override"
L["Disabled"] = "Disattivato"
L["Disallows accepting commands from other users that'd change the announcing settings"] = "Non accettare comandi da altri giocatori che cambierebbero le impostazioni degli annunci."
L["dispelling"] = "dispella"
L["during"] = "Durante il Combattimento"
L["during_and_after"] = "Durante e Dopo il Combattimento"
L["failed"] = " ha sbagliato"
L["fails_at"] = " ha sbagliato su "
L["fails_on"] = " ERRORE su "
L["filter"] = "Filtri"
L["filter_desc"] = "Spunta gli Errori che vuoi tracciare! Se un errore non ha la spunta vicino al proprio nome, l'errore non verra' tracciato e nemmeno riportato!"
L["Frost Bomb"] = "Bomba di Ghiaccio"
L["general"] = "Generale"
L["Group by fails"] = "Raggruppa per Errori"
L["Group by player"] = "Raggruppa per Giocatori"
L["Guild"] = "Gilda" -- Needs review
L["How close combatlog events have to be, when determining who failed"] = "Quanto devono essere vicini gli eventi del CombatLog, quando si determina chi sbaglia"
L["How many stack is still not a fail"] = "Quante stack non sono ancora un Errore"
L["How much damage taken needed for a fail from "] = "Quanto danno si deve prendere perchè ci sia un Errore di "
L["How much healing taken is still not a fail"] = "Quante Cure ricevute non sono ancora un errore "
L["How much time do you have for moving before adding a fail for "] = "Quanto tempo hai per scappare prima che venga considerato Errore"
L["jumping"] = "saltando"
L["left and right"] = "Sinistra e Destra"
L["LocalDefense"] = "Difesa Locale"
L["Marked Immortal Guardian"] = "Guardiano Immortale Markato"
L["moving"] = "Spostandosi"
L["No"] = "No"
L["nobody_failed"] = "EnsidiaFails - Nessuno ha fatto Errori!"
L["noexceptions"] = "Nessun Eccezione"
L["noexceptions_desc"] = "Nessun Eccezione, un errore e' un Errore!"
L["not_casting"] = "Non stava castando"
L["not_dispelling"] = "Non stava dispellando"
L["not moving"] = "Non si muove"
L["not spreading"] = "Non si sono allargati"
L["Officer"] = "Ufficiali"
L["Only report overkills"] = "Annuncia solo le OverKill"
L["Only report overkills in LFR"] = "OverKill solo in LFR"
L["oreset"] = "Cancella i Dati"
L["oreset_desc"] = "Cancella tutti gli Errori Memorizzati."
L["oreseted"] = "Tutti gli Errori sono stati cancellati."
L["ostats"] = "Statistiche Globali"
L["ostats_desc"] = "Annuncia le Statistiche Globali"
L["Party"] = "Gruppo" -- Needs review
L["Proximity Mine"] = "Mina di prossimita'"
L["Raid"] = "Incursione" -- Needs review
L["remove"] = "Cancella un errore"
L["removed"] = "Un errore e' stato cancellato a "
L["remove_desc"] = "Rimuovi un errore ad un giocatore."
L["reset"] = "Reinizializzazione"
L["Reset Data?"] = "Vuoi davvero cancellare i dati?"
L["reset_desc"] = "Reinizializza i conteggi degli Errori."
L["reseted"] = "Archivio degli Errori Cancellato."
L["Reset EnsidiaFails?"] = "Resettare EnsidiaFails ?"
L["reset on combat"] = "Reinizializza al pull"
L["resume"] = "Riprendi le segnalazioni di errore."
L["Say"] = "Parla"
L["Self"] = "Me stesso"
L["sensitive"] = "Sensibile"
L["shaman_healing"] = "Cure dello Shamano"
L["Show all"] = "Visualizza Tutto"
L["Snaplasher"] = "Flagellant mordant"
L["spreading"] = "Allontanarsi"
L["stats"] = "Statistiche"
L["stats_desc"] = "Annuncia Statistiche"
L["susped"] = "Sospensione dell'annuncio degli errori."
L["Talent based Exception"] = "Eccezione sulla base dei Talenti"
L["The Halls of Winter"] = "Le camere dell'Inverno"
L["The Prison of Yogg-Saron"] = "La prigione di Yogg-Saron"
L["Top X Stats"] = "Prime X Statistiche"
L["Trade"] = "Commercio"
L["turning away"] = "Scappare via"
L["Use talent scanning for determining tanks"] = "Utilizza la scansione dei talenti per i Difensori."
L["we_have"] = "EnsidiaFails - Abbiamo"
L["Wrong name!"] = "Nome Sbagliato !"
L["Yes"] = "Si"