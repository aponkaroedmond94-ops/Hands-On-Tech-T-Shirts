create table public.admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);

create table public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text not null default 'Custom Design',
  description text not null default '',
  image_url text not null,
  image_path text not null,
  round_neck_price numeric(10,2) not null default 50,
  lacoste_price numeric(10,2) not null default 60,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table public.admins enable row level security;
alter table public.products enable row level security;

create policy "Admins can view their own admin record"
on public.admins for select to authenticated
using (user_id = auth.uid());

create policy "Anyone can see active designs"
on public.products for select to anon, authenticated
using (is_active = true);

create policy "Admins can see all designs"
on public.products for select to authenticated
using (exists (
  select 1 from public.admins where user_id = auth.uid()
));

create policy "Admins can add designs"
on public.products for insert to authenticated
with check (exists (
  select 1 from public.admins where user_id = auth.uid()
));

create policy "Admins can update designs"
on public.products for update to authenticated
using (exists (
  select 1 from public.admins where user_id = auth.uid()
))
with check (exists (
  select 1 from public.admins where user_id = auth.uid()
));

create policy "Admins can delete designs"
on public.products for delete to authenticated
using (exists (
  select 1 from public.admins where user_id = auth.uid()
));