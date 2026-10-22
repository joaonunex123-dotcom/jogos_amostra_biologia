-- Banco do Solo Limpo: ranking compartilhado e respostas do questionário.
-- Rode uma vez no SQL Editor do Supabase.

create table if not exists public.ranking (
  id uuid primary key default gen_random_uuid(),
  jogo text not null check (jogo in ('descarte', 'plataforma', 'fito')),
  nome text not null check (nome ~ '^[A-Z]{3}$'),
  pontos integer not null check (pontos between 0 and 200000),
  dispositivo text not null check (dispositivo in ('pc', 'celular')),
  criado_em timestamptz not null default now()
);
create index if not exists ranking_jogo_pontos on public.ranking (jogo, pontos desc);

create table if not exists public.respostas (
  id uuid primary key default gen_random_uuid(),
  jogo text check (jogo in ('descarte', 'plataforma', 'fito')),
  dispositivo text check (dispositivo in ('pc', 'celular')),
  idade text,
  conhece text,
  causa text,
  descarte text,
  preocupacao smallint check (preocupacao between 1 and 5),
  criado_em timestamptz not null default now()
);

alter table public.ranking enable row level security;
alter table public.respostas enable row level security;

-- Qualquer visitante lê e grava no ranking.
create policy "ranking leitura" on public.ranking for select to anon, authenticated using (true);
create policy "ranking gravacao" on public.ranking for insert to anon, authenticated with check (true);

-- Visitantes só gravam respostas; ninguém de fora consegue ler.
create policy "respostas gravacao" on public.respostas for insert to anon, authenticated with check (true);

grant select, insert on public.ranking to anon, authenticated;
grant insert on public.respostas to anon, authenticated;
