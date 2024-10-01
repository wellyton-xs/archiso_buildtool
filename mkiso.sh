#!/usr/bin/env bash

######## CABEÇALHO ########
# AUTOR: welly <wellyton.offcer@gmail.com>
# NOME: mkiso.sh
# USO: automatizar o build de uma iso com archiso
# COMO UTILIZAR: você precisa ter uma estrutura de diretórios pré-definida:
#				 diretórios: build, iso, profiles, repo, work
# 				 basta rodar o script especificando o profile que deseja compilar
#				 exemplo: mkiso <profile>

# VARS

profile="./profile"
workdir="./work"
outdir="./iso"

# FUNC

mkiso(){
    mkarchiso -v -w "$workdir" -o "$outdir" "$profile"
}

verify_profile(){
    if [ -z "$profile"  ]; then
	printf '%s\n' "você não pode passar um profile vazio."
	exit 1
    fi
}

verify_dir(){
    if [ -z "$1"  ]; then
	printf '%s\n' "você não pode passar um profile vazio."
	exit 1
    fi
}

verify_root(){
    if [ ! "$(id -u)" == 0  ]; then
	printf '%s\n' "você precisa ser root para executar esse script" 
	exit 1
    fi
}

clean(){
    rm -rf "${workdir:?}"/*
}

verify_and_clean(){
    if [ "$(ls -A $workdir)" ]; then
	printf '%s\n' "diretório não vazio, limpando..."
	clean 
    fi
}

# VERIFICANDO ROOT

verify_root

# VERIFICANDO SE OS DIRETÓRIOS EXISTEM

verify_profile
verify_dir "$workdir"
verify_dir "$outdir"

# VERIFICANDO E LIMPANDO WORK DIR

verify_and_clean

# INICIANDO BUILD

mkiso

# LIMPANDO WORKDIR APÓS O FINAL DO BUILD

printf '%s\n' "limpando workdir"
clean
