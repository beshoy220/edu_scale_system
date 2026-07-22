# Adding School to EduScale System - SOP

## Steps

1. **Create the School**
   - Add a new school record to the `public.schools` table.

2. **Create the School Admin**
   - Call the **Edge Function (`ID1000`)** to sign up the school admin using the following request body:

   ```json
   {
     "name": "Beshoy Akram",
     "email": "admin2@elsherouk.es",
     "password": "123456"
   }
   ```

3. **Complete School Setup**
   - The admin signs in to the Flutter Admin App.
   - Configure the school's data by populating the following tables:
     - `public.schools`
     - `public.grades`
     - `public.classes`
     - `public.channels`
     - `public.subjects`

4. **Add Users**
   - The admin adds users through the dashboard.