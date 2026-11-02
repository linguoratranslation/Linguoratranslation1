-- Jalankan di Supabase → SQL Editor → New query → Run.
create extension if not exists pgcrypto;
create table if not exists public.team_members(
 user_id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null,
 created_at timestamptz not null default now()
);
create table if not exists public.orders(
 id uuid primary key default gen_random_uuid(), created_at timestamptz not null default now(),
 customer_name text not null check(char_length(customer_name) between 2 and 100),
 customer_email text not null check(char_length(customer_email) between 5 and 160),
 customer_phone text not null check(char_length(customer_phone) between 6 and 30),
 direction text not null check(direction in ('English → Indonesian','Indonesian → English')),
 service text not null check(service in ('Academic Translation','General Translation','Proofreading','Legal Translation','Document Translation')),
 page_count integer check(page_count is null or page_count between 1 and 10000), deadline date,
 details text not null check(char_length(details) between 2 and 2000),
 status text not null default 'new' check(status in ('new','reviewing','quoted','in_progress','completed','cancelled'))
);
alter table public.team_members enable row level security;
alter table public.orders enable row level security;
create or replace function public.is_linguora_team() returns boolean language sql security definer set search_path='' stable as $$
 select exists(select 1 from public.team_members where user_id=(select auth.uid()));
$$;
revoke all on function public.is_linguora_team() from public;
grant execute on function public.is_linguora_team() to authenticated;
drop policy if exists "Team read own profile" on public.team_members;
create policy "Team read own profile" on public.team_members for select to authenticated using(user_id=(select auth.uid()));
drop policy if exists "Public submit orders" on public.orders;
create policy "Public submit orders" on public.orders for insert to anon,authenticated with check(status='new');
drop policy if exists "Team view orders" on public.orders;
create policy "Team view orders" on public.orders for select to authenticated using(public.is_linguora_team());
drop policy if exists "Team update orders" on public.orders;
create policy "Team update orders" on public.orders for update to authenticated using(public.is_linguora_team()) with check(public.is_linguora_team());
grant insert on public.orders to anon,authenticated;
grant select,update on public.orders to authenticated;
grant select on public.team_members to authenticated;
-- Tidak ada policy SELECT untuk pengunjung publik. Pesanan pelanggan hanya bisa dibaca admin tim.
