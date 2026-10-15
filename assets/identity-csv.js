/* GG Identity Security Auditor — CSV parsing and validation. No dependencies. */
(function(root,factory){const api=factory();if(typeof module==='object'&&module.exports)module.exports=api;root.IdentityCsv=api})(typeof globalThis!=='undefined'?globalThis:this,function(){
'use strict';
const required=['user','enabled','lastlogondays','isadmin'];
const booleanFields=['enabled','isadmin','passwordneverexpires','passwordnotrequired','lockedout'];
function parse(text){
 if(typeof text!=='string'||!text.trim())throw Error('O arquivo CSV está vazio.');
 if(text.length>8*1024*1024)throw Error('CSV maior que 8 MB. Divida a coleta em arquivos menores.');
 const first=text.replace(/^\uFEFF/,'').split(/\r?\n/,1)[0];const delimiter=(first.match(/;/g)||[]).length>(first.match(/,/g)||[]).length?';':',';\n const rows=[];let row=[],cell='',quoted=false;
 text=text.replace(/^\uFEFF/,'');
 for(let i=0;i<text.length;i++){const c=text[i];
  if(quoted){if(c==='"'&&text[i+1]==='"'){cell+='"';i++}else if(c==='"'){quoted=false}else cell+=c}
  else if(c==='"'){if(cell==='')quoted=true;else throw Error('Aspas inesperadas no CSV, caractere '+(i+1)+'.')}
  else if(c===','||c===';'){ if(c===delimiter){row.push(cell);cell=''}else cell+=c}
  else if(c==='\n'||c==='\r'){if(c==='\r'&&text[i+1]==='\n')i++;row.push(cell);if(row.some(x=>x!==''))rows.push(row);row=[];cell=''}
  else cell+=c;
 }
 if(quoted)throw Error('CSV incompleto: aspas não foram fechadas.');
 row.push(cell);if(row.some(x=>x!==''))rows.push(row);
 if(rows.length<2)throw Error('CSV sem cabeçalho ou sem registros.');
 const head=rows.shift().map(v=>v.trim().toLowerCase());
 if(new Set(head).size!==head.length)throw Error('Existem colunas duplicadas no CSV.');
 for(const c of required)if(!head.includes(c))throw Error('Coluna obrigatória ausente: '+c);
 if(rows.length>20000)throw Error('Limite de 20.000 contas por arquivo excedido.');
 return rows.map((cells,i)=>{if(cells.length!==head.length)throw Error('Linha '+(i+2)+': esperado '+head.length+' campos, recebido '+cells.length+'.');
  const result=Object.fromEntries(head.map((name,k)=>[name,cells[k].trim()]));
  if(!result.user)throw Error('Linha '+(i+2)+': User vazio.');
  for(const k of booleanFields)if(result[k]!==undefined&&result[k]!==''&&!['true','false'].includes(result[k].toLowerCase()))throw Error('Linha '+(i+2)+': '+k+' deve ser True, False ou vazio.');
  for(const k of ['lastlogondays','passwordagedays'])if(result[k]!==undefined&&result[k]!==''&&(!/^\d+$/.test(result[k])||!Number.isSafeInteger(Number(result[k]))))throw Error('Linha '+(i+2)+': '+k+' inválido.');
  return result;
 });
}
return {parse};
});
