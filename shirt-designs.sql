create policy "Public can view shirt design images"
on storage.objects for select to public
using (bucket_id = 'shirt-designs');

create policy "Admins can upload shirt design images"
on storage.objects for insert to authenticated
with check (
  bucket_id = 'shirt-designs'
  and exists (select 1 from public.admins where user_id = auth.uid())
);

create policy "Admins can delete shirt design images"
on storage.objects for delete to authenticated
using (
  bucket_id = 'shirt-designs'
  and exists (select 1 from public.admins where user_id = auth.uid())
);