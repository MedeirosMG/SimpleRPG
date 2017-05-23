#!/bin/bash
##################################
#-eq   equal to                  #
#-ne   not equal to              #
#-lt   less than                 #
#-le   less than or equal to     #
#-gt   greater than              #
#-ge   greater than or equal to  #
##################################

NIVEL=1
EXP=0
NEXT=10
DUNGEON=1
POTION=1
KILL=0
COMBATE=0
ESCADA=0
SAUDE_ID=0
SAUDE=("saudável" "com arranhões" "com cortes" "com cortes profundos e ematomas" "mal consegue andar")

function _comandos () {
   echo -e "Comandos:\n"
   echo -e "(a)tacar \n(b)eber \n(c)omandos \n(d)escer \n(e)xplorar \n(f)ugir \n(p)ersonagem \n(s)air\n\n"
   
}

function _personagem () {
   clear
   _comandos
   echo -e "Nome: $NOME \nSaude: ${SAUDE[SAUDE_ID]}\nNível: $NIVEL\nExperiência: $EXP/$NEXT\nDungeon: $DUNGEON\nPoções: $POTION\nMatou: $KILL.\n"
}

function _sair () {
   clear
   echo "$NOME se perdeu na dungeon e nunca mais retornou..."
   echo -e "\n\n\n\n\n\n\n\n"
   exit 0
}

function _dado {
   DT=$(( ( RANDOM % 6) + 1 ))
}

function _testa_morte_personagem () {
   if [ $SAUDE_ID -gt 4 ]
      then
         echo "$NOME morreu!!!
         
R.I.P.

Nível: $NIVEL
Dungeon: $DUNGEON
Poções: $POTION
Matou: $KILL"
      exit 0
   fi
}

function _monstro_ataca () {
   _dado
   if [ $DT -lt 5 ]
      then
         echo "$NOME desviou do ataque do monstro!"
   else
      echo "$NOME sofreu o ataque do monstro!"
      SAUDE_ID=$(( $SAUDE_ID + 1 ))
      _testa_morte_personagem
   fi
}

function _testa_evolucao () {
   if [ $EXP -ge $NEXT ]
      then
         NIVEL=$(( $NIVEL + 1 ))
         NEXT=$(( $NEXT + (( 1 + $NIVEL ) * 5) ))
         echo "$NOME se sente mais forte!"
   fi   
}

function _personagem_acerta {
   echo "$NOME atingiu o monstro!"
   _dado
   DIFICULDADE=$(( 3 + $NIVEL - $DUNGEON ))
   if [ $DT -le $DIFICULDADE ] || [ $DT -eq 1 ]
      then
         echo "$NOME matou o monstro!"
         COMBATE=0
         KILL=$(( $KILL + 1 ))
         EXP=$(( $EXP + ( RANDOM % 4) + $DUNGEON ))
         _testa_evolucao
   else
      echo "Porém não foi o necessario para matar o monstro"
      _monstro_ataca
   fi
}

function _atacar () {
   clear
   _comandos
   if [ $COMBATE -eq 0 ]
      then
         echo -e "$NOME desfere um golpe com a espada, cortando o ar!"
   else
      _dado
      if [ $DT -lt 5 ]
         then
            _personagem_acerta
         else
            echo "$NOME errou o ataque!"
            _monstro_ataca   
      fi
   fi
}

function _beber () {
   clear
   _comandos
   if [ $POTION -gt 0 ]
      then
         echo "$NOME bebe uma poção e se sente muito bem!"
         POTION=$(( $POTION - 1 ))
         SAUDE_ID=0
      else
         echo "$NOME procura uma poção na mochila, mas não encontra."
   fi
}

function _explorar () {
   clear
   _comandos
   if [ $COMBATE -eq 0 ]
      then
         _dado
         if [ $DT -gt 4 ]
            then
               echo "$NOME encontrou um monstro!"
               COMBATE=1
         elif [ $DT -lt 2 ]
            then
               if [ $ESCADA -eq 0 ]
                  then
                     echo "$NOME encontrou escadas que levam para o próximo nível da dungeon."
                     ESCADA=1
                  else
                     echo "$NOME encontrou uma poção e guardou na mochila."
                     POTION=$(( $POTION + 1 ))
               fi
         else
            echo "$NOME explora o interior da dungeon..."
         fi      
      else
         echo "$NOME está no meio do combate e não pode explorar agora!"
   fi
}

function _descer () {
   clear
   _comandos
   if [ $ESCADA -eq 1 ]
      then
         echo "$NOME desceu as escadas."
         DUNGEON=$(( $DUNGEON + 1 ))
         ESCADA=0
      else
         echo "$NOME olha em volta, mas não vê por onde descer."
   fi
}

function _fugir () {
   clear
   _comandos
   if [ $COMBATE -eq 1 ]
      then
         _dado
         if [ $DT -lt 3 ]
            then
               echo "$NOME fugiu do monstro como uma garotinha assustada!"
               COMBATE=0
            else
               echo "$NOME procurou uma oportunidade para fugir, mas não encontrou!"
               _monstro_ataca
         fi
      else
         echo "$NOME não tem do que fugir no momento."
   fi
}

function _menu () {
   echo -e "\n"
   read -p "> " OPT
   
   while [[ OPT != f ]]; do
      case $OPT in
         c|comandos) clear
                     _comandos;;
         p|personagem) _personagem;;
         s|sair) _sair;;
         a|ataque|atacar) _atacar;;
         b|beber) _beber;;
         e|explorar) _explorar;;
         d|descer) _descer;;
         f|fugir) _fugir;;
         *) echo "$NOME não entendeu o seu comando. (digite c para ver os comandos)"; _menu;;
      esac
      echo -e "\n"
      read -p "> " OPT
   done
}

function _start () {
   clear
   echo "Bem vindo a uma simples dungeon de RPG, qual o nome do seu personagem?"
   read -p "> " NOME
   clear
   echo -e "$NOME entrou na dungeon, até onde ele conseguira chegar ?\n"
   echo -e "Para avançar na dungeon será preciso muita coragem, explore o local até encontrar a escada para o proximo nível, mas cuidado! Existem monstros andando por ai"
   echo -e "\nDigite um comando para continuar :\n"
   _comandos
   _menu
}
_start
