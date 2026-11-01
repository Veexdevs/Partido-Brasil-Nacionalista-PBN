# PBN — Partido Brasil Nacionalista

Site em React/Vite, pronto para publicação na Vercel. As diretrizes iniciais vêm com o site; propostas adicionais são armazenadas no Supabase.

## Desenvolvimento

```bash
npm install
npm run dev
```

## Publicação e painel administrativo

1. Crie ou escolha um projeto Supabase dedicado ao site. No Authentication, crie o usuário administrador e copie seu UUID. Desative o cadastro público se não for necessário.
2. No SQL Editor, execute `supabase.sql`, substituindo **todas** as ocorrências de `SUBSTITUA-PELO-UUID-DO-ADMIN` pelo UUID do administrador. As políticas permitem leitura pública, mas apenas esse usuário pode publicar ou alterar propostas e enviar imagens.
3. Configure `VITE_SUPABASE_URL` e `VITE_SUPABASE_ANON_KEY` com a URL e a chave pública (anon/publishable) do projeto, tanto em `.env.local` para desenvolvimento quanto nas variáveis de ambiente da Vercel. Nunca coloque a chave `service_role` no site.
4. Importe o repositório na Vercel e faça o deploy. O framework Vite é detectado automaticamente; o arquivo `vercel.json` garante que os links internos funcionem ao atualizar a página.
5. Acesse `/admin` e entre com o usuário criado. É possível publicar, editar e excluir propostas, adicionar blocos de texto, títulos e imagens, reorganizá-los e enviar imagens ao Storage ou usar URLs públicas.

Sem essa configuração, o site e as diretrizes iniciais continuam visíveis, mas o painel e as propostas adicionais não estarão disponíveis. As diretrizes iniciais são definidas em `src/main.jsx`; apenas as propostas criadas no painel são editáveis por ele. Excluir uma proposta não exclui automaticamente imagens já enviadas ao Storage.

As propostas são numeradas automaticamente e mantêm seu número mesmo se outra for excluída. A pesquisa considera título, subtítulo, tema, tipo e texto, sem diferenciar acentos. Se você já havia criado a tabela antes desta atualização, execute `migration-number.sql` uma vez para adicionar a numeração antes de publicar esta versão.
