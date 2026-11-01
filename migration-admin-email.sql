-- Para projetos que já executaram a versão anterior de supabase.sql.
create or replace function public.is_pbn_admin() returns boolean
language sql stable security definer set search_path = '' as $$
  select exists (select 1 from auth.users where id = auth.uid()
    and lower(email) = 'denolk123br@gmail.com' and email_confirmed_at is not null);
$$;
revoke all on function public.is_pbn_admin() from public;
grant execute on function public.is_pbn_admin() to authenticated;
drop policy if exists "Administrador cria propostas" on public.proposals;
drop policy if exists "Administrador altera propostas" on public.proposals;
drop policy if exists "Administrador remove propostas" on public.proposals;
drop policy if exists "Administrador envia imagens" on storage.objects;
create policy "Administrador cria propostas" on public.proposals for insert to authenticated with check (public.is_pbn_admin());
create policy "Administrador altera propostas" on public.proposals for update to authenticated using (public.is_pbn_admin()) with check (public.is_pbn_admin());
create policy "Administrador remove propostas" on public.proposals for delete to authenticated using (public.is_pbn_admin());
create policy "Administrador envia imagens" on storage.objects for insert to authenticated with check (bucket_id = 'proposal-images' and public.is_pbn_admin());
