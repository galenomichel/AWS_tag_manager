while true; do
    # 🔄 Resetando variáveis a cada nova iteração
    unset RESOURCE_ARN ENVIRONMENT PROJECT APPLICATION HOSTNAME
    declare -A TAGS_MAP

    read -p "Digite o ARN do recurso (ou 'sair' para encerrar): " RESOURCE_ARN
    if [[ "$RESOURCE_ARN" == "sair" ]]; then
        echo "Saindo do script."
        break
    fi

    echo "🔍 Buscando tags do recurso..."
    TAGS=$(aws resourcegroupstaggingapi get-resources --resource-arn-list "$RESOURCE_ARN" --query 'ResourceTagMappingList[0].Tags' --output table)

    if [[ -z "$TAGS" ]]; then
        echo "⚠️ Nenhuma tag encontrada ou recurso inválido."
    else
        echo "✅ Tags atuais do recurso:"
        echo "$TAGS"
    fi

    read -p "Deseja adicionar ou atualizar tags? (Y/n): " RESP
    RESP=${RESP:-Y}
    if [[ "$RESP" != "Y" && "$RESP" != "y" ]]; then
        continue
    fi

    echo "🌍 Defina o ambiente:"
    ENVIRONMENT=$(select_option)
    TAGS_MAP["Environment"]="$ENVIRONMENT"

    read -p "Digite o valor para a tag 'Project': " PROJECT
    [[ -n "$PROJECT" ]] && TAGS_MAP["Project"]="$PROJECT"

    read -p "Digite o valor para a tag 'Application': " APPLICATION
    [[ -n "$APPLICATION" ]] && TAGS_MAP["Application"]="$APPLICATION"

    # 🛑 Verifica se o recurso é uma instância EC2 antes de perguntar pelo Hostname
    if [[ "$RESOURCE_ARN" == arn:aws:ec2:*:instance/* ]]; then
        read -p "Digite o valor para a tag 'Hostname': " HOSTNAME
        [[ -n "$HOSTNAME" ]] && TAGS_MAP["Hostname"]="$HOSTNAME"
    fi

    if [[ ${#TAGS_MAP[@]} -eq 0 ]]; then
        echo "⚠️ Nenhuma tag foi adicionada. Continuando..."
        continue
    fi

    TAGS_JSON="{"
    for KEY in "${!TAGS_MAP[@]}"; do
        TAGS_JSON+="\"$KEY\":\"${TAGS_MAP[$KEY]}\","
    done
    TAGS_JSON="${TAGS_JSON%,}}"

    echo "🚀 Atualizando tags..."
    aws resourcegroupstaggingapi tag-resources --resource-arn-list "$RESOURCE_ARN" --tags "$TAGS_JSON"

    echo "✅ Tags atualizadas! Novas tags do recurso:"
    aws resourcegroupstaggingapi get-resources --resource-arn-list "$RESOURCE_ARN" --query 'ResourceTagMappingList[0].Tags' --output table

done
