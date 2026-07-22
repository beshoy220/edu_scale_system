import { createClient } from "npm:@supabase/supabase-js@2";
import { JWT } from "npm:google-auth-library";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", {
      headers: corsHeaders,
    });
  }

  try {
    const { user_id, topic, title, body } = await req.json();

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );

    let token: string | null = null;

    // Sending to one user
    if (user_id) {
      const { data: user, error } = await supabase
        .from("users")
        .select("fcm_token")
        .eq("id", user_id)
        .single();

      if (error || !user?.fcm_token) {
        return new Response(
          JSON.stringify({
            error: "FCM token not found.",
          }),
          {
            status: 400,
            headers: corsHeaders,
          },
        );
      }

      token = user.fcm_token;

      // Save notification
      await supabase.from("user_notifications").insert({
        user_id,
        title,
        body,
      });
    }

    await sendFCM({
      token,
      topic,
      title,
      body,
    });

    return new Response(
      JSON.stringify({
        success: true,
      }),
      {
        headers: {
          ...corsHeaders,
          "Content-Type": "application/json",
        },
      },
    );
  } catch (e) {
    return new Response(
      JSON.stringify({
        error: e.message,
      }),
      {
        status: 500,
        headers: corsHeaders,
      },
    );
  }
});

async function sendFCM({
  token,
  topic,
  title,
  body,
}: {
  token?: string | null;
  topic?: string | null;
  title: string;
  body: string;
}) {
  const auth = new JWT({
    email: Deno.env.get("FIREBASE_CLIENT_EMAIL"),
    key: Deno.env.get("FIREBASE_PRIVATE_KEY")!.replace(/\\n/g, "\n"),
    scopes: [
      "https://www.googleapis.com/auth/firebase.messaging",
    ],
  });

  const { access_token } = await auth.authorize();

  const projectId = Deno.env.get("FIREBASE_PROJECT_ID");

  const message: any = {
    notification: {
      title,
      body,
    },
  };

  if (token) {
    message.token = token;
  } else if (topic) {
    message.topic = topic;
  } else {
    throw new Error("Either token or topic is required.");
  }

  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${access_token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        message,
      }),
    },
  );

  if (!response.ok) {
    throw new Error(await response.text());
  }
}


// Request body (those 2 request are vaild):
//
// {
//   "user_id": efo0-skks-mkdosf9932n9-vxvxv,
//   "title": "Assignment",
//   "body": "New assignment added",
// }
//
// {
//    "topic": "grade-1000-student",
//    "title": "Assignment",
//    "body": "Your assignment has been graded."
// }