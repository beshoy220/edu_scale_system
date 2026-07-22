// supabase/functions/create-students-parents/index.ts
import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// =========================
// CORS
// =========================
const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

const supabase = createClient(
  Deno.env.get("SUPABASE_URL")!,
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
);

type RequestUser = {
  student_name: string;
  parent_name: string;
  parent_phone: string;
};

type RequestBody = {
  school_id: number;
  grade_id: number;
  class_id: number;
  users: RequestUser[];
};

serve(async (req) => {
  try {
    // =========================
    // Handle CORS preflight
    // =========================
    if (req.method === "OPTIONS") {
      return new Response(null, {
        status: 204,
        headers: corsHeaders,
      });
    }

    // =========================
    // Only allow POST
    // =========================
    if (req.method !== "POST") {
      return response(
        {
          success: false,
          error: "Method not allowed",
        },
        405,
      );
    }

    // =========================
    // Parse body
    // =========================
    const body: RequestBody = await req.json();

    const { school_id, grade_id, class_id, users } = body;

    // =========================
    // Validation
    // =========================
    if (!school_id) {
      return response(
        {
          success: false,
          error: "school_id is required",
        },
        400,
      );
    }

    if (!grade_id) {
      return response(
        {
          success: false,
          error: "grade_id is required",
        },
        400,
      );
    }

    if (!class_id) {
      return response(
        {
          success: false,
          error: "class_id is required",
        },
        400,
      );
    }

    if (!Array.isArray(users) || users.length === 0) {
      return response(
        {
          success: false,
          error: "users must be a non-empty array",
        },
        400,
      );
    }

    for (const user of users) {
      if (
        !user.student_name ||
        !user.parent_name ||
        !user.parent_phone
      ) {
        return response(
          {
            success: false,
            error:
              "Each user must contain student_name, parent_name, parent_phone",
          },
          400,
        );
      }
    }

    // =========================
    // Get school domain
    // =========================
    const { data: school, error: schoolError } = await supabase
      .from("schools")
      .select("school_domain")
      .eq("id", school_id)
      .single();

    if (schoolError || !school) {
      return response(
        {
          success: false,
          error: "School not found",
        },
        400,
      );
    }

    const domain = school.school_domain;

    // =========================
    // Find largest suffix
    // =========================
    const { data: existingUsers, error: existingUsersError } = await supabase
      .from("users")
      .select("email")
      .like("email", `st.%@${domain}`);

    if (existingUsersError) {
      return response(
        {
          success: false,
          error: existingUsersError.message,
        },
        500,
      );
    }

    let maxSuffix = 0;

    for (const user of existingUsers || []) {
      const match = user.email.match(/^st\.(\d{5})@/);

      if (match) {
        const num = parseInt(match[1]);

        if (num > maxSuffix) {
          maxSuffix = num;
        }
      }
    }

    // =========================
    // Create users
    // =========================
    const created: {
      student_email: string;
      parent_email: string;
    }[] = [];

    const createdAuthUserIds: string[] = [];

    for (let i = 0; i < users.length; i++) {
      const current = users[i];

      const nextNumber = maxSuffix + i + 1;

      const paddedNumber = String(nextNumber).padStart(5, "0");

      const studentEmail = `st.${paddedNumber}@${domain}`;
      const parentEmail = `pt.${paddedNumber}@${domain}`;

      const password = current.parent_phone;

      try {
        // =========================
        // Create student auth user
        // =========================
        const {
          data: studentAuth,
          error: studentAuthError,
        } = await supabase.auth.admin.createUser({
          email: studentEmail,
          password,
          email_confirm: true,
          user_metadata: {
            name: current.student_name,
          },
          app_metadata: {
            role: "student",
          },
        });

        if (studentAuthError || !studentAuth.user) {
          throw new Error(
            studentAuthError?.message ||
              "Failed to create student auth user",
          );
        }

        createdAuthUserIds.push(studentAuth.user.id);

        // =========================
        // Create parent auth user
        // =========================
        const {
          data: parentAuth,
          error: parentAuthError,
        } = await supabase.auth.admin.createUser({
          email: parentEmail,
          password,
          email_confirm: true,
          user_metadata: {
            name: current.parent_name,
          },
          app_metadata: {
            role: "parent",
          },
        });

        if (parentAuthError || !parentAuth.user) {
          throw new Error(
            parentAuthError?.message ||
              "Failed to create parent auth user",
          );
        }

        createdAuthUserIds.push(parentAuth.user.id);

        // =========================
        // Insert student
        // =========================

        // create user in users table
        const { error: studentInsertError } = await supabase
          .from("users")
          .insert({
            id: studentAuth.user.id,
            school_id,
            role: "student",
            name: current.student_name,
            email: studentEmail,
            avatar_url: null,
            phone: null,
            status: "pending",
            gender: null,
            birthday: null,
          });

         // create user in user_progress
          const { error: studentInsertError2 } = await supabase
          .from("user_progress")
          .insert({
            user_id: studentAuth.user.id,
          });

        if (studentInsertError || studentInsertError2) {
          throw new Error(studentInsertError.message);
        }

        // =========================
        // Insert parent
        // =========================
        const { error: parentInsertError } = await supabase
          .from("users")
          .insert({
            id: parentAuth.user.id,
            school_id,
            role: "parent",
            name: current.parent_name,
            email: parentEmail,
            phone: current.parent_phone,
            avatar_url: null,
            status: "pending",
            gender: null,
            birthday: null,
          });

        if (parentInsertError) {
          throw new Error(parentInsertError.message);
        }

        // =========================
        // Student profile
        // =========================
        const { error: studentProfileError } = await supabase
          .from("user_profiles")
          .insert({
            user_id: studentAuth.user.id,
            grade_id: grade_id,
            class_id: class_id,
            parent_id: parentAuth.user.id,
          });

        if (studentProfileError) {
          throw new Error(studentProfileError.message);
        }

        // =========================
        // Parent profile
        // =========================
        const { error: parentProfileError } = await supabase
          .from("user_profiles")
          .insert({
            user_id: parentAuth.user.id,
            grade_id: grade_id,
            class_id: class_id,
            student_id: studentAuth.user.id,
          });

        if (parentProfileError) {
          throw new Error(parentProfileError.message);
        }

        created.push({
          student_email: studentEmail,
          parent_email: parentEmail,
        });
      } catch (error) {
        // =========================
        // Rollback auth users
        // =========================
        for (const authUserId of createdAuthUserIds) {
          try {
            await supabase.auth.admin.deleteUser(authUserId);
          } catch (_) {}
        }

        return response(
          {
            success: false,
            error: error instanceof Error
              ? error.message
              : "Unknown error occurred",
          },
          500,
        );
      }
    }

    // =========================
    // Success
    // =========================
    return response(
      {
        success: true,
        created,
      },
      200,
    );
  } catch (error) {
    return response(
      {
        success: false,
        error: error instanceof Error
          ? error.message
          : "Unexpected error",
      },
      500,
    );
  }
});

// =========================
// Helper Response Function
// =========================
function response(data: unknown, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}


// Notes Before Production:
// 1] This function need to add the display name value for the user in auth.users

// Request Body:
//
// {
//   "school_id": 1000,
//   "grade_id": 1068,
//   "class_id": 1078,
//   "users": [
//     {
//       "student_name": "Amar Ahmed",
//       "parent_name": "Ahmed Sayed",
//       "parent_phone": "201239123938"
//     },
//     {
//       "student_name": "Marina Nashed",
//       "parent_name": "Mark Michael",
//       "parent_phone": "201239123938"
//     }
//   ]
// }

