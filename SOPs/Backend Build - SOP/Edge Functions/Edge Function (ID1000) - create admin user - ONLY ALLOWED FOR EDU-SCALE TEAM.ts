// supabase/functions/createAdminUser/index.ts
import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// Helper to send JSON responses
function jsonResponse(data: any, status: number = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { "Content-Type": "application/json" },
  });
}

serve(async (req: Request) => {
  try {
    // 1. Parse request body
    const { email, password, name } = await req.json();

    // 2. Validate required fields
    if (!email || !password || !name ) {
      return jsonResponse(
        { error: "Missing required fields: email, password, name" },
        400
      );
    }

    // 3. Extract domain from email
    const domain = email.split("@")[1];
    if (!domain) {
      return jsonResponse({ error: "Invalid email format" }, 400);
    }

    // 4. Create Supabase admin client (bypasses RLS)
    const supabaseAdmin = createClient(
      Deno.env.get("SUPABASE_URL") ?? "",
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
      { auth: { autoRefreshToken: false, persistSession: false } }
    );

    // 5. Find school ID by domain
const { data: schools, error: schoolError } = await supabaseAdmin
  .from("schools")
  .select("id")
  .eq("school_domain", domain);

if (schoolError) {
  return jsonResponse({ error: schoolError.message }, 500);
}

if (!schools || schools.length === 0) {
  return jsonResponse(
    { error: `School with school_domain '${domain}' not found` },
    404
  );
}

const school_id = schools[0].id;

    // 6. Create user in auth.users (admin role)
    const { data: authUser, error: authError } = await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
      app_metadata: { role: "admin" },
      user_metadata: { name },
    });

    if (authError) throw authError;

    // 7. Insert into public.users table
    const { error: insertError } = await supabaseAdmin.from("users").insert({
      id: authUser.user.id,
      school_id,
      role: "admin",
      name,
      email,
      status: "active",
      created_at: new Date().toISOString(),
    });

    if (insertError) throw insertError;

    // 8. Success response
    return jsonResponse({
      message: "Admin user created successfully",
      user: {
        id: authUser.user.id,
        email,
        name,
        role: "admin",
        school_id,
      },
    });
  } catch (err) {
    return jsonResponse({ error: err.message }, 500);
  }
});

// Notes Before Production:
// 1] this function does not has cors setup and not ment to be called from flutter side
// 2] even if we added this function for flutter side we will add it only for edu scale team GUI app

// Request body:
//
// {
//   "email": "admin@school-domain.com",
//   "password": "securePassword123",
//   "name": "Admin Full Name"
// }