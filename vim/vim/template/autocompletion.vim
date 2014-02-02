:%s/<+AUTEUR+>/Michel Barret/ge
:%s/<+DATE+>/\=strftime("%A %d %B %Y")/ge
:%s/<+FILE+>/\=expand('%:t')/ge
let macro = substitute(expand('%:t'), '\.', '_', 'g')
let macro = '__' . toupper(macro) . '__'
:%s/<+MACRO+>/\=expand(macro)/ge

3match Todo /<+.\++>/
