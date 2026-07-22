// The following code is for initializing Supabase in a Flutter application.
//
//  WidgetsFlutterBinding.ensureInitialized();
//   await Supabase.initialize(
//     url: 'https://........supabase.co',
//     anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.......',
//   );



// The following code is to check the authentication state and navigate accordingly.
//
//      StreamBuilder(
//         stream: Supabase.instance.client.auth.onAuthStateChange,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Scaffold(body: Center(child: CircularProgressIndicator()));
//           }
//           // check if there is a current session
//           final session = Supabase.instance.client.auth.currentSession;
//
//           if (session != null) {
//             // User is signed in
//             return HomePage();
//           } else {
//             // User is not signed in
//             return SignInPage();
//           }
//         },
//       ),



// RLS - Row Level Security
//
// Use the folloing to set policies in tables:
// auth.uid() → user id
// auth.role() → authenticated / anon
// auth.jwt() → metadata like role
// 
// Note: that auth.jwt() can be manipulated by the client, 
// so make sure to use something like users_roles table that stores roles 
// and applies RBAC.
//
// use that in your policies instead of auth.jwt() directly.



// RBAC vs ABAC
// RBAC - Role Based Access Control
// ABAC - Attribute Based Access Control
// 
// Role-Based Access Control (RBAC) assigns permissions to job roles, making it
// simple to manage for stable, structured environments. Attribute-Based Access
// Control (ABAC) uses dynamic attributes (user, resource, context) for fine-grained,
// complex scenarios. RBAC is efficient for basic roles, whereas ABAC excels in
// context-aware security (e.g., time, location).
//
// RBAC (Role-Based):
// - Focus: Who the user is (Role).
// - Pros: Easy to set up, understand, and audit.
// - Cons: "Role explosion" (too many roles), not context-aware.
// - Best For: Simple, stable environments with clear job functions.
//
// ABAC (Attribute-Based):
// - Focus: What properties the user/resource has (Attributes: Role, Location, Time, Project).
// - Pros: Highly flexible, granular, and context-aware (e.g., "Allow access only on weekdays from the office").
// - Cons: High implementation effort, more complex to manage and troubleshoot.
// - Best For: Complex organizations needing dynamic, granular security (e.g., cloud security)




// RBAC - SOP:
//
// 1] Create user_roles table of id linked to auth.uid() and role (admin, teacher, parent....)
//      table SQL code:
//
//       ````````````````````````````````````````
//        create table public.user_roles (
//          id uuid not null,
//          created_at timestamp with time zone not null default now(),
//          role text null,
//          constraint user_roles_pkey primary key (id),
//          constraint user_roles_id_fkey foreign KEY (id) references auth.users (id)
//        ) TABLESPACE pg_default;
//       ````````````````````````````````````````
//
// 2] Make database function (not an edge function) that is called get_my_role 
//    that reads user's role from database table user_roles and not from user's jwt:
//
//       ````````````````````````````````````````
//        create function get_my_role()
//        returns text
//        language sql
//        stable
//        set search_path = public
//        as $$
//          select role
//          from public.user_roles
//          where id = auth.uid()
//        $$;
//       ````````````````````````````````````````
//
// 3] Set RLS policies like following each time you need to check users role:
//
//       ````````````````````````````````````````
//         (get_my_role() = 'admin'::text)
//       ````````````````````````````````````````
//
//    Bouns: instead of writing and checking get_my_role() = 'admin' we can create a function for it:
//       ````````````````````````````````````````   
//        create or replace function public.is_admin()
//        returns boolean
//        language sql
//        stable
//        set search_path = public
//        as $$
//          select public.get_my_role() = 'admin';
//        $$;
//       ````````````````````````````````````````   
//
//
//  For more details and advanced implementation paste the following prompt to ChatGPT:
//
//     `````````````````````````````````````````````````````````````````````````````````````
//
//      I am building an LMS using Supabase and PostgreSQL.
//      Please explain a production-ready RBAC (Role-Based Access Control) architecture designed for Supabase RLS.
//     
//      I want the explanation to include:
//     
//      1. The recommended RBAC database schema including:
//     
//         * roles
//         * permissions
//         * role_permissions
//         * how users connect to roles
//     
//      2. The centralized permission-check function (like `can_access(resource, action)`).
//     
//      3. The “5 reusable RLS policies” concept that replaces dozens of policies:
//     
//         * SELECT
//         * INSERT
//         * UPDATE
//         * DELETE
//         * SELF access
//     
//      4. Example Supabase RLS policies using that function.
//     
//      5. Performance optimization for large systems (~100k users):
//     
//         * the exact indexes needed
//         * why they keep permission checks sub-millisecond
//     
//      6. Best practices specifically for a multi-school LMS SaaS built on Supabase.
//     
//      Explain it simply but in a practical production-ready way with SQL examples.
//
//     `````````````````````````````````````````````````````````````````````````````````````



// Edge Functions - SOP
//
// Defination: serverless TypeScript functions that run globally at the edge, 
// close to users, offering low-latency performance. Powered by Deno (a modern, 
// secure, open-source runtime for JavaScript, TypeScript, and WebAssembly, 
// built on the V8 engine and Rus), they provide a secure, scalable way to 
// execute custom backend logic or connect to third-party APIs (like Stripe).
//
// Core consepts:
// 1] Deno.serve() - main function to handle incoming requests (init server).
// 2] req var - contains request data (headers, body).
// 3] Supabase client - to interact with Supabase services (database, auth, storage). 
//      EX: createClient("","") 
//          auth.admin.createUser()
// 4] Deno.env.get() - to access environment variables (e.g., SUPABASE_URL, SUPABASE_KEY).
// 5] JSON.stringify() - to convert data to JSON format for responses.
// 6] Response() - used to send back data to client (status, headers, body).
//
//
//
// Example: Return the users request as a response
// ```
// Deno.serve(async (req) => {
//   // read JSON body from request
//   const data = await req.json();
//   // return it in response
//   return new Response(
//     JSON.stringify({
//       received_data: data
//     }),
//     {
//       headers: { "Content-Type": "application/json" }
//     }
//   );
// });
// ```
//
//
//
// Example: create a new user using Supabase auth admin API
// ```
// import { serve } from "https://deno.land/std/http/server.ts";
// import { createClient } from "https://esm.sh/@supabase/supabase-js";
//
// serve(async (req) => {
//
//   const request = await req.json();
//
//   const supabase = createClient(
//     Deno.env.get("SUPABASE_URL"),
//     Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"),
//   );
//
//   const {data, error}= await supabase.auth.admin.createUser({
//     email: 'email@gmail.com',
//     password: '123456',
//     email_confirm: true,
//   });
//
//   if (error) {
//     return new Response(
//        JSON.stringify(error.message),
//     { headers: { "Content-Type": "application/json" }}
//     )
//   }
//
//   // const data = await supabase.from('city').select('*');
//
//   return new Response(
//     JSON.stringify(data),
//     { headers: { "Content-Type": "application/json" } }
//   );
// });
//
//
//
// Example: create users in BULK using Supabase auth admin API (1~100 per request)
// Note: this example recuire admin RLS policy 
// ```
// import { serve } from "https://deno.land/std/http/server.ts";
// import { createClient } from "https://esm.sh/@supabase/supabase-js";
//
// serve(async (req) => {
//
//   const { users } = await req.json();
//
//   const supabase = createClient(
//     Deno.env.get("SUPABASE_URL"),
//     Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"),
//   );
//
//   const results = [];
//
//   for (const user of users) {
//
//     const { email, password, name, role, school } = user;
//
//     // create auth user
//     const { data, error } = await supabase.auth.admin.createUser({
//       email: email,
//       password: password,
//       email_confirm: true,
//       app_metadata: {
//         created_via: "edge_function"
//       }
//     });
//
//     if (error) {
//       results.push({
//         email,
//         status: "failed",
//         error: error.message
//       });
//       continue;
//     }
//
//     const userId = data.user.id;
//
//     // insert profile
//     const { error: profileError } = await supabase
//       .from("profile")
//       .insert({
//         id: userId,
//         name: name,
//         email: email,
//         role: role,
//         school: school
//       });
//
//     if (profileError) {
//       results.push({
//         email,
//         status: "profile_failed",
//         error: profileError.message
//       });
//       continue;
//     }
//
//     results.push({
//       email,
//       status: "created",
//       error: null 
//     });
//   }
//
//   return new Response(
//     JSON.stringify(results),
//     { headers: { "Content-Type": "application/json" } }
//   );
//
// });
//
// ```
// REQUEST BODY EXAMPLE: 
// {
//   "users": [
//     {
//       "email": "teacher1@gmail.com",
//       "password": "123456",
//       "name": "Teacher One",
//       "role": "teacher",
//       "school": "School A"
//     },
//     {
//       "email": "student1@gmail.com",
//       "password": "123456",
//       "name": "Student One",
//       "role": "student",
//       "school": "School A"
//     }
//   ]
// }
//
// RESPONSE BODY EXAMPLE:
// [
//   { "email": "teacher1@gmail.com", "status": "created", "error": null },
//   { "email": "student1@gmail.com", "status": "created", "error": null },
//   { "email": "bad@email.com", "status": "failed", "error": "User already registered" }
// ]
//
//
//
// EXAMPLE: call edge function to change user's password
// Note: the following code needs RLS and to be tested
// ```
// import { serve } from "https://deno.land/std/http/server.ts";
// import { createClient } from "https://esm.sh/@supabase/supabase-js";
//
// serve(async (req) => {
//
//   const { email, password } = await req.json();
//
//   const supabase = createClient(
//     Deno.env.get("SUPABASE_URL"),
//     Deno.env.get("SUPABASE_SERVICE_ROLE_KEY"),
//   );
//
//   // find user by email
//   const { data: users, error: findError } = await supabase.auth.admin.listUsers();
//
//   if (findError) {
//     return new Response(
//       JSON.stringify(findError.message),
//       { status: 400 }
//     );
//   }
//
//   const user = users.users.find(u => u.email === email);
//
//   if (!user) {
//     return new Response(
//       JSON.stringify({ error: "User not found" }),
//       { status: 404 }
//     );
//   }
//
//   // update password
//   const { data, error } = await supabase.auth.admin.updateUserById(
//     user.id,
//     { password: password }
//   );
//
//   if (error) {
//     return new Response(
//       JSON.stringify(error.message),
//       { status: 400 }
//     );
//   }
//
//   return new Response(
//     JSON.stringify({ message: "Password updated successfully" }),
//     { headers: { "Content-Type": "application/json" } }
//   );
// });
//
// ```
//
//
// REQUEST BODY EXAMPLE:
// {
//   "email": "user@gmail.com",
//   "password": "newpassword123"
// }
//
// RESPONSE BODY EXAMPLE:
// {
//   "message": "Password updated successfully"
// }