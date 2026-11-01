-- Instalação inicial em um projeto Supabase dedicado ao PBN.
-- O usuário administrador deve confirmar o endereço por e-mail no Supabase Auth.
create sequence public.proposal_number_seq start 7;
create table public.proposals (
  id uuid primary key default gen_random_uuid(),
  number integer not null unique default nextval('public.proposal_number_seq'),
  title text not null, subtitle text not null, theme text not null, type text not null,
  blocks jsonb not null default '[]'::jsonb, created_at timestamptz not null default now()
);
grant usage, select on sequence public.proposal_number_seq to authenticated;
alter table public.proposals enable row level security;
-- JWT é assinado pelo Supabase; conferir também a confirmação real no auth.users.
create function public.is_pbn_admin() returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (select 1 from auth.users where id = auth.uid()
    and lower(email) = 'denolk123br@gmail.com' and email_confirmed_at is not null);
$$;
revoke all on function public.is_pbn_admin() from public;
grant execute on function public.is_pbn_admin() to authenticated;
create policy "Propostas públicas" on public.proposals for select to anon, authenticated using (true);
create policy "Administrador cria propostas" on public.proposals for insert to authenticated with check (public.is_pbn_admin());
create policy "Administrador altera propostas" on public.proposals for update to authenticated using (public.is_pbn_admin()) with check (public.is_pbn_admin());
create policy "Administrador remove propostas" on public.proposals for delete to authenticated using (public.is_pbn_admin());
insert into storage.buckets (id, name, public) values ('proposal-images', 'proposal-images', true);
create policy "Imagens públicas" on storage.objects for select to anon, authenticated using (bucket_id = 'proposal-images');
create policy "Administrador envia imagens" on storage.objects for insert to authenticated with check (bucket_id = 'proposal-images' and public.is_pbn_admin());
