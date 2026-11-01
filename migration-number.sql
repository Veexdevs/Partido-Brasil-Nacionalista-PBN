-- Para instalações já existentes, execute uma vez no SQL Editor do Supabase.
-- As seis primeiras posições são reservadas às diretrizes iniciais do site.
create sequence public.proposal_number_seq start 7;
alter table public.proposals add column number integer;
with numbered as (
  select id, row_number() over (order by created_at, id) + 6 as n from public.proposals
)
update public.proposals p set number = numbered.n from numbered where p.id = numbered.id;
select setval('public.proposal_number_seq', greatest(coalesce((select max(number) from public.proposals), 6), 6) + 1, false);
alter table public.proposals alter column number set default nextval('public.proposal_number_seq');
alter table public.proposals alter column number set not null;
alter table public.proposals add constraint proposals_number_key unique (number);
grant usage, select on sequence public.proposal_number_seq to authenticated;
