# PBN — Partido Brasil Nacionalista

Site React/Vite para a Vercel, com propostas, jornal e painel administrativo. As diretrizes iniciais são exibidas sem banco; publicações adicionais dependem do Supabase.

## Rodar localmente

```bash
npm install
npm run dev
npm run build
```

## Configurar o painel

1. Crie ou selecione um projeto Supabase **dedicado ao PBN**. Ative autenticação por e-mail e confirmação de e-mail. O único endereço com permissão de escrita é `denolk123br@gmail.com`; a política no banco exige uma conta autenticada com esse endereço confirmado, não apenas um e-mail digitado no site.
2. Execute `supabase.sql` no SQL Editor para uma instalação nova. Caso já tenha instalado a versão anterior, execute `migration-number.sql` se ainda não tiver a coluna `number` e depois `migration-admin-email.sql`.
3. Em Authentication → URL Configuration, configure a Site URL como `https://partido-brasil-nacionalista.vercel.app` e adicione `https://partido-brasil-nacionalista.vercel.app/admin` às Redirect URLs. Adicione também sua URL de desenvolvimento se necessário. O Supabase precisa estar configurado para enviar e-mails; para produção, configure SMTP apropriado e revise limites de envio.
4. Configure `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY` com a URL e a chave pública (anon/publishable) em `.env.local` e nas variáveis de ambiente da Vercel. Nunca use a chave `service_role` no navegador. Faça um novo deploy após configurar as variáveis.
5. Acesse `/admin`, solicite o link e confirme no e-mail. O proprietário pode criar, editar e excluir publicações; use o tipo **Notícia** para publicá-las no Jornal. Os blocos de texto, títulos, imagens e banners podem ser reordenados. As seis diretrizes iniciais estão no código e não são editáveis no painel.

As políticas de segurança do banco são essenciais: a verificação de e-mail no navegador não substitui autorização no servidor. Sem as variáveis e o banco configurados, o painel não funciona. Excluir publicações não remove automaticamente imagens do Storage. A busca ignora acentos e pesquisa título, subtítulo, tema, tipo e conteúdo. Os números das publicações são permanentes.

A Vercel detecta o Vite e `vercel.json` garante que os caminhos internos funcionem ao atualizar a página. A imagem de compartilhamento é configurada no `index.html` (Open Graph).
