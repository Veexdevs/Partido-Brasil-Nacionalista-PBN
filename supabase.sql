-- Execute no SQL Editor depois de criar seu usuário no Authentication.
-- Substitua o UUID abaixo pelo ID do seu usuário antes de executar.
create sequence public.proposal_number_seq start 7;
create table public.proposals (
  id uuid primary key default gen_random_uuid(),
  number integer not null unique default nextval('public.proposal_number_seq'),
  title text not null, subtitle text not null, theme text not null, type text not null,
  blocks jsonb not null default '[]'::jsonb, created_at timestamptz not null default now()
);
grant usage, select on sequence public.proposal_number_seq to authenticated;
alter table public.proposals enable row level security;
create policy "Propostas públicas" on public.proposals for select to anon, authenticated using (true);
create policy "Administrador cria propostas" on public.proposals for insert to authenticated with check (auth.uid() = 'SUBSTITUA-PELO-UUID-DO-ADMIN'::uuid);
create policy "Administrador altera propostas" on public.proposals for update to authenticated using (auth.uid() = 'SUBSTITUA-PELO-UUID-DO-ADMIN'::uuid) with check (auth.uid() = 'SUBSTITUA-PELO-UUID-DO-ADMIN'::uuid);
create policy "Administrador remove propostas" on public.proposals for delete to authenticated using (auth.uid() = 'SUBSTITUA-PELO-UUID-DO-ADMIN'::uuid);
insert into storage.buckets (id, name, public) values ('proposal-images', 'proposal-images', true);
create policy "Imagens públicas" on storage.objects for select to anon, authenticated using (bucket_id = 'proposal-images');
create policy "Administrador envia imagens" on storage.objects for insert to authenticated with check (bucket_id = 'proposal-images' and auth.uid() = 'SUBSTITUA-PELO-UUID-DO-ADMIN'::uuid);
