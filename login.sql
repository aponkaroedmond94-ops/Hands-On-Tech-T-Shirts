insert into public.admins (user_id)
select id from auth.users
where email = 'handsontech@org.com';