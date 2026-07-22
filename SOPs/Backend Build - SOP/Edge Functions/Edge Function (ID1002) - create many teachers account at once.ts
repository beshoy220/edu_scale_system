// supabase/functions/create-teachers/index.ts

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

// ======================================================
// ENV VARIABLES
// ======================================================

const SUPABASE_URL = Deno.env.get("SUPABASE_URL")!;
const SUPABASE_SERVICE_ROLE_KEY =
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

// ======================================================
// SUPABASE CLIENT
// ======================================================

const supabase = createClient(
  SUPABASE_URL,
  SUPABASE_SERVICE_ROLE_KEY,
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  },
);

// ======================================================
// CORS
// ======================================================

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

// ======================================================
// TYPES
// ======================================================

interface TeacherInput {
  teacher_name: string;
  teacher_phone: string;
}

interface RequestBody {
  school_id: number;
  subject_id: number;
  subject_name: string;
  users: TeacherInput[];
}

// ======================================================
// HELPERS
// ======================================================

/**
 * Extract numeric suffix from teacher email
 * Example:
 * tc.00017@futureacademy.es => 17
 */
function extractTeacherNumber(email: string): number {
  const match = email.match(/^tc\.(\d{5})@/);

  if (!match) return 0;

  return parseInt(match[1], 10);
}

/**
 * Generate teacher email
 * Example:
 * tc.00001@futureacademy.es
 */
function generateTeacherEmail(
  number: number,
  schoolDomain: string,
): string {
  const padded = number.toString().padStart(5, "0");

  return `tc.${padded}@${schoolDomain}`;
}

/**
 * Get latest teacher number
 */
async function getLatestTeacherNumber(
  schoolDomain: string,
): Promise<number> {
  let page = 1;
  const perPage = 1000;

  let maxNumber = 0;

  while (true) {
    const { data, error } =
      await supabase.auth.admin.listUsers({
        page,
        perPage,
      });

    if (error) {
      throw new Error(
        `Failed fetching auth users: ${error.message}`,
      );
    }

    const users = data.users;

    if (!users.length) break;

    for (const user of users) {
      const email = user.email || "";

      const regex = new RegExp(
        `^tc\\.(\\d{5})@${schoolDomain}\\.es$`,
      );

      if (regex.test(email)) {
        const currentNumber =
          extractTeacherNumber(email);

        if (currentNumber > maxNumber) {
          maxNumber = currentNumber;
        }
      }
    }

    if (users.length < perPage) break;

    page++;
  }

  return maxNumber;
}

// ======================================================
// MAIN FUNCTION
// ======================================================

serve(async (req: Request) => {
  // ====================================================
  // HANDLE OPTIONS
  // ====================================================

  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  // ====================================================
  // ONLY ALLOW POST
  // ====================================================

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({
        success: false,
        message: "Method not allowed",
      }),
      {
        status: 405,
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  }

  try {
    // ==================================================
    // PARSE BODY
    // ==================================================

    const body: RequestBody = await req.json();

    const {
      school_id,
      subject_id,
      subject_name,
      users,
    } = body;

    // ==================================================
    // VALIDATION
    // ==================================================

    if (!school_id) {
      return new Response(
        JSON.stringify({
          success: false,
          message: "school_id is required",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    if (!subject_id) {
      return new Response(
        JSON.stringify({
          success: false,
          message: "subject_id is required",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    if (!subject_name) {
      return new Response(
        JSON.stringify({
          success: false,
          message: "subject_name is required",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    if (!Array.isArray(users) || users.length === 0) {
      return new Response(
        JSON.stringify({
          success: false,
          message:
            "users array is required and cannot be empty",
        }),
        {
          status: 400,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    // ==================================================
    // CHECK SCHOOL EXISTS
    // ==================================================

    const {
      data: school,
      error: schoolError,
    } = await supabase
      .from("schools")
      .select("id, school_domain")
      .eq("id", school_id)
      .single();

    if (schoolError || !school) {
      return new Response(
        JSON.stringify({
          success: false,
          message: "School not found",
        }),
        {
          status: 404,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    // ==================================================
    // CHECK SUBJECT EXISTS
    // ==================================================

    const {
      data: subject,
      error: subjectError,
    } = await supabase
      .from("subjects")
      .select("id")
      .eq("id", subject_id)
      .single();

    if (subjectError || !subject) {
      return new Response(
        JSON.stringify({
          success: false,
          message: "Subject not found",
        }),
        {
          status: 404,
          headers: {
            ...corsHeaders,
            "Content-Type": "application/json",
          },
        },
      );
    }

    const schoolDomain = school.school_domain;

    // ==================================================
    // GET LATEST TEACHER NUMBER
    // ==================================================

    let latestTeacherNumber =
      await getLatestTeacherNumber(
        schoolDomain,
      );

    // ==================================================
    // RESPONSE ARRAYS
    // ==================================================

    const success_users: any[] = [];
    const failed_users: any[] = [];

    // ==================================================
    // PROCESS TEACHERS
    // ==================================================

    for (const teacher of users) {
      try {
        // ==============================================
        // VALIDATE TEACHER
        // ==============================================

        if (!teacher.teacher_name) {
          failed_users.push({
            teacher_name: null,
            reason: "teacher_name is required",
          });

          continue;
        }

        if (!teacher.teacher_phone) {
          failed_users.push({
            teacher_name:
              teacher.teacher_name,
            reason: "teacher_phone is required",
          });

          continue;
        }

        // ==============================================
        // GENERATE EMAIL
        // ==============================================

        latestTeacherNumber++;

        const generatedEmail =
          generateTeacherEmail(
            latestTeacherNumber,
            schoolDomain,
          );

        // ==============================================
        // USE PHONE AS PASSWORD
        // ==============================================

        const teacherPassword =
          teacher.teacher_phone.trim();

        // ==============================================
        // CREATE AUTH USER
        // ==============================================

        const {
          data: authUser,
          error: authError,
        } = await supabase.auth.admin.createUser({
          email: generatedEmail,
          password: teacherPassword,
          email_confirm: true,
          user_metadata: {
            name: teacher.teacher_name,
          },
          app_metadata: {
            role: "teacher",
            subject_name,
            subject_id,
          },
        });

        if (authError || !authUser.user) {
          throw new Error(
            authError?.message ||
              "Failed creating auth user",
          );
        }

        const userId = authUser.user.id;

        // ==============================================
        // INSERT INTO public.users
        // ==============================================

        const { error: userInsertError } =
          await supabase
            .from("users")
            .insert({
              id: userId,
              school_id,
              role: "teacher",
              name: teacher.teacher_name,
              email: generatedEmail,
              phone: teacher.teacher_phone,
              status: "pending",
            });

        if (userInsertError) {
          // rollback auth user

          await supabase.auth.admin.deleteUser(
            userId,
          );

          throw new Error(
            `users insert failed: ${userInsertError.message}`,
          );
        }

        // ==============================================
        // INSERT INTO user_profiles
        // ==============================================

        const { error: profileError } =
          await supabase
            .from("user_profiles")
            .insert({
              user_id: userId,
              subject_id,
            });

        if (profileError) {
          // rollback users table

          await supabase
            .from("users")
            .delete()
            .eq("id", userId);

          // rollback auth user

          await supabase.auth.admin.deleteUser(
            userId,
          );

          throw new Error(
            `user_profiles insert failed: ${profileError.message}`,
          );
        }

        // ==============================================
        // SUCCESS
        // ==============================================

        success_users.push({
          teacher_name:
            teacher.teacher_name,
          generated_email:
            generatedEmail,
          password: teacherPassword,
          user_id: userId,
          status: "created",
        });
      } catch (teacherError: any) {
        failed_users.push({
          teacher_name:
            teacher.teacher_name,
          reason:
            teacherError?.message ||
            "Unknown error occurred",
        });
      }
    }

    // ==================================================
    // FINAL RESPONSE
    // ==================================================

    return new Response(
      JSON.stringify({
        success: true,
        message:
          "Teachers processed successfully",
        total_requested: users.length,
        total_success:
          success_users.length,
        total_failed:
          failed_users.length,
        success_users,
        failed_users,
      }),
      {
        status: 200,
        headers: {
          ...corsHeaders,
          "Content-Type":
            "application/json",
        },
      },
    );
  } catch (error: any) {
    // ==================================================
    // GLOBAL ERROR
    // ==================================================

    return new Response(
      JSON.stringify({
        success: false,
        message:
          error?.message ||
          "Internal server error",
      }),
      {
        status: 500,
        headers: {
          ...corsHeaders,
          "Content-Type":
            "application/json",
        },
      },
    );
  }
});

// Notes Before Production:
// 1] This function skips first teacher user in the school is he is first the first teacher ever

// Request body:
//
//{
//   "school_id": 1002,
//   "subject_id": 1000,
//   "subject_name": "Arabic",
//   "users": [
//     {
//       "teacher_name": "Ahmed Hassan",
//       "teacher_phone": "01012345678"
//     },
//     {
//       "teacher_name": "Sara Mohamed",
//       "teacher_phone": "01198765432"
//     },
//     {
//       "teacher_name": "John Smith",
//       "teacher_phone": "01222222222"
//     }
//   ]
// }